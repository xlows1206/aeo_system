<template>
  <div class="main">
    <n-drawer v-model:show="params.active" :width="600" placement="right">
      <n-drawer-content :title="props.drawerParams.title">
        <div class="tabs-container">
          <n-tabs
            v-model:value="params.current"
            type="card"
            @update:value="changeCurrent"
          >
            <n-tab
              v-for="(item, index) in params.preLists"
              :key="index"
              :name="index + 1"
              :label="item.name"
            />
          </n-tabs>
        </div>

        <div v-for="(item, index) in params.preLists">
          <component
            v-if="params.current - 1 === index"
            createType="create"
            class="page-item mt-4"
            @next="nextCurrent"
            :maxPre="params.preLists.length"
            :currentData="props.drawerParams.data"
            :currentPreIndex="params.current"
            :currentPre="item"
            :is="componentMapper[item.component]"
          />
        </div>
      </n-drawer-content>
    </n-drawer>
  </div>
</template>

<script lang="ts" setup>
import {reactive, ref, toRaw} from 'vue';
  import componentMapper from '@/components/pre_audit/sub/componentMapper';
  import { apiGetStandard } from '@/api/system/pan';
  import { apiStorePreAudit, apiUpdatePreAudit } from '@/api/system/pre';


  const props = defineProps({
    drawerParams: {
      type: Object,
      default: () => {
        return {
          title: '提交预审',
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
  });

  apiGetStandard().then((res) => {
    params.preLists = res.lists;
    // params.current = res.first_standard;
  });

  const changeCurrent = (index: number) => {
    params.current = index;
  };

  const nextCurrent = (data: any) => {
    params.perData[params.current - 1] = {
      data: data.data,
      score: 0,
      result: 0,
      customsResult: 0,
      type: data.currentPre.type,
      name: data.currentPre.name,
      id: data.currentPre.id,
      component: data.currentPre.component,
    };
    // 判断是否有没有值的对象
    if (props.drawerParams.type === 'add') {
      apiStorePreAudit({
        info: params.perData,
      })
        .then(() => {
          emits('reloadTable');
          window['$message'].success('操作成功');
        })
        .catch((err) => {
          window['$message'].error(err.message);
        });
    } else {
      apiUpdatePreAudit(
        {
          info: params.perData,
        },
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
    closeDrawer()
    // if (data.currentPreIndex >= params.preLists.length) {
    //
    // } else {
    //   changeCurrent(++data.currentPreIndex);
    // }
  };

  const openDrawer = () => {
    params.active = true;
    console.log(props.drawerParams.data.info)
    params.current = 1;
    params.currentPreIndex = 0;
    if(props.drawerParams.data.info){
      const values = Object.values(props.drawerParams.data.info);
      const target = values.find(item => item && typeof item === 'object' && item.id);
      params.current = target ? target.id : null
      params.currentPreIndex = target - 1
    }
    params.perData = props.drawerParams.data.info || [];
  };

  const closeDrawer = () => {
    params.active = false;
    params.current = 1;
  };

  defineExpose({
    openDrawer,
    closeDrawer,
  });
</script>

<style scoped lang="less">
:deep(.n-drawer-header__main) {
  color: #d4a017 !important;
  font-weight: 800;
}

.tabs-container {
  :deep(.n-tabs-tab--active) {
    .n-tabs-tab__label {
      color: #d4a017 !important;
    }
  }
}
</style>
