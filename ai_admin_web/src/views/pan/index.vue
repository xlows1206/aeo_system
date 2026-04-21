<template>
  <div class="main">
    <div
      class="rounded-md shadow-md"
      @paste="handlePaste"
      style="
      display: flex;flex-direction: row;
      border: 1px solid #F9EBA9; border-radius: 10px;margin: 20px">

      <div class="left" style="width: 150px !important;border-right: 1px solid #F9EBA9;
      background: #ffffff;border-top-left-radius: 10px;border-bottom-left-radius: 10px;">
        <n-list
          :show-divider="false"
          style="background: #FBFAEF;width: 100%;border-radius: 10px;">
          <div
            style="padding: 10px 20px;border-top-left-radius: 10px;border-bottom: 1px solid #F9EBA9;">
            <span class="headerText">我的文件</span>
          </div>
          <div style="background: #ffffff; padding: 0 10px;
          border-bottom-left-radius: 15px;height: calc(100% - 40px);overflow-y: auto">
            <n-list-item
              v-for="(item, index) in params.fileLists" :key="index">
              <n-button
                style="width: 100%;justify-content:left"
                :type="item.id === params.activeId ? 'info' : ''"
                @click="changeFileList(item.id, item.name)"
              >{{ item.name }}
              </n-button>
            </n-list-item>
          </div>
        </n-list>
      </div>
      <div class="right"
           style="width: calc(100% - 150px);border-top-right-radius: 10px;border-bottom-right-radius: 10px;">
        <div class="fileContent"
             style="border-top-right-radius: 10px;border-bottom-right-radius: 10px text-wrap: wrap;">
          <!-- 头部操作栏：仅在进入项目后显示 -->
          <!-- 头部操作栏：仅在进入项目后显示 -->
          <div
            v-if="!isAtProjectList"
            class="bg-white p-5 border-b border-gray-100"
            style="border-bottom-right-radius: 10px;"
          >
            <!-- 第一行：返回按钮与标题 -->
            <div class="flex items-center gap-4 mb-4">
              <n-button 
                style="border-radius: 5px !important; color: #fff !important;"
                type="primary"
                size="small"
                @click="handleClickFolder(0)"
              >
                <template #icon>
                  <n-icon color="#fff"><ArrowBack /></n-icon>
                </template>
                返回
              </n-button>
              <h2 class="text-xl font-bold text-gray-800 m-0 flex-1">
                {{ params.paths.length > 0 ? params.paths[params.paths.length - 1].name : '' }}
              </h2>
            </div>

            <!-- 第二行：操作按钮 -->
            <div class="flex items-center gap-3">
              <v-upload
                ref="uploadRef"
                v-permission="{ action: ['pan.store'] }"
                :searchParams="params.searchParams"
                :disabled="!canUpload.allowed"
                :tooltip="canUpload.reason"
                accept=".jpg,.jpeg,.png"
                @reload="reloadTable"
              ></v-upload>

              <n-button
                v-if="currentFolder?.example_url"
                style="border-radius: 5px !important"
                type="info"
                ghost
                @click="openExample"
              >
                <template #icon>
                  <n-icon class="text-lg"><HelpOutline/></n-icon>
                </template>
                查看示例
              </n-button>

              <n-button
                style="border-radius: 5px !important"
                v-permission="{ action: ['pan.store'] }" 
                @click="openNewFolder"
              >
                <template #icon>
                  <n-icon class="text-lg"><FolderAddOutlined/></n-icon>
                </template>
                新建文件夹
              </n-button>
            </div>

            <!-- 项目上传说明文本：当存在描述时显示 -->
            <n-alert
              v-if="!isAtProjectList && params.paths.length > 0"
              type="info"
              class="mt-4"
              :bordered="false"
              style="background-color: #fefce8; border-left: 4px solid #facc15; border-radius: 8px;"
            >
              <template #header>
                <div class="flex items-center gap-2 text-amber-800">
                  <span class="font-bold">文件上传说明</span>
                  <span v-if="isAiFolder" class="text-xs bg-red-100 text-red-600 px-2 py-0.5 rounded ml-2">⚠️ 仅支持图片格式</span>
                </div>
              </template>
              <div style="white-space: pre-wrap; color: #92400e; font-size: 14px; line-height: 1.6;">
                <div v-if="isAiFolder" class="mb-1 font-bold text-red-700">※ 注意：请务必上传清晰的图片（JPG/PNG），暂不支持 PDF。</div>
                {{ params.paths[params.paths.length - 1].description || '请上传相关审核资料。' }}
              </div>
            </n-alert>
          </div>

          <!-- 警告提示栏 -->
          <div
            v-if="!params.companyPersonnel && params.activeName == '人事'"
            class="bg-white p-4 headerText flex items-center" style="border-top: 1px solid #F9EBA9">
            <TriangleAlert size="20" class="mr-1" color="#93694C"/>
            <span class="mr-2">主要负责人员未设置，请先设置主要负责人员信息</span>
            <n-button size="small" @click="toSettingPersonnel">去设置</n-button>
          </div>


          <!-- 核心视图区 -->
          <div v-if="isAtProjectList" style="padding: 10px 20px 20px 20px;">
              <div class="mb-4 text-sm font-bold text-gray-500 flex items-center gap-10">
                 <div class="flex items-center gap-2">
                    <n-icon size="16"><ListOutline /></n-icon> 审核项目列表
                 </div>
                 <div v-if="params.allStats" class="flex items-center gap-1 text-xs">
                    <span class="text-gray-400">AI审核通过进度:</span>
                    <n-tag :bordered="false" size="small" type="primary" round>
                      {{ params.allStats.passed }}/{{ params.allStats.total }}
                    </n-tag>
                 </div>
              </div>
             
             <!-- 审核项目卡片列表 -->
             <div v-if="params.loadingProjects" class="flex justify-center p-8">
               <n-spin size="large" />
             </div>
             <div v-else-if="params.checkProjects.length === 0" class="flex justify-center p-8">
               <n-empty description="暂无审核项目" />
             </div>
             
             <!-- 审核项目列表：改为单行列表且可滚动 -->
             <div 
               v-else 
               style="max-height: calc(100vh - 250px); overflow-y: auto; padding-right: 8px;"
               class="grid grid-cols-1 gap-2"
             >
               <div 
                 v-for="project in params.checkProjects" 
                 :key="project.id" 
                 class="project-card flex items-center justify-between p-3 bg-white border border-yellow-100 rounded-lg cursor-pointer hover:shadow-sm hover:bg-amber-50/30 transition-all mb-1"
                 @click="handleClickFolder(project.id)"
               >
                  <div class="flex items-center gap-3 overflow-hidden">
                    <div class="flex items-center gap-3 overflow-hidden">
                      <n-icon size="20" color="#d4a017"><FolderOpenOutline /></n-icon>
                      <span class="text-gray-700 font-medium truncate">{{ project.name }}</span>
                    </div>
                    <!-- 审核状态标签 -->
                    <n-tag 
                      v-if="project.audit_status === 1" 
                      size="small" 
                      type="success" 
                      :bordered="false" 
                      round
                    >审核通过</n-tag>
                    <n-tag 
                      v-else-if="project.audit_status === 2" 
                      size="small" 
                      type="error" 
                      :bordered="false" 
                      round
                    >未通过</n-tag>
                    <n-tag 
                      v-else 
                      size="small" 
                      type="warning" 
                      :bordered="false" 
                      round
                    >待审核</n-tag>
                  </div>
                 <n-icon size="16" color="#ccc"><ChevronForward /></n-icon>
               </div>
             </div>
           </div>

          <!-- 文件管理表格视图 -->
          <div v-show="!isAtProjectList" class="p-4 bg-white relative">
            <!-- 信息不全引导卡片 -->
            <div 
              v-if="!canUpload.allowed" 
              class="mb-4 p-6 border-2 border-dashed border-red-200 bg-red-50/50 rounded-xl flex flex-col items-center justify-center text-center"
            >
              <TriangleAlert size="48" class="text-red-400 mb-3" />
              <div class="text-lg font-bold text-red-800 mb-2">基础信息不全，暂时无法上传资料</div>
              <div class="text-red-600 mb-4 max-w-md">
                当前项目需要比对[ {{ canUpload.missingLabel }} ]。检测到您尚未在“公司设置”中完善相关项，请先前往填写真实信息。
              </div>
              <n-button type="error" @click="toSettingPersonnel">
                立即前往公司设置
              </n-button>
            </div>

            <BasicTable
              v-else
              :columns="columns"
              :request="loadDataTable"
              ref="actionRef"
              :actionColumn="actionColumn"
            />
          </div>
        </div>
      </div>
    </div>

    <!-- 弹窗组件 -->
    <n-modal v-model:show="params.showModal" preset="dialog" :title="params.modelTitle">
       <n-form ref="formFolderRef" :model="params.folderData" label-placement="left" :style="{maxWidth: '640px'}">
         <n-form-item label="名称" path="name">
           <n-input v-model:value="params.folderData.name"/>
         </n-form-item>
       </n-form>
       <template #action>
         <n-button type="primary" @click="handleValidateButtonClick" :loading="params.folderLoading">确定</n-button>
       </template>
    </n-modal>
    
    <v-move ref="moveRef" :projectId="params.currentProjectId" @reload="reloadTable"></v-move>

    <!-- 示例图片查看弹窗 -->
    <n-modal v-model:show="params.showExample" preset="card" title="文件上传示例" style="width: 80%; max-width: 1000px">
      <div class="flex flex-col items-center gap-4">
        <n-alert type="warning" :bordered="false" class="w-full">
          此图仅为模板参考，上传时请提交您公司的真实材料图片。
        </n-alert>
        <div class="border rounded shadow-sm overflow-hidden bg-gray-100 w-full flex justify-center">
          <img :src="currentFolder?.example_url" style="max-height: 70vh; max-width: 100%; object-fit: contain;" />
        </div>
      </div>
      <template #footer>
        <div class="flex justify-center">
          <n-button type="primary" @click="params.showExample = false">我知道了</n-button>
        </div>
      </template>
    </n-modal>
  </div>
