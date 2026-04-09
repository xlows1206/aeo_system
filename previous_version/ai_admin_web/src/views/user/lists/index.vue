<template>
  <n-card :bordered="false" class="proCard">
    <div class="custom-header-main w-full p-3
    rounded-md bg-white shadow-md gap-2
    flex justify-between items-center">
      <n-form
        :show-feedback="false"
        inline
        v-model:value="params.search"
        label-placement="left">
        <n-form-item label="用户名">
          <n-input
            style="width: 200px;"
            v-model:value="params.search.username"/>
        </n-form-item>
      </n-form>

      <n-button type="primary" @click="reloadTable">搜索</n-button>
    </div>

    <div class="flex items-center pt-5 pb-5 gap-4">
      <n-button v-permission="{ action: ['user.store'] }"
                type="primary" @click="addTable">
        <template #icon>
          <n-icon>
            <PlusOutlined/>
          </n-icon>
        </template>
        新建用户
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
      :scroll-x="1090"
    >
    </BasicTable>

    <v-user-create :params="params" @reloadTable="reloadTable" v-if="params.active"></v-user-create>
  </n-card>
</template>

<script lang="ts" setup>
import {h, reactive, ref} from 'vue';
import {BasicTable, TableAction} from '@/components/Table';
import {getTableList} from '@/api/user/list';
import {columns} from './columns';
import {PlusOutlined} from '@vicons/antd';
import {useRouter} from 'vue-router';
import VUserCreate from '@/components/user/Create.vue';
import {apiDestroyUser, apiResetPassword} from '@/api/user';
import {getAllRoleList} from '@/api/system/role';
import {RefreshCcw} from "lucide-vue-next";
import {NIcon} from "naive-ui";

getAllRoleList().then((res) => {
  params.roleIds = res.lists;
});

const router = useRouter();
const formRef: any = ref(null);
const actionRef = ref();

const actionColumn = reactive({
  width: 220,
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
          auth: ['user.update'],
        },
        {
          label: '重置密码',
          type: 'warning',
          onClick: handleResetPassword.bind(null, record),
          // 根据业务控制是否显示 isShow 和 auth 是并且关系
          ifShow: () => {
            return true;
          },
          // 根据权限控制是否显示: 有权限，会显示，支持多个
          auth: ['user.resetPassword'],
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
          auth: ['user.delete'],
        },
      ],
    });
  },
});

const params = reactive({
  active: false,
  title: '新建用户',
  user: {},
  roleIds: [],
  search: {
    username: ''
  }
});

function addTable() {
  params.active = true;
  params.title = '新建用户';
  params.user = {};
}

const loadDataTable = async (res) => {
  return await getTableList({...params.search, ...res});
};

function reloadTable() {
  params.active = false;
  actionRef.value.reload();
}

function handleEdit(record: Recordable) {
  params.active = true;
  params.title = '编辑用户';
  params.user = record;
}

function handleDelete(record: Recordable) {
  window['$dialog'].info({
    title: '提示',
    content: `确定删除用户 ${record.username} ？`,
    positiveText: '确定',
    negativeText: '取消',
    onPositiveClick: () => {
      apiDestroyUser(record.id).then(() => {
        window['$message'].info('删除成功');
        reloadTable();
      });
    },
    onNegativeClick: () => {
    },
  });
}

function handleResetPassword(record: Recordable) {
  window['$dialog'].info({
    title: '提示',
    content: `确定重置密码为 a12345678 ？`,
    positiveText: '确定',
    negativeText: '取消',
    onPositiveClick: () => {
      apiResetPassword(record.id).then(() => {
        window['$message'].info('重置成功');
        reloadTable();
      });
    },
    onNegativeClick: () => {
    },
  });
}

function handleSubmit(values: Recordable) {
  reloadTable();
}
</script>

<style lang="less" scoped></style>
