<template>
  <div class="main">
    <n-drawer v-model:show="params.active" :width="600" placement="right">
      <n-drawer-content :title="props.drawerParams.title">
        <n-timeline>
          <n-timeline-item
            v-for="(item, index) in params.lists"
            :key="index"
            :type="params.status_type[item.status]"
            :title="params.status_cn[item.status]"
            :time="item.created_at"
          >
            <template #default>
              <div v-html="item.ai_result"></div>
            </template>
          </n-timeline-item>
        </n-timeline>
      </n-drawer-content>
    </n-drawer>
  </div>
</template>

<script lang="ts" setup>
  import { reactive, ref } from 'vue';
  import { apiGetPreAuditLog } from '@/api/system/pre';

  const props = defineProps({
    drawerParams: {
      type: Object,
      default: () => {
        return {
          title: '审核详情',
        };
      },
    },
  });

  const params = reactive({
    active: false,
    lists: [],
    status_cn: ['正在审核', '不达标', '基本达标', '达标'],
    status_type: ['default', 'error', 'warning', 'success'],
  });

  const openDrawer = () => {
    params.active = true;
    apiGetPreAuditLog(props.drawerParams.data.id).then((res) => {
      params.lists = res.list;
    });
  };

  const closeDrawer = () => {
    params.active = false;
    params.lists = [];
  };

  defineExpose({
    openDrawer,
    closeDrawer,
  });
</script>

<style scoped lang="less"></style>
