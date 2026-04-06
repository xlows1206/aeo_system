<template>
  <div class="main">
    <n-button
      :type="maxPre === props.currentPreIndex ? 'primary' : 'primary'"
      style="float: right"
      @click="onSubmit"
      >{{ maxPre === props.currentPreIndex ? '提交' : '下一步' }}</n-button
    >
  </div>
</template>

<script lang="ts" setup>
  import { reactive } from 'vue';
  import { NButton } from 'naive-ui';

  const props = defineProps({
    currentPre: {
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
    data: [],
    currentData: [],
  });

  const onSubmit = () => {
    emits('next', {
      currentPre: props.currentPre,
      currentPreIndex: props.currentPreIndex,
      data: params.currentData,
    });
  };
</script>

<style scoped lang="less"></style>
