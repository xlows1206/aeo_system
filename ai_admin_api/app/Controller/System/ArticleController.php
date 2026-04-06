<?php

declare(strict_types=1);

namespace App\Controller\System;

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

#[Controller(prefix: 'api/v1/admin/article'), Middleware('App\Middleware\UserAuthMiddleware')]
class ArticleController extends BaseController
{
    #[RequestMapping(path: '', methods: 'get')]
    public function index(Request $request)
    {
        $page = $request->input('page', 1);
        $size = $request->input('pageSize', 10);
        $title = $request->input('title', '');
        $articles = Db::table('articles')
            ->when($title, function ($query) use ($title) {
                $query->where('title', 'like', '%' . $title . '%');
            });
        $count = $articles->count();
        $articles = $articles->forPage($page, $size)->get();
        return $this->responseService->success([
            'page' => intval($page),
            'total' => $count,
            'list' => $articles,
        ]);
    }

    #[RequestMapping(path: '', methods: 'post')]
    public function store(Request $request)
    {
        $title = $request->input('title', '');
        $content = $request->input('content', '');
        $category_id = $request->input('category_id', 0);
        $article = new Article();
        $article->title = $title;
        $article->content = $content;
        $article->category_id = $category_id;
        $article->save();
        return $this->responseService->success();
    }

    #[RequestMapping(path: '{id}', methods: 'put')]
    public function update(Request $request, $id)
    {
        $article = Article::find($id);
        $title = $request->input('title', '');
        $content = $request->input('content', '');
        $category_id = $request->input('category_id', 0);
        $article->title = $title;
        $article->content = $content;
        $article->category_id = $category_id;
        $article->save();
        return $this->responseService->success();
    }

    #[RequestMapping(path: '{id}', methods: 'delete')]
    public function destroy($id)
    {
        Article::destroy($id);
        return $this->responseService->success();
    }

    #[RequestMapping(path: 'info/{id}', methods: 'get')]
    public function info($id)
    {
        $article = Article::find($id);
        return $this->responseService->success($article);
    }

    #[RequestMapping(path: 'createCategory', methods: 'post')]
    public function createCategory(Request $request)
    {
        $name = $request->input('name', '');
        $category = new ArticleCategory();
        $category->name = $name;
        $category->save();
        return $this->responseService->success();
    }

    #[RequestMapping(path: 'delCategory/{id}', methods: 'delete')]
    public function delCategory(Request $request, $id)
    {
        ArticleCategory::destroy($id);
        return $this->responseService->success();
    }

    #[RequestMapping(path: 'getCategories', methods: 'get')]
    public function getCategories()
    {
        $categories = ArticleCategory::all();
        return $this->responseService->success([
            'list' => $categories
        ]);
    }
}