</template>


<script lang="ts" setup>
import {ref, reactive, h, computed, nextTick} from 'vue';
import {BasicTable, TableAction} from '@/components/Table';
import {FolderAddOutlined} from '@vicons/antd'
import {HelpOutline, ArrowBack, ListOutline, FolderOpenOutline, ChevronForward, SettingsOutline} from '@vicons/ionicons5'
import {columns, getFn} from './columns';
import {
  apiCopyFile,
  apiDeleteFile,
  apiDeleteFolder,
  apiGetPan,
  apiGetStandard,
  apiRenameFile,
  apiRenameFolder,
  apiStoreFolder,
  apiGetAllProjects,
  apiGetFolderLists,
} from '@/api/system/pan';
import { apiGetFileLists } from '@/api/system/pre';
import VUpload from '@/components/common/Upload.vue';
import VMove from '@/components/pan/Move.vue';
import {NIcon} from "naive-ui";
import {RefreshCcw, TriangleAlert} from "lucide-vue-next"
import {apiGetCompanyInfo, apiUpdateCompanyDurationYear, apiSaveCompanyNotSelfTotal} from "@/api/system/company";
import {useRouter} from "vue-router";

const router = useRouter();

const params = reactive({
  activeId: 1,
  activeName: '',
  fileLists: [],
  showModal: false,
  modelTitle: '',
  folderId: 0,
  editType: 0,
  folderData: {
    name: '',
  },
  allStats: {
    total: 0,
    passed: 0
  },
  search: {
    username: '',
  },
  folderLoading: false,
  folderRules: {
    name: {required: true, message: '请输入名称'},
  },
  paths: [],
  searchParams: {
    folder_id: 0,
    standard_id: 0,
  },
  currentFileId: 0,
  currentFileType: 0,
  currentProjectId: 0, // 当前项目 ID，用于移动限制
  companyPersonnel: true,
  companyPersonnelInfo: {
    enterprise_person_name: '',
    principal_person_name: '',
    financial_person_name: '',
    customs_person_name: '',
    duration_year: null,
    start_year: null,
    end_year: null,
    not_self_total: 0,
  },
  yearOptions: [] as any[],
  isEditingYear: false,
  isEditingTotal: false,
  checkProjects: [] as Array<{ id: number; name: string; audit_status?: number }>,
  loadingProjects: false,
  showExample: false,
});

