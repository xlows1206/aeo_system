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
             style="border-top-right-radius: 10px;border-bottom-right-radius: 10px;">
          <n-flex
            class="flex flex-row justify-between items-center"
            style="padding: 20px 20px;border-bottom-right-radius: 10px;background: #ffffff">
            <div class="flex gap-2">
              <v-upload
                ref="uploadRef"
                v-permission="{ action: ['pan.store'] }"
                :searchParams="params.searchParams"
                @reload="reloadTable"
              ></v-upload>
<!--              <div>-->
<!--                <n-button-->
<!--                  style="border-radius: 5px !important"-->
<!--                  v-permission="{ action: ['pan.store'] }" @click="openNewFolder">-->
<!--                  <n-icon class="mr-1 text-xl">-->
<!--                    <FolderAddOutlined/>-->
<!--                  </n-icon>-->
<!--                  新建文件夹-->
<!--                </n-button>-->
<!--              </div>-->
              <n-button
                style="border-radius: 5px !important"
                @click="toHelp">
                <n-icon class="mr-1">
                  <HelpOutline/>
                </n-icon>
                帮助文档
              </n-button>
            </div>

            <n-icon
              class="cursor-pointer"
              @click="reloadTable"
              size="20" color="#D6B164">
              <RefreshCcw/>
            </n-icon>
          </n-flex>

          <div
            v-if="!params.companyPersonnel && params.activeName == '人事'"
            class="bg-white p-4 headerText flex items-center" style="border-top: 1px solid #F9EBA9">
            <TriangleAlert
              size="20"
              class="mr-1"
              color="#93694C"/>
            <span class="mr-2">主要负责人员未设置，请先设置主要负责人员信息</span>
            <n-button size="small" @click="toSettingPersonnel">去设置</n-button>
          </div>

          <div
            v-if="params.activeName == '财务'"
            class="bg-white p-4 headerText flex items-center" style="border-top: 1px solid #F9EBA9">
            公司存续年份：
            <n-input-number style="width: 100px" :min="0" :max="1000" v-model:value="params.companyPersonnelInfo.duration_year"></n-input-number>
            <n-button class="ml-2" style="border-radius: 5px !important" @click="saveCompanyDurationYear">保存
            </n-button>

            报关单总数：
            <n-input-number style="width: 100px" :min="0" v-model:value="params.companyPersonnelInfo.not_self_total"></n-input-number>
            <n-button class="ml-2" style="border-radius: 5px !important" @click="saveCompanyNotSelfTotal">保存
            </n-button>
          </div>

          <div
            v-if="params.companyPersonnel && params.companyPersonnelInfo.enterprise_person_name != ''  && params.activeName == '人事'"
            class="bg-white p-4 headerText flex items-center" style="border-top: 1px solid #F9EBA9">
            <span class="mr-2">企业法定代表人：{{
                params.companyPersonnelInfo.enterprise_person_name
              }}</span>
            <span class="mr-2">主要负责人员：{{
                params.companyPersonnelInfo.principal_person_name
              }}</span>
            <span class="mr-2">财务负责人：{{
                params.companyPersonnelInfo.financial_person_name
              }}</span>
            <span class="mr-2">关务负责人：{{
                params.companyPersonnelInfo.customs_person_name
              }}</span>
          </div>

          <div style="padding: 10px 20px ;background: #ffffff;border-top: 1px solid #F9EBA9">
            <n-breadcrumb>
              <n-breadcrumb-item
                v-for="(item, index) in params.paths"
                :key="index"
                @click="handleClickFolder(item.id)"
              ><span style="color: #9C6643">{{ item.name }}</span>
              </n-breadcrumb-item>
            </n-breadcrumb>
          </div>
          <div
            class="custom-table"
            style="padding: 0 0 20px 0">
            <BasicTable
              :columns="columns"
              :request="loadDataTable"
              ref="actionRef"
              :actionColumn="actionColumn"
            >
            </BasicTable>
          </div>
        </div>
      </div>
    </div>

    <n-modal v-model:show="params.showModal" preset="dialog" title="Dialog">
      <template #header>
        <div>{{ params.modelTitle }}</div>
      </template>
      <n-form
        ref="formFolderRef"
        :model="params.folderData"
        :rules="params.folderRules"
        label-placement="left"
        label-width="auto"
        require-mark-placement="right-hanging"
        :style="{
          maxWidth: '640px',
        }"
      >
        <n-form-item label="名称" path="name">
          <n-input v-model:value="params.folderData.name"/>
        </n-form-item>
      </n-form>
      <template #action>
        <n-button type="primary" @click="handleValidateButtonClick" :loading="params.folderLoading">
          保存
        </n-button>
      </template>
    </n-modal>

    <v-move ref="moveRef"
            :fileType="params.currentFileType == 1 ? 'folder' : 'file'"
            :id="params.currentFileId" @reload="reloadTable"></v-move>
  </div>
</template>

<script lang="ts" setup>
import {ref, reactive, h} from 'vue';
import {BasicTable, TableAction} from '@/components/Table';
import {FolderAddOutlined} from '@vicons/antd'
import {HelpOutline} from '@vicons/ionicons5'
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
} from '@/api/system/pan';
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
  companyPersonnel: true,
  companyPersonnelInfo: {
    enterprise_person_name: '',
    principal_person_name: '',
    financial_person_name: '',
    customs_person_name: '',
    duration_year: null,
    not_self_total: 0,
  },
});

const actionColumn = reactive({
  width: 80,
  title: '操作',
  key: 'action',
  fixed: 'right',
  render(record) {
    if(record.type === 1){
      return
    }
    return h(TableAction as any, {
      style: 'button',
      dropDownActions: [
        {
          label: '重命名',
          key: 'rename',
          ifShow: () => {
            return true;
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
        // {
        //   label: '移动',
        //   key: 'moveFolder',
        //   ifShow: () => {
        //     return record.type === 1;
        //   },
        //   auth: ['pan.update'],
        // },
        {
          label: '移动',
          key: 'moveFile',
          ifShow: () => {
            return record.type === 2;
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
          // 根据业务控制是否显示 isShow 和 auth 是并且关系
          ifShow: () => {
              return true;
          },
          // 根据权限控制是否显示: 有权限，会显示，支持多个
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
    case 'moveFolder':
      params.currentFileType = 1;
      params.currentFileId = record.id;
      moveRef.value.openModal();
      break;
    case 'moveFile':
      params.currentFileType = 2;
      params.currentFileId = record.id;
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
  if (params.searchParams.standard_id === 0) {
    return false;
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
  actionRef.value.reload();
};

const saveCompanyDurationYear = () => {
  apiUpdateCompanyDurationYear({
    duration_year: params.companyPersonnelInfo.duration_year,
  }).then(() => {
    window.$message.success('保存成功');
  })
}

const saveCompanyNotSelfTotal = () => {
  apiSaveCompanyNotSelfTotal({
    not_self_total: params.companyPersonnelInfo.not_self_total,
  }).then(() => {
    window.$message.success('保存成功');
  })
}

const handleClickFolder = (id: number) => {
  params.searchParams.folder_id = id;
  actionRef.value.reload();
};

apiGetStandard().then((res) => {
  res.lists.forEach(item => {
    params.fileLists.push(item)
  })
  params.searchParams.standard_id = params.fileLists[0] ? params.fileLists[0].id : 0;
  actionRef.value.reload();
  if (params.fileLists.length > 0) {
    params.activeId = params.fileLists[0]?.id;
    params.activeName = params.fileLists[0]?.name;
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
</style>
