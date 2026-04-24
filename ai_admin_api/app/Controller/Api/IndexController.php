<?php

declare(strict_types=1);

namespace App\Controller\Api;

use App\Controller\BaseController;
use App\Model\Article;
use App\Model\ArticleCategory;
use App\Model\Role;
use App\Request\Role\StoreRequest;
use App\Request\Role\UpdateRequest;
use Hyperf\DbConnection\Db;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Request;

#[Controller(prefix: 'api/v1/index'), Middleware('App\Middleware\UserAuthMiddleware')]
class IndexController extends BaseController
{
    #[RequestMapping(path: 'article', methods: 'get')]
    public function index(Request $request)
    {
        $page = $request->input('page', 1);
        $size = $request->input('size', 5);
        $name = $request->input('name', '');
        $articles = Db::table('articles')
            ->leftJoin('article_categories', 'articles.category_id', '=', 'article_categories.id')
            ->when($name, function ($query) use ($name) {
                $query->where('title', 'like', '%' . $name . '%');
            });
        $count = $articles->count();
        $articles = $articles->forPage($page, $size)->select(['articles.*', 'article_categories.name as cate_name'])->get();
        return $this->responseService->success([
            'total' => $count,
            'list' => $articles,
        ]);
    }

    #[RequestMapping(path: 'article_detail/{id}', methods: 'get')]
    public function store(StoreRequest $request, $id)
    {
        $article = Article::find($id);
        return $this->responseService->success($article);
    }

    #[RequestMapping(path: 'access_rate', methods: 'get')]
    public function access_rate(Request $request)
    {
        $auth = $request->input('Auth');
        if (! $auth) {
            return $this->responseService->error('未授权或用户不存在');
        }

        $masterId = $auth->master_id;

        // 获取所有标准对应的审核项目总数（以 folder_check_files 为准，过滤 master_id）
        $folderCounts = Db::table('folder_check_files')
            ->where('master_id', $masterId)
            ->groupBy(['standard_id'])
            ->select([Db::raw('count(*) as count'), 'standard_id'])
            ->pluck('count', 'standard_id')
            ->toArray();

        // 获取当前 master_id 下审核通过的项目数（audit_status = 1）
        $accessCounts = Db::table('folder_check_files as fcf')
            ->join('folders as f', 'f.id', '=', 'fcf.folder_id')
            ->where('f.master_id', $masterId)
            ->where('fcf.master_id', $masterId)
            ->where('f.audit_status', 1)
            ->groupBy(['fcf.standard_id'])
            ->select([Db::raw('count(*) as count'), 'fcf.standard_id'])
            ->pluck('count', 'fcf.standard_id')
            ->toArray();

        $rate = [];
        $standards = Db::table('standards')->get();
        foreach ($standards as $standard) {
            $currentTotal = (int)($folderCounts[$standard->id] ?? 0);
            $currentPassed = (int)($accessCounts[$standard->id] ?? 0);
            
            $rate[$standard->id]['percentage'] = $currentTotal > 0 ? round(($currentPassed / $currentTotal) * 100, 2) : 0;
            $rate[$standard->id]['completed'] = $currentPassed;
            $rate[$standard->id]['total'] = $currentTotal;
            $rate[$standard->id]['name'] = $standard->name;
        }

        // 计算全量进度（过滤 master_id）
        $allFolderCounts = Db::table('folder_check_files')
            ->where('master_id', $masterId)
            ->count();
        $allAccessCounts = Db::table('folder_check_files as fcf')
            ->join('folders as f', 'f.id', '=', 'fcf.folder_id')
            ->where('f.master_id', $masterId)
            ->where('fcf.master_id', $masterId)
            ->where('f.audit_status', 1)
            ->count();

        return $this->responseService->success([
            'standard_rates' => $rate,
            'all_rate' => [
                "percentage" => ($allFolderCounts > 0) ? round(($allAccessCounts / $allFolderCounts) * 100, 2) : 0,
                "completed" => $allAccessCounts,
                "total" => $allFolderCounts,
                "name" => "总计",
            ]
        ]);
    }
}
