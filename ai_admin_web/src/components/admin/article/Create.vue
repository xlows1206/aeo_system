<template>
  <div class="main">
    <n-drawer v-model:show="params.active" :width="800" placement="right">
      <n-drawer-content :title="props.drawerParams.title">
        <n-form
          ref="formRef"
          :model="params.user"
          :rules="params.rules"
          label-width="auto"
          require-mark-placement="right-hanging"
          :style="{
            maxWidth: '640px',
          }"
        >
          <n-form-item
            label="分类"
            path="category"
          >
            <n-select v-model:value="params.perData.category_id" :options="params.categories"/>
          </n-form-item>
          <n-form-item label="文章标题" path="title">
            <n-input v-model:value="params.perData.title" placeholder="请输入文章标题"/>
          </n-form-item>
          <n-form-item label="文章内容" path="content">
              <n-input
                type="textarea"
                placeholder="文章内容"
                v-model:value="params.perData.content"
                :autosize="{minRows: 10,}"
              />
          </n-form-item>
          <n-form-item>
            <n-button
              type="primary"
              @click="submit"
              size="large"
              :loading="params.loading"
              block
            >
              提交
            </n-button>
          </n-form-item>
        </n-form>
      </n-drawer-content>
    </n-drawer>
  </div>
</template>

<script lang="ts" setup>
import {reactive, ref} from 'vue';
import {apiStoreArticle, apiUpdateArticle, apiGetCategories} from '@/api/system/admin';

const props = defineProps({
  drawerParams: {
    type: Object,
    default: () => {
      return {
        title: '新增文章',
        categories: [],
        data: {}
      };
    },
  },
});

const emits = defineEmits(['reloadTable']);

const formRef = ref(null);
const params = reactive({
  active: false,
  currentStatus: 'process',
  current: 1,
  preLists: [],
  currentPreIndex: 0,
  perData: {},
  categories: []
});

const submit = (data: any) => {
  if (props.drawerParams.type === 'add') {
    apiStoreArticle(params.perData)
      .then(() => {
        emits('reloadTable');
        window['$message'].success('操作成功');
      })
      .catch((err) => {
        window['$message'].error(err.message);
      });
  } else {
    apiUpdateArticle(
      params.perData,
      props.drawerParams.data.id
    )
      .then(() => {
        emits('reloadTable');
        window['$message'].success('操作成功');
      })
      .catch((err) => {
        window['$message'].error(err.message);
      });
  }

  // if (data.currentPreIndex >= params.preLists.length) {
  //
  // } else {
  //   changeCurrent(++data.currentPreIndex);
  // }
};

apiGetCategories().then(res => {
  res.list.forEach((item: any) => {
    params.categories.push({
      label: item.name,
      value: item.id,
    });
  })
})



const openDrawer = () => {
  params.active = true;
  params.perData = props.drawerParams.data || [];
};

const closeDrawer = () => {
  params.active = false;
};

defineExpose({
  openDrawer,
  closeDrawer,
});
</script>

<style scoped lang="less"></style>
