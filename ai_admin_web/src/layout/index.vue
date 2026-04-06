<template>
  <n-layout
    class="layout" :position="fixedMenu" has-sider>
    <n-layout-sider
      v-if="
        !isMobile && isMixMenuNoneSub && (navMode === 'vertical' || navMode === 'horizontal-mix')
      "
      show-trigger="bar"
      @collapse="collapsed = true"
      :position="fixedMenu"
      @expand="collapsed = false"
      :collapsed="collapsed"
      collapse-mode="width"
      :collapsed-width="64"
      :width="leftMenuWidth"
      :native-scrollbar="false"
      :inverted="inverted"
      class="layout-sider left-menu"
    >
      <Logo :collapsed="collapsed"/>
      <AsideMenu v-model:collapsed="collapsed" v-model:location="getMenuLocation"/>
    </n-layout-sider>

    <!--    <n-drawer-->
    <!--      v-model:show="showSideDrawer"-->
    <!--      :width="menuWidth"-->
    <!--      :placement="'left'"-->
    <!--      class="layout-side-drawer"-->
    <!--    >-->
    <!--      <n-layout-sider-->
    <!--        :position="fixedMenu"-->
    <!--        :collapsed="false"-->
    <!--        :width="menuWidth"-->
    <!--        :native-scrollbar="false"-->
    <!--        :inverted="inverted"-->
    <!--        class="layout-sider"-->
    <!--      >-->
    <!--        <Logo :collapsed="collapsed"/>-->
    <!--        <AsideMenu v-model:location="getMenuLocation"/>-->
    <!--      </n-layout-sider>-->
    <!--    </n-drawer>-->

    <n-layout :inverted="inverted">
      <n-layout-header
        style="background-color: #FDFCF8;z-index: 15"
        :inverted="getHeaderInverted" :position="fixedHeader">
        <PageHeader v-model:collapsed="collapsed" :inverted="inverted"/>
      </n-layout-header>

      <n-layout-content
        class="layout-content"
        style="background: linear-gradient(to right, #FBFAEF, #FEFFFE)"
        :class="{ 'layout-default-background': getDarkTheme === false }"
      >
        <div
          class="layout-content-main"
          :class="{
            'layout-content-main-fix': fixedMulti,
            'fluid-header': fixedHeader === 'static',
          }"
        >
          <!--          <TabsView v-if="isMultiTabs" v-model:collapsed="collapsed"/>-->
          <div
            class="main-view"
            :class="{
              'main-view-fix': fixedMulti,
              noMultiTabs: !isMultiTabs,
              'mt-3': !isMultiTabs,
            }"
          >
            <n-breadcrumb
              style="padding-left: 20px"
            >
              <template
                v-for="routeItem in breadcrumbList"
                :key="routeItem.name === 'Redirect' ? void 0 : routeItem.name"
              >
                <n-breadcrumb-item
                  :clickable="false"
                  v-if="routeItem.meta.title">
                  <n-dropdown
                    v-if="routeItem.children.length"
                  >
                  <span class="link-text" style="color: #D69E56!important;">
                    {{ routeItem.meta.title }}
                  </span>
                  </n-dropdown>
                  <span class="link-text" style="color: #D69E56!important;" v-else>
                  {{ routeItem.meta.title }}
                </span>
                </n-breadcrumb-item>
              </template>
            </n-breadcrumb>
            <MainView/>
          </div>
        </div>
      </n-layout-content>
      <n-back-top :right="100"/>
    </n-layout>
  </n-layout>
</template>

<script lang="ts" setup>
import {ref, unref, computed, onMounted} from 'vue';
import {Logo} from './components/Logo';
import {TabsView} from './components/TagsView';
import {MainView} from './components/Main';
import {AsideMenu} from './components/Menu';
import {PageHeader} from './components/Header';
import {useProjectSetting} from '@/hooks/setting/useProjectSetting';
import {useDesignSetting} from '@/hooks/setting/useDesignSetting';
import {useRoute} from 'vue-router';
import {useProjectSettingStore} from '@/store/modules/projectSetting';

const {getDarkTheme} = useDesignSetting();
const {
  // showFooter,
  navMode,
  navTheme,
  headerSetting,
  menuSetting,
  multiTabsSetting,
} = useProjectSetting();

const route = useRoute();

const settingStore = useProjectSettingStore();

const collapsed = ref<boolean>(false);

