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
          <n-form-item label="分类名称" path="name">
            <n-input v-model:value="params.perData.name" placeholder="请输入分类名称"/>
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
import {apiCreateCategory} from '@/api/system/admin';

const props = defineProps({
  drawerParams: {
    type: Object,
    default: () => {
      return {
        title: '新增分类',
      };
    },
  },
});

const emits = defineEmits(['reloadTable']);

const formRef = ref(null);
const params = reactive({
  active: false,
  perData: {},
});

const submit = (data: any) => {
  console.log(params.perData)
  apiCreateCategory(params.perData)
    .then(() => {
      emits('reloadTable');
      window['$message'].success('操作成功');
    })
    .catch((err) => {
      window['$message'].error(err.message);
    });
  // if (data.currentPreIndex >= params.preLists.length) {
  //
  // } else {
  //   changeCurrent(++data.currentPreIndex);
  // }
};

const openDrawer = () => {
  params.active = true;
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