// 计算属性：当前所在的文件夹信息
const currentFolder = computed(() => {
  if (params.paths.length > 0) {
    return params.paths[params.paths.length - 1];
  }
  return null;
});

// 计算属性：是否为 AI 审核相关的文件夹（根据名称模式识别）
const isAiFolder = computed(() => {
  const name = currentFolder.value?.name || '';
  return name.includes('无犯罪记录') || 
         name.includes('审计报告') || 
         name.includes('资产负债') || 
         name.includes('行政处罚') || 
         name.includes('被处罚');
});

// 信息完整度检查逻辑
const canUpload = computed(() => {
  const name = currentFolder.value?.name || '';
  const info = params.companyPersonnelInfo;
  
  // 1. 无犯罪记录类：需要负责人及法人姓名
  if (name.includes('无犯罪记录')) {
     if (!info.enterprise_person_name || !info.principal_person_name) {
       return { 
         allowed: false, 
         reason: '请先设置法人及主要负责人姓名', 
         missingLabel: '法人姓名、负责人姓名' 
       };
     }
  }
  
  // 2. 行政处罚/比率类：需要报关单总数
  if (name.includes('行政处罚') || name.includes('被处罚') || name.includes('金额')) {
     if (!info.not_self_total || Number(info.not_self_total) === 0) {
       return { 
         allowed: false, 
         reason: '请先设置非经自查报关单总数', 
         missingLabel: '报关单总数' 
       };
     }
  }

  // 3. 审计/资产类：需要年份设置
  if (name.includes('审计') || name.includes('资产负债')) {
     if (!info.start_year || !info.end_year) {
       return { 
         allowed: false, 
         reason: '请先设置审计开始/结束年份', 
         missingLabel: '公司存续年份' 
       };
     }
  }

  return { allowed: true, reason: '', missingLabel: '' };
});

