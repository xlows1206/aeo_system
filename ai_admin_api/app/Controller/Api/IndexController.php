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

        $folderCounts = Db::table('folders as f')
            ->leftJoin('folders as ff', 'ff.parent_id', '=', 'f.id')
            ->whereNull('ff.id')
            ->groupBy(['f.standard_id'])
            ->select([Db::raw('count(*) as count'), 'f.standard_id'])
            ->pluck('count', 'f.standard_id')
            ->toArray();

        $accessCounts = Db::table('pre_audit_results as par')
            ->where('par.is_access', 1)
            ->where('par.master_id', $auth->master_id)
            ->groupBy(['par.standard_id'])
            ->select([Db::raw('count(*) as count'), 'par.standard_id'])
            ->pluck('count', 'par.standard_id')
            ->toArray();

        $rate = [];
        $standards = Db::table('standards')->get();
        foreach ($standards as $standard) {
            $rate[$standard->id]['percentage'] = (isset($accessCounts[$standard->id]) && isset($folderCounts[$standard->id])) ? round(($accessCounts[$standard->id] / $folderCounts[$standard->id]) * 100, 2) : 0;
            $rate[$standard->id]['completed'] = $accessCounts[$standard->id] ?? 0;
            $rate[$standard->id]['total'] = $folderCounts[$standard->id] ?? 0;
            $rate[$standard->id]['name'] = $standard->name;
        }

        $allFolderCounts = Db::table('folders as f')
            ->leftJoin('folders as ff', 'ff.parent_id', '=', 'f.id')
            ->whereNull('ff.id')
            ->count();

        $allAccessCounts = Db::table('pre_audit_results')
            ->where('master_id', $auth->master_id)
            ->where('is_access', 1)
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
