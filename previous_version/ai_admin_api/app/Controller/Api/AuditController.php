<?php

declare(strict_types=1);

namespace App\Controller\Api;

use App\Controller\BaseController;
use App\Model\Audit;
use App\Model\AuditJson;
use Hyperf\DbConnection\Db;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;

#[Controller(prefix: 'api/v1/audit'), Middleware('App\Middleware\UserAuthMiddleware')]
class AuditController extends BaseController
{
    #[RequestMapping(path: "", methods: "get")]
    public function index(RequestInterface $request)
    {
        $auth = $request->input('Auth');
        $userId = $auth->id;
        $masterId = $auth->master_id;
        $parentId = $auth->parent_id;
        $isCustoms = $auth->isCustoms();

        $status = $request->input('status');
        $companyName = $request->input('companyName');
        $page = $request->input('page', 1);
        $pageSize = $request->input('pageSize', 10);
        $query = Audit::when(filled($status), function ($q) use ($status) {
            $q->where('audits.status', $status);
        })->when(filled($companyName), function ($q) use ($companyName) {
            $q->join('company_info', 'company_info.master_id', '=', 'audits.master_id');
            $q->where('company_info.company_name', 'like', "%$companyName%");
        })->when(!$isCustoms, function ($q) use ($parentId, $masterId, $userId) {
            $q->when($parentId == 0, function ($q) use ($masterId) {
                $q->where('audits.master_id', $masterId);
            }, function ($q) use ($userId) {
                $q->where('audits.user_id', $userId);
            });
        });

        $total = $query->count();
        $lists = $query->forPage($page, $pageSize)
            ->leftJoin('audit_json', function ($q) {
                $q->on('audit_json.audit_id', '=', 'audits.id');
                $q->whereColumn('audit_json.number', '=', 'audits.number');
            })
            ->with(['user', 'company'])->select('audit_json.info', 'audits.*')->get()->map(function ($i) {
                $i->userName = $i->user->username ?? '';
                $enterprise = $i->user->enterprise ?? 1;
                $i->enterprise = $enterprise == 1 ? '通用' : '通用+单项';
                $i->companyName = $i->company->company_name ?? '';
                $i->info = json_decode($i->info ?? '', true);
                return $i;
            });
        return $this->responseService->success([
            'list' => $lists,
            'page' => intval($page),
            'itemCount' => $total,
        ]);
    }

    #[RequestMapping(path: "{id}/log", methods: "get")]
    public function log($id)
    {
        $lists = AuditJson::where('audit_id', $id)->oldest()->get();
        return $this->responseService->success([
            'list' => $lists,
        ]);
    }

    #[RequestMapping(path: "{id}/revocation", methods: "patch")]
    public function revocation($id)
    {
        $audit = Audit::find($id);
        $audit->status = 4;
        $audit->save();
        return $this->responseService->success();
    }

    #[RequestMapping(path: "{id}", methods: "put")]
    public function update(RequestInterface $request, $id)
    {
        $info = $request->input('info');
        $result = $request->input('result');
        $status = $request->input('status');

        $audit = Audit::find($id);
        $audit->status = $status;
        $audit->number = Db::raw('number + 1');
        $audit->save();

        $auditJson = new AuditJson();
        $auditJson->audit_id = $audit->id;
        $auditJson->info = json_encode($info);
        $auditJson->status = $status;
        $auditJson->result = $result;
        $auditJson->number = Db::table('audits')->where('id', $id)->value('number');
        $auditJson->save();

        return $this->responseService->success();
    }
}