const openExample = () => {
  params.showExample = true;
};

// 加载叶子节点作为审核项目列表
const loadCheckProjects = async () => {
  if (params.searchParams.standard_id === 0) return;
  params.loadingProjects = true;
  try {
    const res = await apiGetAllProjects({ standard_id: params.searchParams.standard_id });
    params.checkProjects = res?.list || [];
    params.allStats = res?.stats || { total: 0, passed: 0 };
  } catch (error) {
    console.error('Failed to load check projects:', error);
  } finally {
    params.loadingProjects = false;
  }
};


// 计算属性：是否在审核项目列表根目录
const isAtProjectList = computed(() => params.searchParams.folder_id === 0);

const generateYearOptions = () => {
  const currentYear = new Date().getFullYear();
  const options = [] as any[];
  for (let i = currentYear + 1; i >= currentYear - 10; i--) {
    options.push({
      label: `${i}年`,
      value: i,
    });
  }
  params.yearOptions = options;
};

generateYearOptions();

const actionColumn = reactive({
  width: 80,
  title: '操作',
  key: 'action',
  fixed: 'right',
  render(record) {
    if(record.type === 1 && !isAtProjectList.value){
       // 如果进入了项目内部，且当前行是文件夹，可以进行重命名或删除
       // 除非它是顶级项目本身（但顶级项目在进入后不会出现在列表行中，列表行里是子文件夹）
    } else if (record.type === 1 && isAtProjectList.value) {
       // 如果在根目录，文件夹是审核项目，隐藏所有常规操作（禁止删除/重命名）
       return null;
    }
    
    // 权限校验：顶级项目（parent_id == 0）禁止删除和重命名
    const isProject = record.type === 1 && (record.parent_id === 0 || record.parent_id === '0');

    return h(TableAction as any, {
      style: 'button',
      dropDownActions: [
        {
          label: '重命名',
          key: 'rename',
          ifShow: () => {
            return !isProject; // 项目禁止重命名
          },
          auth: ['pan.update'],
        },
        {
          label: '拷贝',
          key: 'copy',
          ifShow: () => {
            return record.type === 2;
          },
          auth: ['pan.update'],
        },
        {
          label: '移动',
          key: 'moveFile',
          ifShow: () => {
             // 仅限文件或子文件夹移动
            return !isProject;
          },
          auth: ['pan.update'],
        },
        {
          label: '下载',
          key: 'download',
          ifShow: () => {
            return record.type === 2;
          },
          auth: ['pan.update'],
        },
      ],
      select: (key: string) => {
        handleEdit(record, key);
      },
      actions: [
        {
          label: '删除',
          type: 'error',
          onClick: handleDelete.bind(null, record),
          ifShow: () => {
             return !isProject; // 项目禁止删除
          },
          auth: ['pan.delete'],
        },
      ],
    });
  },
});

