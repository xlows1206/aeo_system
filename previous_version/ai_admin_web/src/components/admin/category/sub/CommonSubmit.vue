<template>
  <div class="main">
    <v-tree
      :createType="props.createType"
      @getData="updateCheckedKeys"
      :defaultCheckedKeys="params.currentData"
      :standard_id="props.currentPre.id"
    ></v-tree>
    <n-button
      :type="maxPre === props.currentPreIndex ? 'primary' : 'primary'"
      style="float: right"
      @click="onSubmit"
    >提交
    </n-button
    >
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

<style scoped lang="less"></style>
