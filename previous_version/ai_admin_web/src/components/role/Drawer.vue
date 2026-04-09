<template>
  <div class="main">
    <n-drawer v-model:show="params.active" :width="502" placement="right">
      <n-drawer-content :title="props.drawerParams.title">
        <n-form
          ref="formRef"
          :model="params.permission"
          :rules="params.rules"
          label-placement="left"
          label-width="auto"
          require-mark-placement="right-hanging"
          :style="{
            maxWidth: '640px',
          }"
        >
          <n-form-item label="名称" path="name">
            <n-input v-model:value="params.permission.name" placeholder="" />
          </n-form-item>
          <n-form-item label="权限" path="path">
            <n-input v-model:value="params.permission.path" placeholder="" />
          </n-form-item>
          <n-form-item label="排序" path="rank">
            <n-input-number v-model:value="params.permission.rank" placeholder="" />
          </n-form-item>
          <n-form-item>
            <n-button
              type="primary"
              @click="handleSubmit"
              size="large"
              :loading="params.loading"
              block
            >
              保存
            </n-button>
          </n-form-item>
        </n-form>
      </n-drawer-content>
    </n-drawer>
  </div>
</template>

<script lang="ts" setup>
  import { reactive, ref } from 'vue';
  import { apiStoreMenu, apiUpdateMenu } from '@/api/system/menu';

  const props = defineProps({
    drawerParams: {
      type: Object,
    },
  });

  const emits = defineEmits(['reload']);

  const formRef = ref(null);
  const params = reactive({
    editId: 0,
    loading: false,
    active: false,
    rules: {
      name: [{ required: true, message: '名称不能为空' }],
      path: [{ required: true, message: '权限不能为空' }],
    },
    permission: {
      name: '',
      path: '',
      rank: 99,
    },
  });

  const handleSubmit = (e) => {
    params.loading = true;
    e.preventDefault();
    formRef.value?.validate((errors) => {
      if (!errors) {
        if (props.drawerParams.type === 1) {
          apiStoreMenu({
            name: params.permission.name,
            path: params.permission.path,
            rank: params.permission.rank,
            parent_id: props.drawerParams.data.id,
          })
            .then(() => {
              emits('reload');
            })
            .catch((err) => {
              window['$message'].error(err.message);
            });
        } else {
          apiUpdateMenu(
            {
              name: params.permission.name,
              path: params.permission.path,
              rank: params.permission.rank,
              parent_id: params.permission.parent_id,
            },
            params.editId
          )
            .then(() => {
              emits('reload');
            })
            .catch((err) => {
              window['$message'].error(err.message);
            });
        }
        params.loading = false;
      } else {
        params.loading = false;
      }
    });
  };

  const openDrawer = () => {
    if (props.drawerParams.type === 1) {
      params.editId = 0;
      params.permission = {
        name: '',
        path: '',
        rank: 99,
      };
    }
    if (props.drawerParams.type === 2) {
      params.editId = props.drawerParams.data.id;
      params.permission = {
        parent_id: props.drawerParams.data.parent_id,
        name: props.drawerParams.data.name,
        path: props.drawerParams.data.path,
        rank: props.drawerParams.data.rank,
      };
    }
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
