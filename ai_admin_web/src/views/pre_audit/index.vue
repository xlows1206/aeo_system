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
        <n-icon
          class="cursor-pointer"
          @click="reloadTable"
          size="20" color="#D6B164">
          <RefreshCcw/>
        </n-icon>
      </div>
      <div class="p-6">
        <div class="space-y-5">
      <div class="flex items-center justify-between">

        <span class="text-amber-800 font-medium">{{ params.totalRate.name }} 通过预审</span>
        <span class="text-sm text-amber-600 font-medium">
                            {{ params.totalRate.completed }}/{{ params.totalRate.total }} ({{ params.totalRate.percentage }}%)
                          </span>
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
import {PlusOutlined} from '@vicons/antd';
import VPreAuditCreate from '@/components/pre_audit/Create.vue';
import VPreAuditInfo from '@/components/pre_audit/Info.vue';
import {apiGetPreAudit, apiStoreSubmitAudit} from '@/api/system/pre';
import {RefreshCcw} from "lucide-vue-next";
import {NIcon} from "naive-ui";
import {apiAccessRate} from '@/api/system/home'


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
        {
          label: '重新提审',
          type: 'warning',
          onClick: handleEdit.bind(null, record),
          // 根据业务控制是否显示 isShow 和 auth 是并且关系
          ifShow: () => {
            return record.status < 3;
          },
          // 根据权限控制是否显示: 有权限，会显示，支持多个
          auth: ['pre_audit.store'],
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
    {label: '基本达标', value: 2},
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
