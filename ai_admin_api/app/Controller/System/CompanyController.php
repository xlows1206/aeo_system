<?php

declare(strict_types=1);

namespace App\Controller\System;

use App\Controller\BaseController;
use App\Model\Company;
use App\Request\Company\StoreRequest;
use Hyperf\DbConnection\Db;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;

#[Controller(prefix: 'api/v1/company'), Middleware('App\Middleware\UserAuthMiddleware')]
class CompanyController extends BaseController
{
    #[RequestMapping(path: "checkCompany", methods: "get")]
    public function checkCompany(RequestInterface $request)
    {
        $user = $request->getParsedBody()['Auth'] ?? $request->input('Auth');
        $company = Company::where('master_id', $user->master_id)->first();

        return $this->responseService->success([
            'data' => (bool)$company
        ]);
    }

    #[RequestMapping(path: "info", methods: "get")]
    public function info(RequestInterface $request)
    {
        $user = $request->getParsedBody()['Auth'] ?? $request->input('Auth');
        $company = Company::where('master_id', $user->master_id)->first();
        if ($company) {
            $data = $company->toArray();
            $data['company_types'] = $company->types ? explode(',', (string)$company->types) : [];
            $data['bind_projects'] = $company->bind_projects ? explode(',', (string)$company->bind_projects) : [];
            return $this->responseService->success([
                'data' => $data
            ]);
        }
        return $this->responseService->success([
            'data' => null
        ]);
    }

    #[RequestMapping(path: "", methods: "post")]
    public function store(StoreRequest $request)
    {
        try {
            $user = $request->getParsedBody()['Auth'] ?? $request->input('Auth');
            $masterId = $user->master_id;
            if (Company::where('master_id', '<>', $masterId)->where('company_name', $request->input('company_name'))->exists()) {
                return $this->responseService->error('企业名称已存在');
            }
            $company = Company::where('master_id', $masterId)->first();
            if (!$company) {
                $company = new Company();
                $company->master_id = $masterId;
            }
            $types = $request->input('company_types');
            $bindProjects = $request->input('bind_projects');
            $company->company_name = $request->input('company_name');
            $company->enterprise_person_name = $request->input('enterprise_person_name');
            $company->principal_person_name = $request->input('principal_person_name');
            $company->financial_person_name = $request->input('financial_person_name');
            $company->customs_person_name = $request->input('customs_person_name');
            $company->types = $types && is_array($types) ? join(',', $types) : '';
            $company->bind_projects = $bindProjects && is_array($bindProjects) ? join(',', $bindProjects) : '';

            // 整合所有公司配置字段到单一接口，防止并发保存产生的竞态冲突覆盖数据
            if ($request->has('start_year')) $company->start_year = $request->input('start_year');
            if ($request->has('end_year')) $company->end_year = $request->input('end_year');
            if ($request->has('duration_year')) $company->duration_year = $request->input('duration_year');
            if ($request->has('not_self_total')) $company->not_self_total = $request->input('not_self_total');

            $company->save();
            return $this->responseService->success();
        } catch (\Throwable $e) {
            return $this->responseService->error($e->getMessage());
        }
    }

    #[RequestMapping(path: "durationYear", methods: "put")]
    public function updateDurationYear(RequestInterface $request)
    {
        try {
            $user = $request->getParsedBody()['Auth'] ?? $request->input('Auth');
            $masterId = $user->master_id;
            $company = Company::where('master_id', $masterId)->first();
            if (!$company) {
                $company = new Company();
                $company->master_id = $masterId;
            }
            $company->duration_year = $request->input('duration_year');
            $company->start_year = $request->input('start_year');
            $company->end_year = $request->input('end_year');
            $company->save();
            return $this->responseService->success();
        } catch (\Throwable $e) {
            return $this->responseService->error($e->getMessage());
        }
    }

    #[RequestMapping(path: "notSelfTotal", methods: "put")]
    public function notSelfTotal(RequestInterface $request)
    {
        try {
            $user = $request->getParsedBody()['Auth'] ?? $request->input('Auth');
            $masterId = $user->master_id;
            $company = Company::where('master_id', $masterId)->first();
            if (!$company) {
                $company = new Company();
                $company->master_id = $masterId;
            }
            $company->not_self_total = $request->input('not_self_total');
            $company->save();
            return $this->responseService->success();
        } catch (\Throwable $e) {
            return $this->responseService->error($e->getMessage());
        }
    }
    #[RequestMapping(path: "types", methods: "get")]
    public function types()
    {
        $types = Db::table('company_types')->get()->map(function ($item){
            return [
                'value' => (string) $item->id, 
                'label' => $item->name,
                'bind_projects' => $item->note ? array_map('strval', explode(',', $item->note)) : []
            ];
        })->values()->toArray();
        return $this->responseService->success($types);
    }
}
