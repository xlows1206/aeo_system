<template>
  <div class="main">
    <n-card :bordered="false"
      >Ai审核结果：
      <n-tag :type="params.status_type[params.currentData.result]">
        {{ params.status_cn[params.currentData.result] }}
      </n-tag>
    </n-card>
    <n-card :bordered="false"
      >海关审核结果：
      <n-tag :type="params.status_type[params.currentData.customsResult || 0]">
        {{ params.status_cn[params.currentData.customsResult || 0] }}
      </n-tag>
    </n-card>
    <n-card :bordered="false"
      >文件列表：
      <n-list style="background: linear-gradient(to right, #FBFAEF, #FEFFFE) !important">
        <n-list-item v-for="(item, index) in params.files" :key="index">
          <n-button
            text
            @click="funDownload(item.url + '?attname=' + item.name + '.' + item.suffix)"
          >
            {{ item.name }}
          </n-button>
        </n-list-item>
      </n-list>
    </n-card>

    <div style="float: right">
      <n-button type="error" @click="onSubmit(1)">不合格</n-button>
      <n-button type="success" style="margin-left: 15px" @click="onSubmit(3)">合格</n-button>
    </div>
  </div>
</template>

<script lang="ts" setup>
  import { reactive } from 'vue';
  import { NButton } from 'naive-ui';
  import VTree from '@/components/pre_audit/sub/Tree.vue';
  import { apiGetFileById } from '@/api/system/pan';

  const props = defineProps({
    currentPre: {
      type: Object,
      default: () => {},
    },
    currentData: {
      type: Object,
      default: () => {},
    },
    maxPre: {
      type: Number,
      default: 1,
    },
    currentPreIndex: {
      type: Number,
      default: 1,
    },
  });

  const emits = defineEmits(['next']);

  const params = reactive({
    currentData: [],
    status_cn: ['正在审核', '不合格', '', '合格'],

    status_type: ['default', 'error', 'warning', 'success'],
    files: [],
  });

  if (props.currentData.info) {
    params.currentData = props.currentData.info[props.currentPreIndex - 1];
    // 获取文件链接
    apiGetFileById({
      ids: params.currentData.data,
    }).then((res) => {
      params.files = res.lists;
    });
  }
  const onSubmit = (auditResult: number) => {
    emits('next', {
      currentPre: props.currentPre,
      currentPreIndex: props.currentPreIndex,
      data: params.currentData.data,
      customsResult: auditResult,
    });
  };

  const funDownload = (url: string) => {
    const downloadElement = document.createElement('a');
    downloadElement.style.display = 'none';
    downloadElement.href = url;
    downloadElement.target = '_blank';
    document.body.appendChild(downloadElement);
    downloadElement.click();
    document.body.removeChild(downloadElement);
  };
</script>

<style scoped lang="less"></style>
