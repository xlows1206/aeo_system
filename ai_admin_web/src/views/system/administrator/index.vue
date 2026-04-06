<template>
  <div>
    <n-card class="setting" :bordered="false">
      <n-form
        ref="formRef"
        :model="params.user"
        :rules="params.rules"
        style="width: 300px"
        label-placement="left"
        label-width="auto"
      >
        <n-form-item path="username" label="用户名">
          <n-input v-model:value="params.user.username" />
        </n-form-item>
        <n-form-item label="密码">
          <n-input v-model:value="params.user.password" />
        </n-form-item>
        <div class="bg-#F5D2D0 p-2 flex flex-row items-center rounded-md mb-5 gap-x-2" style="background: #F5D2D0">
          <TriangleAlert
            size="20"
            color="#AA6363"/>
          <span style="color: #AA6363">密码留空则不修改</span>
        </div>
        <n-button
          style="width: 300px"
          :loading="params.loading"
          type="primary"
          @click="handleSubmit"
        >
          确认
        </n-button>
      </n-form>
    </n-card>
  </div>
</template>

<script lang="ts" setup>
  import { ref, reactive } from 'vue';
  import { TriangleAlert } from 'lucide-vue-next';
  import {apiUpdateAdminInfo} from '@/api/system/user';

  const formRef = ref(null);

  const params = reactive({
    loading: false,
    user: {
      username: '',
      password: '',
    },
    rules: {
      username: [{ required: true, message: '请输入用户名' }],
    },
  });

  const handleSubmit = (e) => {
    params.loading = true;
    e.preventDefault();
    formRef.value?.validate((errors) => {
      if (!errors) {
        apiUpdateAdminInfo(params.user).then(() => {
          window['$message'].success('操作成功');
          params.loading = false;
        }).catch((err)=> {
          console.log(err)
          window['$message'].success(err.message);
          params.loading = false;
        });
      } else {
        params.loading = false;
      }
    });
  };
</script>

<style scoped lang="less">
  .setting {
    display: flex;
  }
</style>
