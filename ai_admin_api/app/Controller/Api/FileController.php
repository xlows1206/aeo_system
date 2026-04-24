<?php

declare(strict_types=1);

namespace App\Controller\Api;

use App\Controller\BaseController;
use App\Lib\Log;
use App\Model\Company;
use App\Model\File;
use App\Model\Folder;
use App\Support\FolderDisplayName;
use App\Service\ZipService;
use Hyperf\DbConnection\Db;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use function Hyperf\Support\env;

#[Controller(prefix: 'api/v1/file'), Middleware('App\Middleware\UserAuthMiddleware')]
class FileController extends BaseController
{
    #[RequestMapping(path: "projects/all", methods: "get")]
    public function allProjects(RequestInterface $request)
    {
        $standardId = (int)$request->input('standard_id', 0);
        $ignoreBind = (int)$request->input('ignore_bind', 0);
        $auth = $request->input('Auth');
        if (!$auth) {
            return $this->responseService->error('用户信息缺失，请重新登录');
        }
        $masterId = $auth->master_id;

        $query = Db::table('folder_check_files as fcf')
            ->join('folders as f', 'f.id', '=', 'fcf.folder_id')
            ->leftJoin('folders as p', 'p.id', '=', 'f.parent_id')
            ->leftJoin('folders as gp', 'gp.id', '=', 'p.parent_id')
            ->where('fcf.standard_id', $standardId)
            ->where('fcf.master_id', $masterId);

        // 如果是单项标准(ID=6)，根据公司设置的项目进行过滤
        if ($standardId === 6 && !$ignoreBind) {
            $company = Company::where('master_id', $masterId)->first();
            if ($company && !empty($company->bind_projects)) {
                $bindIds = explode(',', (string)$company->bind_projects);
                $query->whereIn('fcf.id', $bindIds);
            } else {
                // 新要求：如果没设置业务类型，默认不显示，避免全量展示造成混淆
                $query->whereRaw('1 = 0');
            }
        }

        $projects = $query->select('f.*', 'p.name as parent_name', 'gp.name as root_name', 'fcf.id as fcf_id', 'fcf.check_type')
            ->get();

        $processedFolders = [];
        $passedCount = 0;

        foreach ($projects as $f) {
            $status = (int)$f->audit_status;
            if ($status === 1) {
                $passedCount++;
            }

            $processedFolders[] = [
                'id' => 'f' . $f->id,
                'fcf_id' => (string)$f->fcf_id,
                'name' => FolderDisplayName::format($f->name, $f->parent_name, $f->root_name),
                'audit_status' => $status,
                'parent_id' => 'f' . $f->parent_id,
                'description' => $f->description ?? '',
                'check_type' => $f->check_type ?? 0,
            ];
        }

        $weights = [
            '一' => 1, '二' => 2, '三' => 3, '四' => 4, '五' => 5,
            '六' => 6, '七' => 7, '八' => 8, '九' => 9, '十' => 10,
        ];

        usort($processedFolders, function ($a, $b) use ($weights) {
            $charA = mb_substr($a['name'] ?? '', 0, 1);
            $charB = mb_substr($b['name'] ?? '', 0, 1);
            
            $weightA = $weights[$charA] ?? 99;
            $weightB = $weights[$charB] ?? 99;
            
            if ($weightA !== $weightB) {
                return $weightA <=> $weightB;
            }
            
            return strnatcmp($a['name'], $b['name']);
        });

        return $this->responseService->success([
            'list' => $processedFolders,
            'stats' => [
                'total' => count($processedFolders),
                'passed' => $passedCount,
            ],
        ]);
    }

