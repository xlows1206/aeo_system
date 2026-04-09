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
        <n-form-item label="角色名称">
          <n-input
            style="width: 200px;"
            v-model:value="params.search.name"/>
        </n-form-item>
      </n-form>
      <n-button type="primary" @click="reloadTable">搜索</n-button>
    </div>

    <div class="flex items-center pt-5 pb-5 gap-4">
      <n-button type="primary" @click="addTable">
        <template #icon>
          <n-icon>
            <PlusOutlined />
          </n-icon>
        </template>
        新建
      </n-button>
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

    <v-role-create ref="roleCreateRef" :drawerParams="params" @reload="reloadTable"></v-role-create>
  </n-card>
</template>

<script lang="ts" setup>
  import { ref, h, reactive } from 'vue';
  import { BasicTable, TableAction } from '@/components/Table';
  import { BasicForm, FormSchema, useForm } from '@/components/Form/index';
  import { columns } from './columns';
  import { PlusOutlined } from '@vicons/antd';
  import VRoleCreate from '@/components/role/Create.vue';
  import { apiDeleteRole, getRoleList } from '@/api/system/role';
  import {RefreshCcw} from "lucide-vue-next";
  import {NIcon} from "naive-ui";

  const schemas: FormSchema[] = [
    {
      field: 'name',
      component: 'NInput',
      label: '角色名称',
    },
  ];

  const formRef: any = ref(null);
  const actionRef: any = ref(null);
  const roleCreateRef: any = ref(null);

  const actionColumn = reactive({
    width: 50,
    title: '操作',
    key: 'action',
    fixed: 'right',
    render(record) {
      return h(TableAction as any, {
        style: 'button',
        actions: [
          {
            label: '编辑',
            onClick: handleEdit.bind(null, record),
            ifShow: () => {
              return true;
            },
            auth: ['system.role'],
          },
          {
            label: '删除',
            type: 'error',
            onClick: handleDelete.bind(null, record),
            // 根据业务控制是否显示 isShow 和 auth 是并且关系
            ifShow: () => {
              return true;
            },
            // 根据权限控制是否显示: 有权限，会显示，支持多个
            auth: ['system.role'],
          },
        ],
      });
    },
  });

  const [register, { getFieldsValue }] = useForm({
    gridProps: { cols: '1 s:1 m:2 l:3 xl:4 2xl:4' },
    labelWidth: 80,
    schemas,
  });

  const params = reactive({
    title: '新建角色',
    data: {},
    type: '',
    search: {
      name: '',
    }
  });

  function addTable() {
    params.title = '新建角色';
    params.data = {};
    params.type = 'add';
    roleCreateRef.value.openDrawer();
  }

  const loadDataTable = async (res) => {
    return await getRoleList({ ...params.search, ...res });
  };

  function reloadTable() {
    actionRef.value.reload();
    roleCreateRef.value?.closeDrawer();
  }

  function handleEdit(record: Recordable) {
    params.title = '编辑角色';
    params.data = record;
    params.type = 'edit';
    roleCreateRef.value.openDrawer();
  }

  function handleDelete(record: Recordable) {
    window['$dialog'].info({
      title: '提示',
      content: `确定删除 ${record.name} ？`,
      positiveText: '确定',
      negativeText: '取消',
      onPositiveClick: () => {
        apiDeleteRole(record.id).then(() => {
          window['$message'].success('删除成功');
          reloadTable();
        });
      },
      onNegativeClick: () => {},
    });
  }

  function handleSubmit(values: Recordable) {
    reloadTable();
  }

  function handleReset(values: Recordable) {}
</script>

<style lang="less" scoped></style>
