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
          <n-form-item label="标题">
            <n-input
              style="width: 200px;"
              v-model:value="params.search.title"/>
          </n-form-item>
        </n-form>
        <n-button type="primary" @click="reloadTable">搜索</n-button>
      </div>

      <div class="flex items-center pt-5 pb-5 gap-4">
        <n-button v-permission="{ action: ['admin.article.add'] }" type="primary" @click="addTable">
          <template #icon>
            <n-icon>
              <PlusOutlined/>
            </n-icon>
          </template>
          新增文章
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

      <v-article-create
        ref="articleCreateRef"
        :drawerParams="params"
        @reloadTable="reloadTable"
      ></v-article-create>
      <v-article-info ref="articleCreateInfo" :drawerParams="params"></v-article-info>

    </n-card>
  </div>
</template>

<script lang="ts" setup>
import {ref, h, reactive} from 'vue';
import {BasicTable, TableAction} from '@/components/Table';
import {BasicForm, FormSchema, useForm} from '@/components/Form/index';
import {columns} from './columns';
import {PlusOutlined} from '@vicons/antd';
import VArticleCreate from '@/components/admin/article/Create.vue';
import VArticleInfo from '@/components/admin/article/Info.vue';
import {apiGetArticles, apiDeleteArticle, } from '@/api/system/admin';
import {RefreshCcw} from "lucide-vue-next";
import {NIcon} from "naive-ui";

const formRef: any = ref(null);
const actionRef: any = ref(null);
const articleCreateRef: any = ref(null);
const articleCreateInfo: any = ref(null);

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
          label: '编辑文章',
          onClick: handleEdit.bind(null, record),
          ifShow: () => {
            return true;
          },
          auth: ['admin.article.edit'],
        },
        {
          label: '删除',
          onClick: handleDelete.bind(null, record),
          ifShow: () => {
            return true;
          },
          auth: ['admin.article.delete'],
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
  categories: [],
  search: {
    title: '',
  }
});

function addTable() {
  params.title = '新增文章';
  params.data = {};
  params.type = 'add';
  articleCreateRef.value.openDrawer();
}

const loadDataTable = async (res) => {
  return await apiGetArticles({...params.search, ...res});
};


function reloadTable() {
  actionRef.value.reload();
  articleCreateRef.value?.closeDrawer();
}

function handleEdit(record: Recordable) {
  params.title = '编辑文章';
  params.data = record;
  params.type = 'edit';
  articleCreateRef.value.openDrawer();
}

function handleInfo(record: Recordable) {
  params.title = '查看详情';
  params.data = record;
  articleCreateInfo.value.openDrawer();
}

function handleDelete(record: Recordable) {
  apiDeleteArticle(record.id)
    .then(() => {
      window['$message'].success('操作成功');
    })
    .catch((err) => {
      window['$message'].error(err.message);
    });
}

function handleSubmit(values: Recordable) {
  reloadTable();
}

function handleReset(values: Recordable) {
}
</script>

<style lang="less" scoped></style>