    #[RequestMapping(path: "", methods: "get")]
    public function index(RequestInterface $request)
    {
        $auth = $request->input('Auth');
        if (!$auth) {
            return $this->responseService->error('用户信息缺失，请重新登录');
        }
        $userId = $auth->id;
        $masterId = $auth->master_id;

        $page = $request->input('page', 1);
        $size = $request->input('pageSize', 20);

        $folderId = $request->input('folder_id', 0);
        $standardId = (int)$request->input('standard_id', 0);
        $checkFolderIds = Db::table('folder_check_files')
            ->where('master_id', $masterId)
            ->pluck('folder_id')
            ->map(fn ($id) => (int)$id)
            ->toArray();
        $checkFolderIdMap = array_flip($checkFolderIds);
        $folder = Folder::find($folderId);

        $paths = [['id' => 0, 'name' => '全部']];
        if ($folder) {
            $ancestorPaths = $folder->getAncestorsAndSelf()
                ->map(function ($item) use ($checkFolderIdMap) {
                    if (isset($checkFolderIdMap[(int)$item->id])) {
                        $item->name = FolderDisplayName::format($item->name, null);
                    }

                    return $item;
                })
                ->toArray();

            $pathNameMap = [];
            foreach ($ancestorPaths as $pathItem) {
                $pathNameMap[(int)$pathItem->id] = $pathItem->name;
            }
            foreach ($ancestorPaths as &$pathItem) {
                if (isset($checkFolderIdMap[(int)$pathItem->id])) {
                    $pathItem->name = FolderDisplayName::format(
                        $pathItem->name,
                        $pathNameMap[(int)$pathItem->parent_id] ?? null
                    );
                }
            }
            unset($pathItem);

            $paths = array_merge($paths, $ancestorPaths);
        }

        $folderQuery = Db::table('folders')
            ->where('parent_id', $folderId)
            ->where('standard_id', $standardId)
            ->select('id', 'name', 'parent_id', Db::raw('1 as type'), Db::raw("'' as size"), Db::raw("'' as url"), Db::raw("'' as suffix"), 'updated_at');

        // 单项标准过滤
        if ((int)$standardId === 6) {
            $company = Company::where('master_id', $masterId)->first();
            if ($company && !empty($company->bind_projects)) {
                $bindIds = explode(',', (string)$company->bind_projects);
                
                // 获取所有被绑定的项目的文件夹ID
                $boundFolderIds = Db::table('folder_check_files')
                    ->whereIn('id', $bindIds)
                    ->pluck('folder_id')
                    ->toArray();

                if (!empty($boundFolderIds)) {
                    // 获取所有祖先节点
                    $ancestorFolderIds = Db::table('folder_closure')
                        ->whereIn('descendant', $boundFolderIds)
                        ->pluck('ancestor')
                        ->unique()
                        ->toArray();
                    
                    $folderQuery->whereIn('id', $ancestorFolderIds);
                } else {
                    // 如果虽然绑定了但是对应的文件夹没找到，保守起见过滤掉所有
                    $folderQuery->whereRaw('1 = 0');
                }
            } else {
                // 新要求：未设置业务主体性质时，单项标准路径下不展示任何文件夹
                $folderQuery->whereRaw('1 = 0');
            }
        }

        $folders = $folderQuery->get()
            ->map(function ($item) use ($checkFolderIdMap, $folder) {
                if (isset($checkFolderIdMap[(int)$item->id])) {
                    $item->name = FolderDisplayName::format($item->name, $folder?->name);
                }

                return $item;
            });

        $filesQuery = Db::table('files')
            ->when($auth->parent_id == 0, function ($q) use ($masterId) {
                // 主账号
                $q->where('master_id', $masterId);
            }, function ($q) use ($userId) {
                $q->where('user_id', $userId);
            })
            ->where('folder_id', $folderId)
            ->where('standard_id', $standardId)
            ->select('id', 'name', 'folder_id as parent_id', Db::raw('2 as type'), 'size', 'url', 'suffix', 'updated_at');

        $files = $filesQuery->get();
        $lists = $folders->concat($files)->values();
        $lists = $lists->sort(function ($a, $b) {
            if ((int)$a->type !== (int)$b->type) {
                return (int)$a->type <=> (int)$b->type;
            }

            return strtotime((string)$b->updated_at) <=> strtotime((string)$a->updated_at);
        })->values();
        $total = $lists->count();
        $lists = $lists->forPage((int)$page, (int)$size)->values();

        return $this->responseService->success([
            'list' => $lists,
            'page' => intval($page),
            'itemCount' => $total,
            'paths' => $paths
        ]);
    }

