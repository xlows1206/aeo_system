<template>
  <div class="main">
    <n-tree
      :cascade="false"
      checkable
      default-expand-all
      block-line
      check-on-click
      :data="params.data"
      :default-checked-keys="props.defaultCheckedKeys"
      @update:checked-keys="updateCheckedKeys"
      :selectable="false"
    />
  </div>
</template>

<script lang="ts" setup>
  import { ref, reactive } from 'vue';
  import { apiGetFileLists } from '@/api/system/pre';

  const props = defineProps({
    defaultCheckedKeys: {
      type: Object,
    },
  });

  const params = reactive({
    data: [],
  });

  const emits = defineEmits(['getData']);

  const updateCheckedKeys = (data: any) => {
    emits('getData', data);
  };

  apiGetFileLists({
    standard_id: 1,
  }).then((res) => {
    params.data = createData(res);
  });

  const createData = (data) => {
    let temp = [];
    for (let item of data) {
      temp.push(createReturn(item));
    }
    return temp;
  };

  const createReturn = (item: any) => {
    let label = item.name;
    let key = item.id;
    if (item.children && item.children.length > 0) {
      return {
        label,
        key,
        disabled: item.type === 'folder',
        children: createData(item.children),
      };
    } else {
      return {
        label,
        key,
        disabled: item.type === 'folder',
      };
    }
  };
</script>

<style scoped lang="less"></style>
