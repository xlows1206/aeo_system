<?php

declare(strict_types=1);
/**
 * This file is part of Hyperf.
 *
 * @link     https://www.hyperf.io
 * @document https://hyperf.wiki
 * @contact  group@hyperf.io
 * @license  https://github.com/hyperf/hyperf/blob/master/LICENSE
 */

namespace App\Controller\Api;

use App\Controller\BaseController;
use App\Job\GetAiResult;
use App\Model\Audit;
use App\Model\AuditJson;
use App\Model\PreAudit;
use App\Model\PreAuditJson;
use App\Service\QueueService;
use Hyperf\DbConnection\Db;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;

#[Controller(prefix: 'api/v1/pre_audit'), Middleware('App\Middleware\UserAuthMiddleware')]
class PreAuditController extends BaseController
{
    #[Inject]
    protected QueueService $service;

    #[RequestMapping(path: '', methods: 'get')]
    public function index(RequestInterface $request)
    {
        $auth = $request->input('Auth');
        $userId = $auth->id;
        $masterId = $auth->master_id;

        $status = $request->input('status');
        $username = $request->input('username');
        $page = $request->input('page', 1);
        $pageSize = $request->input('pageSize', 10);
        $query = PreAudit::when(filled($status), function ($q) use ($status) {
            $q->where('pre_audits.status', $status);
        })->when(filled($username), function ($q) use ($username) {
            $q->join('users', 'users.id', '=', 'pre_audits.user_id');
            $q->where('users.username', 'like', "%{$username}%");
        })->when($auth->parent_id == 0, function ($q) use ($masterId) {
            $q->where('pre_audits.master_id', $masterId);
        }, function ($q) use ($userId) {
            $q->where('pre_audits.user_id', $userId);
        });

        $total = $query->count();
        $lists = $query->forPage($page, $pageSize)
            ->leftJoin('pre_audit_json', function ($q) {
                $q->on('pre_audit_json.pre_audit_id', '=', 'pre_audits.id');
                $q->whereColumn('pre_audit_json.number', '=', 'pre_audits.number');
            })
            ->with('user')->select('pre_audit_json.info', 'pre_audits.*')->latest()->get()->map(function ($i) {
                $i->userName = $i->user->username ?? '';
                $i->info = json_decode($i->info ?? '', true);
                return $i;
            });
        return $this->responseService->success([
            'list' => $lists,
            'page' => intval($page),
            'itemCount' => $total,
        ]);
    }

    #[RequestMapping(path: '{id}/log', methods: 'get')]
    public function log($id)
    {
        $lists = PreAuditJson::where('pre_audit_id', $id)->oldest()->get()->map(function ($i) {
            $aiResult = json_decode($i->ai_result ?? '', true);
            $i->ai_result = '';
            if (is_array($aiResult)) {
                $html = '';
                foreach ($aiResult as $index => $res) {
                    if (is_array($res) && isset($res['project'])) {
                        // 结构化展示：每个项目独立一行，带状态标签
                        $statusText = $res['status'] ? '合格' : '不合格';
                        $statusClass = $res['status'] ? 'color: #18a058; background: #e7f5ee;' : 'color: #d03050; background: #f9e7e9;';
                        $html .= "<div style='margin-bottom: 8px; padding: 6px; border-radius: 4px; border: 1px solid #eee;'>";
                        $html .= "<span style='padding: 2px 6px; border-radius: 4px; font-size: 12px; font-weight: bold; margin-right: 8px; {$statusClass}'>{$statusText}</span>";
                        $html .= "<span style='font-weight: bold; color: #333;'>【{$res['project']}】</span>";
                        $html .= "<div style='margin-top: 4px; margin-left: 54px; color: #666; font-size: 13px;'>{$res['text']}</div>";
                        $html .= "</div>";
                    } else {
                        // 兼容老数据（纯字符串数组）
                        $num = $index + 1;
                        $html .= "{$num}: {$res} <br/>";
                    }
                }
                $i->ai_result = $html;
            }
            return $i;
        });
        $currentCheckIds = [];
        $intData = [];
        $infos = [];
        
        // 获取最新的提交信息内容
        $latest = $lists->last();
        if ($latest) {
            $infos = json_decode($latest->info, true) ?: [];
        }

        foreach ($infos as $info) {
            if (isset($info['id'])) {
                $currentCheckIds[] = (int)$info['id'];
            }
            $data = $info['data'] ?? [];
            $infoIntData = array_filter($data, function ($v) {
                return is_int($v) || (is_string($v) && is_numeric($v));
            });
            $intData = array_merge($intData, $infoIntData);
        }
        $all_files = Db::table('files as f')
            ->leftJoin('folders as fo', 'fo.id', '=', 'f.folder_id')
            ->leftJoin('folder_check_files as fcf', 'fcf.folder_id', '=', 'f.folder_id')
            ->whereIn('f.id', $intData)
            ->select(['f.*', 'fcf.check_name as project_name', 'fo.name as folder_name'])
            ->get();

        // 获取该预审的最新一条 pre_audit_result 明细
        $masterId = Db::table('pre_audits')->where('id', $id)->value('master_id');
        $auditResults = Db::table('pre_audit_results as par')
            ->leftJoin('folder_check_files as fcf', 'fcf.id', '=', 'par.check_id')
            ->where('par.master_id', $masterId)
            ->whereIn('par.check_id', $currentCheckIds)
            ->select(['par.folder_name', 'par.result_str', 'par.is_access', 'par.check_id', 'fcf.check_type', 'fcf.check_name as project_name'])
            ->get()
            ->groupBy('project_name') // 改为按项目名称聚合
            ->map(function ($group) {
                $first = $group->first();
                $details = [];
                if ($first->result_str) {
                    $details = explode('; ', $first->result_str);
                }
                return [
                    'folder_name' => $first->project_name ?: $first->folder_name,
                    'is_access'   => $first->is_access,
                    'details'     => $details,
                    'check_type'  => $first->check_type ?? 0,
                ];
            })->values();

        return $this->responseService->success([
            'list'         => $lists,
            'all_files'    => $all_files,
            'audit_results' => $auditResults,
        ]);
    }

