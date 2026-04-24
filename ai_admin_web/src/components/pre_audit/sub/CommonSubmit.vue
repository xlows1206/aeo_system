<template>
  <div class="main">
    <div class="content-area">
      <v-tree
        ref="treeRef"
        :createType="props.createType"
        @getData="updateCheckedKeys"
        :defaultCheckedKeys="params.currentData"
        :standard_id="props.currentPre.id"
      ></v-tree>
    </div>
    <div class="submit-footer mt-4 flex justify-end">
      <n-button
        :type="maxPre === props.currentPreIndex ? 'primary' : 'primary'"
        size="large"
        @click="onSubmit"
      >
        确认并提交
      </n-button>
    </div>
  </div>
</template>

<script lang="ts" setup>
import {reactive} from 'vue';
import {NButton} from 'naive-ui';
import VTree from '@/components/pre_audit/sub/Tree.vue';

const props = defineProps({
  currentPre: {
    type: Object,
    default: () => {
    },
  },
  currentData: {
    type: Object,
    default: () => {
    },
  },
  maxPre: {
    type: Number,
    default: 1,
  },
  currentPreIndex: {
    type: Number,
    default: 1,
  },
  createType: {
    type: String,
    default: 'create',
  }
});

const emits = defineEmits(['next']);

const params = reactive({
  currentData: [],
});

if (props.currentData.info) {
  params.currentData = props.currentData.info[props.currentPreIndex - 1].data;
}

const updateCheckedKeys = (data: any) => {
  params.currentData = data;
};

const onSubmit = () => {
  emits('next', {
    currentPre: props.currentPre,
    currentPreIndex: props.currentPreIndex,
    data: params.currentData,
  });
};
</script>

<style scoped lang="less">
.main {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 180px); /* 减去 Tab 和抽屉头部高度 */
}

.content-area {
  flex: 1;
  overflow: hidden; /* 由内部 scrollbar 处理滚动 */
}

.submit-footer {
  padding: 16px 0;
  border-top: 1px solid #f0f0f0;
  background: #fff;
  flex-shrink: 0;
}
</style>
