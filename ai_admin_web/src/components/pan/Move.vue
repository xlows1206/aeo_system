<template>
  <div class="main">
    <n-modal v-model:show="params.showMoveModal" preset="dialog" title="Dialog">
      <template #header>
        <div>移动</div>
      </template>
      <n-tree default-expand-all block-line :data="params.data" :selectable="false" />
    </n-modal>
  </div>
</template>

<script lang="ts" setup>
  import { reactive, h } from 'vue';
  import {apiGetFolderLists, apiMoveFile, apiMoveFolder} from '@/api/system/pan';
  import { NButton } from 'naive-ui';

  const props = defineProps({
    id: {
      type: Number,
    },
    fileType: {
      type: String,
    }
  });

  const emits = defineEmits(['reload']);

  const params = reactive({
    showMoveModal: false,
    loading: false,
    data: [],
  });

  const move = (item) => {

    if (props.fileType === 'folder') {
      apiMoveFolder(
        {
          folder_id: item.id,
        },
        props.id
      )
        .then(() => {
          emits('reload');
          params.showMoveModal = false;
          window['$message'].success('操作成功');
        })
        .catch((err) => {
          window['$message'].error(err.message);
        });
    } else  {
      apiMoveFile(
        {
          folder_id: item.id,
        },
        props.id
      )
        .then(() => {
          emits('reload');
          params.showMoveModal = false;
          window['$message'].success('操作成功');
        })
        .catch((err) => {
          window['$message'].error(err.message);
        });
    }

  };

  const createReturn = (item: any) => {
    let label = item.name;
    let key = item.id;
    if (item.children && item.children.length > 0) {
      return {
        label,
        key,
        children: createData(item.children),
        suffix: () => [
          h(
            NButton,
            {
              text: true,
              type: 'warning',
              onClick: () => move(item),
            },
            { default: () => '移动' }
          ),
        ],
      };
    } else {
      return {
        label,
        key,
        suffix: () => [
          h(
            NButton,
            {
              text: true,
              type: 'warning',
              onClick: () => move(item),
            },
            { default: () => '移动' }
          ),
        ],
      };
    }
  };

  const createData = (data) => {
    let temp = [];
    for (let item of data) {
      temp.push(createReturn(item));
    }
    return temp;
  };

  const openModal = () => {
    params.showMoveModal = true;
    apiGetFolderLists().then((res) => {
      params.data = createData(res);
    });
  };

  const closeModal = () => {
    params.showMoveModal = false;
  };

  defineExpose({
    openModal,
    closeModal,
  });
</script>

<style scoped lang="less"></style>