    #[RequestMapping(path: '', methods: 'post')]
    public function store(RequestInterface $request)
    {
        $auth = $request->input('Auth');

        $info = $request->input('info');

        foreach ($info as $k => $item){
            if(!$item){
                unset($info[$k]);
            }
        }
        $preAudit = new PreAudit();
        $preAudit->user_id = $auth->id;
        $preAudit->master_id = $auth->master_id;
        $preAudit->status = 0;
        $preAudit->number = 1;
        $preAudit->save();

        $preAuditJson = new PreAuditJson();
        $preAuditJson->pre_audit_id = $preAudit->id;
        $preAuditJson->info = json_encode($info);
        $preAuditJson->status = 0;
        $preAuditJson->number = 1;
        $preAuditJson->save();

        $this->service->getDrive()->push(new GetAiResult([
            'id' => $preAudit->id,
            'number' => 1
        ]));

        return $this->responseService->success();
    }

    #[RequestMapping(path: '{id}', methods: 'put')]
    public function update(RequestInterface $request, $id)
    {
        $info = $request->input('info');

        // 判断有无正在执行的检查任务
        $status = Db::table('pre_audit_json')->where('pre_audit_id', $id)->where('status', 0)->exists();
        if ($status) {
            return $this->responseService->error('有正在执行的检查任务，请等待完成后再提交');
        }

        $preAudit = PreAudit::find($id);
        $preAudit->status = 0;
        $preAudit->save();

        Db::table('pre_audits')->where('id', $id)->increment('number');

        $number = Db::table('pre_audits')->where('id', $id)->value('number');

        $preAuditJson = new PreAuditJson();
        $preAuditJson->pre_audit_id = $preAudit->id;
        $preAuditJson->info = json_encode($info, 320);
        $preAuditJson->status = 0;
        $preAuditJson->number = $number;
        $preAuditJson->save();

        $this->service->getDrive()->push(new GetAiResult([
            'id' => $preAudit->id,
            'number' => $number
        ]));

        return $this->responseService->success();
    }

    #[RequestMapping(path: '{id}/submitAudit', methods: 'post')]
    public function submitAudit(RequestInterface $request, $id)
    {
        $auth = $request->input('Auth');

        if (
            Db::table('audits')
                ->where('master_id', $auth->master_id)
                ->where('pre_audit_id', $id)
                ->where('status', '<>', 4)
                ->exists()
        ) {
            return $this->responseService->error('已经提交过审核了');
        }

        $preAudit = PreAudit::find($id);
        $info = Db::table('pre_audit_json')->where('pre_audit_id', $id)->latest()->value('info');

        $audit = new Audit();
        $audit->user_id = $preAudit->user_id;
        $audit->master_id = $preAudit->master_id;
        $audit->pre_audit_id = $id;
        $audit->status = 0;
        $audit->number = 1;
        $audit->save();

        $auditJson = new AuditJson();
        $auditJson->audit_id = $audit->id;
        $auditJson->info = $info;
        $auditJson->status = 0;
        $auditJson->number = 1;
        $auditJson->save();

        return $this->responseService->success();
    }
}