const toHelp = () => {
  window.open('https://www.yuque.com/aaronwan/iqhxlb/defl4ogg76eanl9p#h3XAV');
};

const openNewFolder = () => {
  params.folderId = 0;
  params.folderData.name = '';
  params.showModal = true;
  params.modelTitle = '新建文件夹';
};

const formFolderRef: any = ref(null);
const actionRef: any = ref(null);
const handleValidateButtonClick = (e: MouseEvent) => {
  e.preventDefault();
  params.folderLoading = true;
  formFolderRef.value?.validate((errors) => {
    if (!errors) {
      if (params.folderId > 0) {
        if (params.editType === 1) {
          apiRenameFolder(
            {
              name: params.folderData.name,
            },
            params.folderId
          )
            .then(() => {
              params.folderData.name = '';
              params.folderLoading = false;
              params.showModal = false;
              window['$message'].success('操作成功');
              actionRef.value.reload();
            })
            .catch((err) => {
              window['$message'].error(err.message);
              params.folderLoading = false;
            });
        } else {
          apiRenameFile(
            {
              name: params.folderData.name,
            },
            params.folderId
          )
            .then(() => {
              params.folderData.name = '';
              params.folderLoading = false;
              params.showModal = false;
              window['$message'].success('操作成功');
              actionRef.value.reload();
            })
            .catch((err) => {
              window['$message'].error(err.message);
              params.folderLoading = false;
            });
        }
      } else {
        apiStoreFolder({
          name: params.folderData.name,
          parent_id: params.searchParams.folder_id,
          standard_id: params.searchParams.standard_id,
        })
          .then(() => {
            params.folderData.name = '';
            params.folderLoading = false;
            params.showModal = false;
            window['$message'].success('操作成功');
            actionRef.value.reload();
          })
          .catch((err) => {
            window['$message'].error(err.message);
            params.folderLoading = false;
          });
      }
    } else {
      params.folderLoading = false;
    }
  });
};

const moveRef: any = ref(null);
const handleEdit = (record: any, type: string) => {
  switch (type) {
    case 'rename':
      params.showModal = true;
      params.modelTitle = record.type === 1 ? '编辑文件夹' : '编辑文件名称';
      params.folderData.name = record.name;
      params.folderId = record.id;
      params.editType = record.type;
      break;
    case 'copy':
      apiCopyFile(record.id).then(() => {
        actionRef.value.reload();
      });
      break;
    case 'moveFile':
      params.currentFileType = record.type === 1 ? 'folder' : 'file';
      params.currentFileId = record.id;
      
      // 提取当前所属的项目 ID (paths 的第二项通常是顶级项目)
      if (params.paths.length >= 2) {
         params.currentProjectId = params.paths[1].id;
      }
      
      moveRef.value.openModal();
      break;
    case 'download':
      funDownload(record.url + '?attname=' + record.name + '.' + record.suffix);
      break;
  }
};

