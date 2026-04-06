<template>
  <div class="main">
    <n-drawer v-model:show="params.active" :width="600" placement="right">
      <n-drawer-content :title="props.drawerParams.title">
        <div>审核文件列表
          <div style="padding:5px;">
            <div v-for="(item, index) in params.files" style="padding:3px 0">
              {{index + 1}}、<a :href="item.url">{{item.name}}</a>
            </div>
          </div>
        </div>

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
    files: [],
    status_cn: ['正在审核', '不达标', '基本达标', '达标'],
    status_type: ['default', 'error', 'warning', 'success'],
  });

  const openDrawer = () => {
    params.active = true;
    apiGetPreAuditLog(props.drawerParams.data.id).then((res) => {
      params.lists = res.list;
      params.files = res.all_files;
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