const {mobileWidth, menuWidth} = unref(menuSetting);

const isMobile = computed<boolean>({
  get: () => settingStore.getIsMobile,
  set: (val) => settingStore.setIsMobile(val),
});

const fixedHeader = computed(() => {
  const {fixed} = unref(headerSetting);
  return fixed ? 'absolute' : 'static';
});

const isMixMenuNoneSub = computed(() => {
  const mixMenu = unref(menuSetting).mixMenu;
  const currentRoute = useRoute();
  if (unref(navMode) != 'horizontal-mix') return true;
  if (unref(navMode) === 'horizontal-mix' && mixMenu && currentRoute.meta.isRoot) {
    return false;
  }
  return true;
});

const fixedMenu = computed(() => {
  const {fixed} = unref(headerSetting);
  return fixed ? 'absolute' : 'static';
});

const isMultiTabs = computed(() => {
  return unref(multiTabsSetting).show;
});

const fixedMulti = computed(() => {
  return unref(multiTabsSetting).fixed;
});

const inverted = computed(() => {
  // return ['dark', 'header-dark'].includes(unref(navTheme));
  return false;
});

const getHeaderInverted = computed(() => {
  return false;
  // return ['light', 'header-dark'].includes(unref(navTheme)) ? unref(inverted) : !unref(inverted);
});

const leftMenuWidth = computed(() => {
  const {minMenuWidth, menuWidth} = unref(menuSetting);
  return collapsed.value ? minMenuWidth : menuWidth;
});

const getMenuLocation = computed(() => {
  return 'left';
});

// 控制显示或隐藏移动端侧边栏
const showSideDrawer = computed({
  get: () => isMobile.value && collapsed.value,
  set: (val) => (collapsed.value = val),
});

//判断是否触发移动端模式
const checkMobileMode = () => {
  if (document.body.clientWidth <= mobileWidth) {
    isMobile.value = true;
  } else {
    isMobile.value = false;
  }
  collapsed.value = false;
};

const watchWidth = () => {
  const Width = document.body.clientWidth;
  if (Width <= 950) {
    collapsed.value = true;
  } else collapsed.value = false;

  checkMobileMode();
};

const generator: any = (routerMap) => {
  return routerMap.map((item) => {
    const currentMenu = {
      ...item,
      label: item.meta.title,
      key: item.name,
      disabled: item.path === '/',
    };
    // 是否有子菜单，并递归处理
    if (item.children && item.children.length > 0) {
      // Recursion
      currentMenu.children = generator(item.children, currentMenu);
    }
    return currentMenu;
  });
};

const breadcrumbList = computed(() => {
  return generator(route.matched);
});

onMounted(() => {
  checkMobileMode();
  window.addEventListener('resize', watchWidth);
});
</script>

<style lang="less">
.layout-side-drawer {
  background-color: rgb(0, 20, 40);

  .layout-sider {
    min-height: 100vh;
    box-shadow: 2px 0 8px 0 rgb(29 35 41 / 5%);
    position: relative;
    z-index: 13;
    transition: all 0.2s ease-in-out;
  }
}
</style>
<style lang="less" scoped>
.left-menu {
  background-color: #FDFCF8;
}

.layout {
  display: flex;
  flex-direction: row;
  flex: auto;

  &-default-background {
    background: #f5f7f9;
  }

  .layout-sider {
    min-height: 100vh;
    box-shadow: 2px 0 8px 0 rgb(29 35 41 / 5%);
    position: relative;
    z-index: 13;
    transition: all 0.2s ease-in-out;
  }

  .layout-sider-fix {
    position: fixed;
    top: 0;
    left: 0;
  }

  .ant-layout {
    overflow: hidden;
  }

  .layout-right-fix {
    overflow-x: hidden;
    padding-left: 200px;
    min-height: 100vh;
    transition: all 0.2s ease-in-out;
  }

  .layout-content {
    flex: auto;
    min-height: 100vh;
  }

  .n-layout-header.n-layout-header--absolute-positioned {
    z-index: 11;
  }

  .n-layout-footer {
    background: none;
  }
}

.layout-content-main {
  margin: 0 10px 10px;
  position: relative;
  padding-top: 64px;
}

.layout-content-main-fix {
  padding-top: 64px;
}

.fluid-header {
  padding-top: 0;
}

.main-view-fix {
  padding-top: 15px;
}

.noMultiTabs {
  padding-top: 0;
}
</style>
