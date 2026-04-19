<template>
  <div>
    <n-card :bordered="false" class="proCard">
      <div class="custom-header-main w-full p-3
    rounded-md bg-white shadow-md gap-2
    flex justify-between items-center">
        <n-form
          inline
          :show-feedback="false"
          v-model:value="params.search"
          label-placement="left">
          <n-form-item label="提交人">
            <n-input
              style="width: 200px;"
              v-model:value="params.search.username"/>
          </n-form-item>
        </n-form>
        <n-button type="primary" @click="reloadTable">搜索</n-button>
      </div>

      <div class="flex items-center pt-5 pb-5 gap-4">
        <n-button v-permission="{ action: ['pre_audit.store'] }" type="primary" @click="addTable">
          <template #icon>
            <n-icon>
              <PlusOutlined/>
            </n-icon>
          </template>
          提交预审
        </n-button>
      </div>
      <div class="p-6">
        <div class="space-y-5">
      <div class="flex items-center justify-between">
        <div class="flex items-center gap-2">
          <span class="text-amber-800 font-medium">AI 审核通过进度</span>
          <span class="text-sm text-amber-600 font-medium">
            {{ params.totalRate.completed }}/{{ params.totalRate.total }} ({{ params.totalRate.percentage }}%)
          </span>
        </div>
        
        <!-- 下载AEO资料按钮 -->
        <n-button 
          type="warning" 
          secondary
          :disabled="params.totalRate.percentage < 100"
          @click="handleDownloadAEO"
        >
          <template #icon>
            <n-icon><DownloadOutlined /></n-icon>
          </template>
          下载 AEO 资料
        </n-button>
      </div>
            <n-progress
              type="line"
              :percentage="params.totalRate.percentage"
              indicator-placement="inside"
              :color="{ stops: ['#f59e0b', '#ea580c'] }"
              processing
            />
        </div>
      </div>
      <BasicTable
        :columns="columns"
        :request="loadDataTable"
        ref="actionRef"
        :actionColumn="actionColumn"
      >
      </BasicTable>

      <v-pre-audit-create
        ref="preAuditCreateRef"
        :drawerParams="params"
        @reloadTable="reloadTable"
      ></v-pre-audit-create>
      <v-pre-audit-info ref="preAuditCreateInfo" :drawerParams="params"></v-pre-audit-info>
    </n-card>
  </div>
</template>

<script lang="ts" setup>
import {ref, h, reactive} from 'vue';
import { useIntervalFn } from '@vueuse/core';
import {BasicTable, TableAction} from '@/components/Table';
import { FormSchema, useForm} from '@/components/Form/index';
import {columns} from './columns';
import {PlusOutlined, DownloadOutlined} from '@vicons/antd';
import VPreAuditCreate from '@/components/pre_audit/Create.vue';
import VPreAuditInfo from '@/components/pre_audit/Info.vue';
import {apiGetPreAudit, apiStoreSubmitAudit} from '@/api/system/pre';
import {NIcon} from "naive-ui";
import {apiAccessRate} from '@/api/system/home'
import {apiDownloadPassedPackage} from '@/api/system/pan'


const schemas: FormSchema[] = [
  {
    field: 'username',
    component: 'NInput',
    label: '审核人',
  },
  {
    field: 'status',
    label: '状态',
    slot: 'roleIdSlot',
  },
];

const formRef: any = ref(null);
const actionRef: any = ref(null);
const preAuditCreateRef: any = ref(null);
const preAuditCreateInfo: any = ref(null);

const actionColumn = reactive({
  width: 100,
  title: '操作',
  key: 'action',
  fixed: 'right',
  render(record) {
    return h(TableAction as any, {
      style: 'button',
      actions: [
        {
          label: '查看详情',
          onClick: handleInfo.bind(null, record),
          ifShow: () => {
            return true;
          },
          auth: ['pre_audit.info'],
        },

        // {
        //   label: '提交海关',
        //   type: 'success',
        //   onClick: handleSubmitPre.bind(null, record),
        //   // 根据业务控制是否显示 isShow 和 auth 是并且关系
        //   ifShow: () => {
        //     return record.status >= 2;
        //   },
        //   // 根据权限控制是否显示: 有权限，会显示，支持多个
        //   auth: ['pre_audit.submitAudit'],
        // },
      ],
    });
  },
});

const [register, {getFieldsValue}] = useForm({
  gridProps: {cols: '1 s:1 m:2 l:3 xl:4 2xl:4'},
  labelWidth: 80,
  schemas,
});

const params = reactive({
  title: '',
  data: {},
  type: '',
  status: [
    {label: '正在审核', value: 0},
    {label: '不达标', value: 1},
    {label: '不合格', value: 1},
    {label: '达标', value: 3},
  ],
  totalRate: {
    percentage : 0,
    completed:0,
    total : 0,
    name : '总计'
  },
  search: {
    username: '',
  }
});

function addTable() {
  params.title = '新建预审';
  params.data = {};
  params.type = 'add';
  preAuditCreateRef.value.openDrawer();
}

const loadDataTable = async (res) => {
  return await apiGetPreAudit({...params.search, ...res});
};

function reloadTable() {
  actionRef.value.reload();
  preAuditCreateRef.value?.closeDrawer();
}

function handleEdit(record: Recordable) {
  params.title = '编辑预审';
  params.data = record;
  params.type = 'edit';
  preAuditCreateRef.value.openDrawer();
}

function handleInfo(record: Recordable) {
  params.title = '审核详情';
  params.data = record;
  preAuditCreateInfo.value.openDrawer();
}

function handleSubmitPre(record: Recordable) {
  apiStoreSubmitAudit(record.id)
    .then(() => {
      window['$message'].success('操作成功');
    })
    .catch((err) => {
      window['$message'].error(err.message);
    });
}

const handleDownloadAEO = async () => {
  const msg = window['$message'].loading('正在打包资料，请稍候...', { duration: 0 });
  try {
    // 假设当前正在查看的标准ID在 params.search.standard_id 中，或者我们需要从 params.totalRate 获取
    // 从 pre_audit_results 表结构看，所有的项目对应一个 master_id
    // 我们这里传 0 表示打包所有或者您需要一个特定的 standard_id
    // 根据 IndexController，all_rate 统计的是全部，所以这里我们可能需要根据当前选中的标准来传参数
    // 或者目前需求是全量打包，我们可以不传或者后端默认全部
    const res: any = await apiDownloadPassedPackage({ standard_id: params.totalRate.id || 0 });
    const blob = new Blob([res], { type: 'application/zip' });
    const url = window.URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = `AEO审核通过资料_${new Date().getTime()}.zip`;
    link.click();
    window.URL.revokeObjectURL(url);
    msg.destroy();
    window['$message'].success('下载成功');
  } catch (error: any) {
    msg.destroy();
    window['$message'].error('打包失败: ' + (error.message || '未知错误'));
  }
}

const loadRate = () => {
  apiAccessRate().then(res => {
    params.totalRate = res.all_rate
  })
}

function handleSubmit(values: Recordable) {
  reloadTable();
}

loadRate()
function handleReset(values: Recordable) {
}

useIntervalFn(() => {
  if (actionRef.value) {
    const dataSource = actionRef.value.getDataSource();
    const hasPending = dataSource.some(item => item.status === 0);
    // 如果存在处于“正在审核”状态的任务，则触发静默拉取
    if (hasPending) {
        actionRef.value.reload({ showLoading: false });
        loadRate();
    }
  }
}, 10000); // 每 10 秒轮询一次
</script>

<style lang="less" scoped></style>
