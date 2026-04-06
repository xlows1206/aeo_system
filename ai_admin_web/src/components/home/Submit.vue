<template>
  <div class="main">
    <n-drawer v-model:show="params.active" :width="600" placement="right">
    </n-drawer>
  </div>
</template>

<script lang="ts" setup>
import {reactive, ref, toRaw} from 'vue';
import componentMapper from '@/components/pre_audit/sub/componentMapper';


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

const scrollbarRef: any = ref(null);

const openDrawer = () => {
  params.active = true;
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

<style scoped lang="less"></style>
