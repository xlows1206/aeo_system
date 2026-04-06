<template>
  <div>
    <n-card :bordered="false" class="proCard">

      <div class="flex items-center pt-5 pb-5 gap-4">
        <n-button v-permission="{ action: ['admin.category.add'] }" type="primary" @click="addTable">
          <template #icon>
            <n-icon>
              <PlusOutlined/>
            </n-icon>
          </template>
          新增分类
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

      <v-category-create
        ref="categoryCreateRef"
        :drawerParams="params"
        @reloadTable="reloadTable"
      ></v-category-create>
    </n-card>
  </div>
</template>

<script lang="ts" setup>
import {ref, h, reactive} from 'vue';
import {BasicTable, TableAction} from '@/components/Table';
import {BasicForm, FormSchema, useForm} from '@/components/Form/index';
import {columns} from './columns';
import {PlusOutlined} from '@vicons/antd';
import VCategoryCreate from '@/components/admin/category/Create.vue';
import {apiGetCategories, apiDeleteCategory } from '@/api/system/admin';
import {RefreshCcw} from "lucide-vue-next";
import {NIcon} from "naive-ui";

const formRef: any = ref(null);
const actionRef: any = ref(null);
const categoryCreateRef: any = ref(null);

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
          label: '删除',
          onClick: handleDelete.bind(null, record),
          ifShow: () => {
            return true;
          },
          auth: ['admin.category.delete'],
        },
      ],
    });
  },
});

const [register, {getFieldsValue}] = useForm({
  gridProps: {cols: '1 s:1 m:2 l:3 xl:4 2xl:4'},
  labelWidth: 80,
});

const params = reactive({
  title: '',
  data: {},
  type: '',
  search: {
    title: '',
  }
});

function addTable() {
  params.title = '新增分类';
  params.data = {};
  params.type = 'add';
  categoryCreateRef.value.openDrawer();
}

const loadDataTable = async () => {
  return await apiGetCategories();
};

function reloadTable() {
  actionRef.value.reload();
  categoryCreateRef.value?.closeDrawer();
}

function handleDelete(record: Recordable) {
  apiDeleteCategory(record.id)
    .then(() => {
      window['$message'].success('操作成功');
    })
    .catch((err) => {
      window['$message'].error(err.message);
    });
  reloadTable();
}

function handleSubmit(values: Recordable) {
  reloadTable();
}

function handleReset(values: Recordable) {
}
</script>

<style lang="less" scoped></style>