    #[RequestMapping(path: "lists", methods: "get")]
    public function lists(RequestInterface $request)
    {
        $auth = $request->input('Auth');
        if (!$auth) {
            return $this->responseService->error('用户信息缺失，请重新登录');
        }
        $userId = $auth->id;
        $standardId = (int)$request->input('standard_id', 0);
        $masterId = $auth->master_id;

        // 查询所有审核项目文件夹的 ID（以 folder_check_files 为权威来源，增加 master_id 过滤）
        $query = Db::table('folder_check_files')
            ->where('standard_id', $standardId)
            ->where('master_id', $masterId);
        
        // 如果是单项标准(ID=6)，进行过滤
        if ((int)$standardId === 6) {
            $company = Company::where('master_id', $masterId)->first();
            if ($company && !empty($company->bind_projects)) {
                $bindIds = explode(',', (string)$company->bind_projects);
                $query->whereIn('id', $bindIds);
            }
        }

        $checkFolderIds = $query->pluck('folder_id')
            ->map(fn ($id) => (int)$id)
            ->toArray();
        $checkFolderIdMap = array_flip($checkFolderIds);

        $folderQuery = Db::table('folders as f')
            ->leftJoin('folders as p', 'p.id', '=', 'f.parent_id')
            ->leftJoin('folders as gp', 'gp.id', '=', 'p.parent_id')
            ->leftJoin('folder_check_files as fcf', function($join) use ($masterId) {
                $join->on('fcf.folder_id', '=', 'f.id')
                    ->where('fcf.master_id', '=', $masterId);
            })
            ->where('f.standard_id', $standardId)
            ->where('f.master_id', $masterId)
            ->select('f.*', 'p.name as p_name', 'gp.name as gp_name', 'fcf.check_type');

        // 单项标准树形过滤
        if ((int)$standardId === 6) {
            $company = Company::where('master_id', $masterId)->first();
            if ($company && !empty($company->bind_projects)) {
                if (!empty($checkFolderIds)) {
                    $ancestorFolderIds = Db::table('folder_closure')
                        ->whereIn('descendant', $checkFolderIds)
                        ->pluck('ancestor')
                        ->unique()
                        ->toArray();
                    $folderQuery->whereIn('f.id', $ancestorFolderIds);
                } else {
                    $folderQuery->whereRaw('1 = 0');
                }
            } else {
                // 新要求：左侧树状结构也同步隐藏
                $folderQuery->whereRaw('1 = 0');
            }
        }

        $folders = $folderQuery->get();

        $folderNameMap = $folders->pluck('name', 'id')->toArray();

        $folders = $folders
            ->map(function ($i) use ($checkFolderIds, $checkFolderIdMap, $folderNameMap) {
                $name = $i->name;
                if (isset($checkFolderIdMap[(int)$i->id])) {
                    $name = FolderDisplayName::format($i->name, $i->p_name ?? null, $i->gp_name ?? null);
                }

                return [
                    'id'              => 'f' . $i->id,
                    'type'            => 'folder',
                    'parent_id'       => 'f' . $i->parent_id,
                    'name'            => $name,
                    'is_check_folder' => isset($checkFolderIdMap[(int)$i->id]),
                    'audit_status'    => $i->audit_status,
                    'check_type'      => $i->check_type ?? 0,
                ];
            })
            ->toArray();

        $files = Db::table('files')
            ->when($auth->parent_id == 0, function ($q) use ($masterId) {
                // 主账号
                $q->where('master_id', $masterId);
            }, function ($q) use ($userId) {
                $q->where('user_id', $userId);
            })
            ->where('standard_id', $standardId)
            ->get()
            ->map(function ($i) {
                return [
                    'id'        => $i->id,
                    'type'      => 'file',
                    'parent_id' => 'f' . $i->folder_id,
                    'name'      => $i->name,
                ];
            })
            ->toArray();

        $totalCount = count($folders);
        $passedCount = collect($folders)->where('audit_status', 1)->count();

        return $this->responseService->success([
            'tree' => buildTree(array_merge($folders, $files, [['id' => 'f0', 'name' => '根目录', 'type' => 'folder', 'parent_id' => 'x']])),
            'stats' => [
                'total' => $totalCount,
                'passed' => $passedCount,
            ]
        ]);

    }

    #[RequestMapping(path: "standard", methods: "get")]
    public function standard(RequestInterface $request)
    {
        $auth = $request->input('Auth');
        if (!$auth) {
            return $this->responseService->error('用户信息缺失，请重新登录');
        }
        $standing = $auth->standing;
        $roleId = $auth->role_id;
        $parentId = $auth->parent_id;
        $enterprise = $auth->enterprise;
        $permissionPaths = Db::table('role_permission as rp')
            ->leftJoin('permissions as p', 'p.id', '=', 'rp.permission_id')
            ->where('rp.role_id', $roleId)
            ->pluck('p.path')
            ->toArray();
        $lists = Db::table('standards')
            ->when(filled($standing), function ($q) use ($permissionPaths, $standing, $parentId, $enterprise) {
                if ($standing > 1) {
                    if ($parentId == 0) {
                        // 主账号
                        if ($enterprise == 1) {
                            $where = [1];
                        } else {
                            $where = [1, 2];
                        }
                        $q->whereIn('type', $where);
                    } else {
                        $q->whereIn('permission_path', $permissionPaths)->orWhere('name', '全部');
                    }
                }
            })
            ->get();

        return $this->responseService->success([
            'lists' => $lists
        ]);
    }

