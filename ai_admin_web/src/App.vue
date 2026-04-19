<template>
  <NConfigProvider
    :locale="zhCN"
    :theme="lightTheme"
    :theme-overrides="getThemeOverrides"
    :date-locale="dateZhCN"
  >
    <AppProvider>
      <RouterView />
    </AppProvider>
  </NConfigProvider>

<!--  <transition v-if="isLock && $route.name !== 'login'" name="slide-up">-->
<!--    <LockScreen />-->
<!--  </transition>-->
</template>

<script lang="ts" setup>
  import { computed, onMounted, onUnmounted } from 'vue';
  import { zhCN, dateZhCN, darkTheme } from 'naive-ui';
  // import { LockScreen } from '@/components/Lockscreen';
  import { AppProvider } from '@/components/Application';
  // import { useScreenLockStore } from '@/store/modules/screenLock.js';
  import { useRoute } from 'vue-router';
  import { useDesignSettingStore } from '@/store/modules/designSetting';
  // import { lighten } from '@/utils/index';
  import { lightTheme } from 'naive-ui'

  const route = useRoute();
  // const useScreenLock = useScreenLockStore();
  const designStore = useDesignSettingStore();
  // const isLock = computed(() => useScreenLock.isLocked);
  // const lockTime = computed(() => useScreenLock.lockTime);

  /**
   * @type import('naive-ui').GlobalThemeOverrides
   */
  const getThemeOverrides = computed(() => {
    const appTheme = designStore.appTheme;
    // const lightenStr = lighten(designStore.appTheme, 6);
    return {
      common: {
        primaryColor: '#D6B164',
        primaryColorHover: '#D6B164',
        primaryColorPressed: '#D6B164',
        primaryColorSuppl: '#D6B164',
        infoColor: '#D6B164',
        infoColorHover: '#D6B164',
        infoColorPressed: '#D6B164',
        infoColorSuppl: '#D6B164',
        warningColor: '#D6B164',
        warningColorHover: '#D6B164',
        warningColorPressed: '#D6B164',
        warningColorSuppl: '#D6B164',
        errorColor: '#F64545',
        errorColorHover: '#F64545',
        errorColorPressed: '#F64545',
        errorColorSuppl: '#F64545',
      },
      LoadingBar: {
        colorLoading: appTheme,
      },
    };
  });

  // let timer: NodeJS.Timer;

  // const timekeeping = () => {
  //   clearInterval(timer);
  //   if (route.name == 'login' || isLock.value) return;
  //   // 设置不锁屏
  //   useScreenLock.setLock(false);
  //   // 重置锁屏时间
  //   useScreenLock.setLockTime();
  //   timer = setInterval(() => {
  //     // 锁屏倒计时递减
  //     useScreenLock.setLockTime(lockTime.value - 1);
  //     if (lockTime.value <= 0) {
  //       // 设置锁屏
  //       // useScreenLock.setLock(true);
  //       return clearInterval(timer);
  //     }
  //   }, 1000);
  // };

  onMounted(() => {
    // document.addEventListener('mousedown', timekeeping);
  });

  onUnmounted(() => {
    // document.removeEventListener('mousedown', timekeeping);
  });
</script>
