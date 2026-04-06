<template>
  <div class="view-account">
    <div class="view-account-header"></div>
    <div class="view-account-container">
      <div class="view-account-top">
        <div
          style="display: flex; flex-direction: column;align-items: center;justify-content: center;"
          class="view-account-top-logo">
          <img
            style="width: 100px; height: 100px;"
            :src="websiteConfig.logo" alt=""/>
          <div class="text-xl mt-4" style="color: #C89327">
            欢迎使用AEO审核系统后台
          </div>
        </div>
      </div>
      <div class="view-account-form">
        <n-form
          ref="formRef"
          label-placement="left"
          size="large"
          :model="formInline"
          :rules="rules"
        >
          <n-form-item path="username">
            <n-input v-model:value="formInline.username" placeholder="请输入邮箱">
              <template #prefix>
                <n-icon size="18" color="#808695">
                  <PersonOutline />
                </n-icon>
              </template>
            </n-input>
          </n-form-item>
          <n-form-item path="code">
            <n-input v-model:value="formInline.code" placeholder="请输入验证码">
              <template #prefix>
                <n-icon size="18" color="#808695">
                  <LockClosedOutline />
                </n-icon>
              </template>
            </n-input>
            <n-button style="margin-left: 12px" @click="sendMail" :disabled="formInline.disable">
              {{ formInline.showText }}
            </n-button>
          </n-form-item>
          <n-form-item path="password">
            <n-input
              v-model:value="formInline.password"
              type="password"
              showPasswordOn="click"
              placeholder="请输入密码"
            >
              <template #prefix>
                <n-icon size="18" color="#808695">
                  <LockClosedOutline />
                </n-icon>
              </template>
            </n-input>
          </n-form-item>
          <n-form-item path="passwordAgain">
            <n-input
              v-model:value="formInline.passwordAgain"
              type="password"
              showPasswordOn="click"
              placeholder="再次输入密码"
            >
              <template #prefix>
                <n-icon size="18" color="#808695">
                  <LockClosedOutline />
                </n-icon>
              </template>
            </n-input>
          </n-form-item>
          <n-form-item>
            <n-button type="primary" @click="handleSubmit" size="large" :loading="loading" block>
              重置
            </n-button>
          </n-form-item>
          <n-form-item class="default-color">
            <div class="flex view-account-other">
              <div class="flex-initial" style="margin-left: auto">
                <router-link
                  style="color: #C89327"
                  :to="{ name: 'Login' }">立即登录</router-link>
              </div>
            </div>
          </n-form-item>
        </n-form>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
  import { reactive, ref } from 'vue';
  import { useRoute, useRouter } from 'vue-router';
  import { useMessage } from 'naive-ui';
  import { PersonOutline, LockClosedOutline } from '@vicons/ionicons5';
  import { websiteConfig } from '@/config/website.config';
  import { FormItemRule } from 'naive-ui';
  import { apiRegisterUser } from '@/api/user';
  import { apiForgotPassword, apiSendMail } from '@/api/user/list';

  const formRef = ref();
  const message = useMessage();
  const loading = ref(false);

  const formInline = reactive({
    username: '',
    code: '',
    company: '',
    password: '',
    passwordAgain: '',
    isCaptcha: true,
    showText: '发送验证码',
    time: 60,
    disable: false,
  });

  const countdownSelf = null;

  const sendMail = () => {
    if (!formInline.username) {
      message.error('请输入邮箱');
      return;
    }
    formInline.disable = true;
    apiSendMail({
      email: formInline.username,
    })
      .then((res) => {
        formInline.showText = formInline.time + 'S';
        countdown();
      })
      .catch((res) => {
        message.error('发送失败');
        formInline.disable = false;
      });
  };

  const countdown = () => {
    const countdownSelf = setInterval(() => {
      formInline.time--;
      formInline.showText = formInline.time + 'S';
      if (formInline.time === 0) {
        formInline.disable = false;
        formInline.time = 60;
        formInline.showText = '发送验证码';
        clearInterval(countdownSelf);
      }
    }, 1000);
  };

  const validatePasswordSame = (rule: FormItemRule, value: string): boolean => {
    return value === formInline.password;
  };

  const validateEmail = (rule, value) => {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(value);
  };

  const rules = {
    code: { required: true, message: '请输入验证码', trigger: 'blur' },
    username: [
      { required: true, message: '请输入邮箱', trigger: 'blur' },
      { validator: validateEmail, message: '请输入正确的邮箱' },
    ],
    password: { required: true, message: '请输入密码', trigger: 'blur' },
    passwordAgain: {
      validator: validatePasswordSame,
      message: '两次密码输入不一致',
      trigger: ['blur'],
    },
  };

  const router = useRouter();
  const route = useRoute();

  const handleSubmit = (e) => {
    e.preventDefault();
    formRef.value.validate(async (errors) => {
      if (!errors) {
        loading.value = true;

        apiForgotPassword({
          code: formInline.code,
          username: formInline.username,
          password: formInline.password,
        })
          .then(() => {
            router.push({ name: 'Login' });
            message.success('重置成功，请重新登录');
            loading.value = false;
          })
          .catch((e) => {
            message.error(e.message);
            loading.value = false;
          });
      } else {
        message.error('请填写完整信息，并且进行验证码校验');
      }
    });
  };
</script>

<style lang="less" scoped>
  .view-account {
    display: flex;
    flex-direction: column;
    height: 100vh;
    overflow: auto;

    &-container {
      flex: 1;
      padding: 32px 12px;
      max-width: 384px;
      min-width: 320px;
      margin: 0 auto;
    }

    &-top {
      padding: 32px 0;
      text-align: center;

      &-desc {
        font-size: 14px;
        color: #808695;
      }
    }

    &-other {
      width: 100%;
    }

    .default-color {
      color: #515a6e;

      .ant-checkbox-wrapper {
        color: #515a6e;
      }
    }
  }

  @media (min-width: 768px) {
    .view-account {
      background-image: url('../../assets/images/login.svg');
      background-repeat: no-repeat;
      background-position: 50%;
      background-size: 100%;
    }

    .page-account-container {
      padding: 32px 0 24px 0;
    }
  }
</style>