    #[RequestMapping(path: "allStandard", methods: "get")]
    public function allStandard(RequestInterface $request)
    {
        $auth = $request->input('Auth');

        if ($auth->enterprise == 1) {
            $where = [1];
        } else {
            $where = [1, 2];
        }
        $lists = Db::table('standards')
            ->whereIn('type', $where)
            ->get()
            ->map(function ($i) {
                $i->parent_id = $i->type == 1 ? 't1' : 't2';
                return $i;
            });

        if ($auth->enterprise == 1) {
            $lists = $lists->prepend(collect(
                ['id' => 't1', 'name' => '通用', 'parent_id' => 'x']
            ))->toArray();
        } else {
            $lists = $lists->prepend(collect(
                ['id' => 't2', 'name' => '单项', 'parent_id' => 'x']
            ))->prepend(collect(
                ['id' => 't1', 'name' => '通用', 'parent_id' => 'x']
            ))->toArray();
        }

        return $this->responseService->success(buildTree($lists));
    }

    #[RequestMapping(path: "", methods: "post")]
    public function store(RequestInterface $request)
    {
        $auth = $request->input('Auth');
        $userId = $auth->id;
        $masterId = $auth->master_id;

        $name = $request->input('name');
        $folderId = $request->input('folder_id');
        $standardId = (int)$request->input('standard_id');

        $count = Db::table('files')
            ->where('user_id', $userId)
            ->where('folder_id', $folderId)
            ->where('standard_id', $standardId)
            ->where('name', 'like', "$name%")
            ->count();

        $suffix = explode('.', $name);
        $suffix = end($suffix);

        if ($count > 0) {
            $name = $name . '_' . "($count)";
        }

        $file = new File();
        $file->name = $name;
        $file->url = $request->input('url');
        $file->size = transmit_file_size($request->input('size', 0));
        $file->suffix = $suffix;
        $file->folder_id = $folderId;
        $file->standard_id = $standardId;
        $file->user_id = $userId;
        $file->master_id = $masterId;
        $file->save();

        return $this->responseService->success();
    }

    #[RequestMapping(path: "{id}/copy", methods: "post")]
    public function copy(RequestInterface $request, $id)
    {
        $auth = $request->input('Auth');
        $userId = $auth->id;
        $masterId = $auth->master_id;

        $oldFile = File::find($id);

        $file = new File();
        $file->name = $oldFile->name . '_副本';
        $file->url = $oldFile->url;
        $file->suffix = $oldFile->suffix;
        $file->size = $oldFile->size;
        $file->folder_id = $oldFile->folder_id;
        $file->standard_id = $oldFile->standard_id;
        $file->user_id = $userId;
        $file->master_id = $masterId;
        $file->save();

        return $this->responseService->success();
    }

    #[RequestMapping(path: "{id}/rename", methods: "patch")]
    public function rename(RequestInterface $request, $id)
    {
        $file = File::find($id);
        $file->name = $request->input('name');
        $file->save();
        return $this->responseService->success();
    }

    #[RequestMapping(path: "{id}", methods: "delete")]
    public function destroy($id)
    {
        File::destroy($id);
        return $this->responseService->success();
    }

    #[RequestMapping(path: "{id}/move", methods: "patch")]
    public function move(RequestInterface $request, $id)
    {
        $file = File::find($id);
        $file->folder_id = $request->input('folder_id');
        $file->save();
        return $this->responseService->success();
    }

    #[RequestMapping(path: "getFileById", methods: "post")]
    public function getFileById(RequestInterface $request)
    {
        $ids = $request->input('ids');
        $files = Db::table('files')->whereIn('id', $ids)->get();
        return $this->responseService->success([
            'lists' => $files
        ]);
    }

    #[RequestMapping(path: "downloadPassedPackage", methods: "get")]
    public function downloadPassedPackage(RequestInterface $request, ZipService $zipService)
    {
        $auth = $request->input('Auth');
        $masterId = $auth->master_id;
        $standardId = (int)$request->input('standard_id', 0);

        try {
            $zipPath = $zipService->packagePassedFiles((int)$masterId, (int)$standardId);
            $fileName = "AEO资料包_" . date('YmdHis') . ".zip";
            return $this->responseService->download($zipPath, $fileName);
        } catch (\Exception $e) {
            return $this->responseService->error($e->getMessage());
        }
    }
}
