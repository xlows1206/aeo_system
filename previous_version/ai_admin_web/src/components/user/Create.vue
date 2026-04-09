<template>
  <div class="main">
    <n-drawer v-model:show="props.params.active"
              :width="450" placement="right">
      <n-drawer-content
        closable
        :title="props.params.title">
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
            label="账号类型"
            path="parentId"
            v-show="params.editId === 0 && standing === 1"
          >
            <n-radio-group v-model:value="params.standing" name="left-size">
              <n-radio :value="2">主账号</n-radio>
              <n-radio :value="3">子账号</n-radio>
            </n-radio-group>
          </n-form-item>
          <n-form-item
            label="主账号"
            path="parentId"
            v-show="params.standing === 3 && params.editId === 0 && standing === 1"
          >
            <n-select v-model:value="params.user.parentId" :options="params.allMaster" />
          </n-form-item>
          <n-form-item label="公司名称" path="company" v-show="params.standing === 2">
            <n-input v-model:value="params.user.company" placeholder="请输入公司名称" />
          </n-form-item>
          <n-form-item label="审核标准" path="enterprise" v-show="params.standing === 2">
            <n-select v-model:value="params.user.enterprise" :options="params.enterprise" />
          </n-form-item>
          <n-form-item label="用户名" path="username">
            <n-input v-model:value="params.user.username" placeholder="请输入邮箱" />
          </n-form-item>
          <n-form-item label="密码" path="password" v-if="params.editId === 0">
            <n-input
              v-model:value="params.user.password"
              type="password"
              showPasswordOn="click"
              placeholder="请输入密码"
            />
          </n-form-item>
          <n-form-item label="角色" path="roleId">
            <n-select v-model:value="params.user.roleId" :options="props.params.roleIds" />
          </n-form-item>
          <n-form-item label="备注" path="note">
            <n-input v-model:value="params.user.note" placeholder="请输入备注" />
          </n-form-item>
          <n-form-item>
            <n-button
              type="primary"
              @click="handleSubmit"
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
  import { ref, reactive, watch } from 'vue';
  import { useMessage } from 'naive-ui';
  import { apiStoreUser, apiUpdateUser } from '@/api/user';
  import { apiGetMaster } from '@/api/system/user';
  import { useUserStore } from '@/store/modules/user';
  const message = useMessage();

  const props = defineProps({
    params: {
      type: Object,
      default: {},
    },
  });
  const emits = defineEmits(['reloadTable']);

  const checkParentId = (rule, value) => {
    if (params.standing === 3) {
      return !!value;
    }
    return true;
  };

  const checkEnterprise = (rule, value) => {
    if (params.standing === 2) {
      return !!value;
    }
    return true;
  };

  const checkCompany = (rule, value) => {
    if (params.standing === 2) {
      return !!value;
    }
    return true;
  };

  const validateEmail = (rule, value) => {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(value);
  };

  const params = reactive({
    editId: 0,
    standing: 2,
    user: {
      parentId: null,
      roleId: null,
      company: '',
      note: '',
      username: '',
      password: '',
      enterprise: null,
    },
    enterprise: [
      { label: '通用', value: 1 },
      { label: '通用 + 单项', value: 2 },
    ],
    rules: {
      enterprise: [{ validator: checkEnterprise, message: '请选择标准' }],
      parentId: [{ validator: checkParentId, message: '请选择主账号' }],
      company: [{ validator: checkCompany, message: '请输入公司名称' }],
      username: [
        { required: true, message: '请输入手机号' },
        { validator: validateEmail, message: '请输入正确的邮箱' },
      ],
      password: [{ required: true, message: '请输入密码' }],
      roleId: [{ required: true, message: '请选择用户角色' }],
    },
    loading: false,
    allMaster: [],
  });

  const userStore = useUserStore();
  const standing = userStore.getUserInfo.standing;

  if (props.params.user && props.params.user.id) {
    let user = props.params.user;
    params.editId = user.id;
    params.standing = user.standing;
    params.user = {
      parentId: user.parent_id,
      roleId: user.role_id,
      company: user.company,
      note: user.note,
      username: user.username,
      password: user.password,
      enterprise: user.enterprise,
    };
  } else {
    params.editId = 0;
    params.standing = standing === 1 ? 2 : 3;
    params.user = {
      parentId: standing === 1 ? null : userStore.getUserInfo.userId,
      roleId: null,
      company: '',
      note: '',
      username: '',
      password: '',
      enterprise: null,
    };
    console.log(params.user);
  }

  const formRef = ref(null);
  const handleSubmit = (e) => {
    params.loading = true;
    e.preventDefault();
    formRef.value?.validate((errors) => {
      if (!errors) {
        if (params.editId === 0) {
          // 新增
          apiStoreUser({ ...{ standing: params.standing }, ...params.user })
            .then((res) => {
              params.loading = false;
              emits('reloadTable');
            })
            .catch((e) => {
              message.error(e.message);
              params.loading = false;
            });
        } else {
          // 编辑
          apiUpdateUser(params.editId, { ...{ standing: params.standing }, ...params.user })
            .then((res) => {
              params.loading = false;
              emits('reloadTable');
            })
            .catch((e) => {
              message.error(e.message);
              params.loading = false;
            });
        }
      } else {
        params.loading = false;
      }
    });
  };

  apiGetMaster().then((res) => {
    params.allMaster = res.lists;
    console.log(res);
  });
</script>

<style scoped lang="less"></style>