function handleDelete(record: Recordable) {
  window['$dialog'].info({
    title: '提示',
    content: `确定删除 ${record.name} ？`,
    positiveText: '确定',
    negativeText: '取消',
    onPositiveClick: () => {
      if (record.type === 1) {
        apiDeleteFolder(record.id).then(() => {
          window['$message'].info('删除成功');
          reloadTable();
        }).catch((err) => {
          window['$message'].error(err.message);
        });
      } else {
        apiDeleteFile(record.id).then(() => {
          window['$message'].info('删除成功');
          reloadTable();
        }).catch((err) => {
          window['$message'].error(err.message);
        });
      }
    },
    onNegativeClick: () => {
    },
  });
}

const funDownload = (url: string) => {
  const downloadElement = document.createElement('a');
  downloadElement.style.display = 'none';
  downloadElement.href = url;
  downloadElement.target = '_blank';
  document.body.appendChild(downloadElement);
  downloadElement.click();
  document.body.removeChild(downloadElement);
};

const reloadTable = () => {
  actionRef.value.reload();
};

const loadDataTable = async (res) => {
  if (params.searchParams.standard_id === 0 || params.searchParams.folder_id === 0) {
    return { list: [], itemCount: 0, paths: [], page: 1 };
  }
  const lists = await apiGetPan({...res, ...params.searchParams});
  params.paths = lists.paths;
  return lists;
};

const changeFileList = (id: number, name: string) => {
  params.activeId = id;
  params.activeName = name;
  params.searchParams.standard_id = id;
  params.searchParams.folder_id = 0;
  loadCheckProjects();
  if (actionRef.value) {
    actionRef.value.reload();
  }
};


const handleClickFolder = (id: string | number) => {
  // 如果 ID 是以 f 开头的（如 f123），则剥离前缀转为数字
  const targetId = typeof id === 'string' && id.startsWith('f') 
    ? parseInt(id.replace('f', ''), 10) 
    : Number(id);
    
  params.searchParams.folder_id = targetId;
  if (actionRef.value) {
    actionRef.value.reload();
  }
};

apiGetStandard().then((res) => {
  res.lists.forEach(item => {
    params.fileLists.push(item)
  })
  
  if (params.fileLists.length > 0) {
    params.activeId = params.fileLists[0]?.id;
    params.activeName = params.fileLists[0]?.name;
    // 显式赋值给搜索参数
    params.searchParams.standard_id = params.activeId;
    params.searchParams.folder_id = 0;
    
    loadCheckProjects();
  }
});

// 点击
const handleClick = (e) => {
  handleClickFolder(e.id);
};

getFn({
  handleClick,
});

const toSettingPersonnel = () => {
  router.push({name: 'system_company'})
}

const uploadRef = ref(null);
const handlePaste = (event) => {
  const clipboardItems = event.clipboardData.items
  for (const item of clipboardItems) {
    if (item.kind === 'file' && item.type.startsWith('image/')) {
      const file = item.getAsFile()
      uploadRef.value.customRequest({
        file: {
          name: file.name,
          size: file.size,
          type: file.type,
          lastModified: file.lastModified,
          webkitRelativePath: file.webkitRelativePath,
          file: file,
        },
        withCredentials: false,
        headers: {},
        onFinish: () => {
          window.$message.success('上传成功');
        },
        onError: () => {
        },
        onProgress: () => {
        },
      })
    }
  }
}

apiGetCompanyInfo().then(({data}) => {
  params.companyPersonnel = !!data;
  if (data) {
    params.companyPersonnelInfo = data;
  }
});
</script>

<style scoped lang="less">
.headerText {
  color: #93694C;
}

.custom-table {
  :deep(.n-data-table-td) {
    padding: 12px 16px;
  }
}

.project-card {
  &:hover {
    .arrow-icon {
      color: #18a058 !important;
    }
  }
}
</style>
