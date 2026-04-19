<template>
  <n-card :bordered="false" class="proCard">
    <div class="custom-header-main w-full p-3
    rounded-md bg-white shadow-md gap-2
    flex justify-between items-center">
      <n-form
        inline
        :show-feedback="false"
        v-model:value="params.search"
        label-placement="left">
        <n-form-item label="公司名称">
          <n-input
            style="width: 200px;"
            v-model:value="params.search.companyName"/>
        </n-form-item>
        <n-form-item label="状态">
          <n-select
            clearable
            style="width: 200px;"
            :options="params.status"
            v-model:value="params.search.status"
          />
        </n-form-item>
      </n-form>
      <n-button type="primary" @click="reloadTable">搜索</n-button>
    </div>

    <div class="flex items-center pt-5 pb-5 gap-4">
      <n-icon
        class="cursor-pointer"
        @click="reloadTable"
        size="20" color="#D6B164">
        <RefreshCcw/>
      </n-icon>
    </div>

    <BasicTable
      :columns="columns"
      :request="loadDataTable"
      ref="actionRef"
      :actionColumn="actionColumn"
    >
    </BasicTable>

    <v-audit-info
      ref="auditInfoRef"
      :drawerParams="params"
      @reloadTable="reloadTable"
    ></v-audit-info>
    <v-audit-audit-info ref="auditAuditInfoRef" :drawerParams="params"></v-audit-audit-info>
  </n-card>
</template>

<script lang="ts" setup>
  import { ref, h, reactive } from 'vue';
  import { BasicTable, TableAction } from '@/components/Table';
  import { columns } from './columns';
  import VAuditInfo from '@/components/audit/Info.vue';
  import VAuditAuditInfo from '@/components/audit/AuditInfo.vue';
  import { apiPreAudit, apiRevocationAudit } from '@/api/system/audit';
  import {RefreshCcw} from "lucide-vue-next";
  import {NIcon} from "naive-ui";


  const formRef: any = ref(null);
  const actionRef: any = ref(null);
  const auditInfoRef: any = ref(null);
  const auditAuditInfoRef: any = ref(null);

  const actionColumn = reactive({
    width: 150,
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
            auth: ['audit.Info'],
          },
          {
            label: '撤销',
            type: 'warning',
            onClick: handleRevocation.bind(null, record),
            ifShow: () => {
              return record.status < 4;
            },
            auth: ['audit.delete'],
          },
          {
            label: '审核',
            type: 'info',
            onClick: handleExamine.bind(null, record),
            ifShow: () => {
              return record.status === 0;
            },
            auth: ['audit.update'],
          },
        ],
      });
    },
  });

  function handleInfo(record: Recordable) {
    params.title = '审核详情';
    params.data = record;
    auditAuditInfoRef.value.openDrawer();
  }

  function handleRevocation(record: Recordable) {
    window['$dialog'].info({
      title: '提示',
      content: `确定撤销 ？`,
      positiveText: '确定',
      negativeText: '取消',
      onPositiveClick: () => {
        apiRevocationAudit(record.id)
          .then(() => {
            window['$message'].success('操作成功');
            reloadTable();
          })
          .catch((err) => {
            window['$message'].error(err.message);
          });
      },
      onNegativeClick: () => {},
    });
  }

  function handleExamine(record: Recordable) {
    params.title = '审核详情';
    params.data = record;
    auditInfoRef.value.openDrawer();
  }

  const params = reactive({
    title: '',
    data: {},
    type: '',
    status: [
      { label: '正在审核', value: 0 },
      { label: '不达标', value: 1 },
      { label: '不合格', value: 1 },
      { label: '达标', value: 3 },
    ],
    search: {
      status: '',
      companyName: '',
    }
  });

  const loadDataTable = async (res) => {
    return await apiPreAudit({ ...params.search, ...res });
  };

  function reloadTable() {
    actionRef.value.reload();
    auditInfoRef.value?.closeDrawer();
  }

  function handleSubmit(values: Recordable) {
    reloadTable();
  }

  function handleReset(values: Recordable) {}
</script>

<style lang="less" scoped></style>
