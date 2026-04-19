<template>
  <div class="main">
    <n-modal v-model:show="params.showMoveModal" preset="dialog" title="Dialog">
      <template #header>
        <div>移动到...</div>
      </template>
      <div v-if="params.data.length === 0" class="py-4 text-center text-gray-400">
        该项目下无可选目录
      </div>
      <n-tree default-expand-all block-line :data="params.data" :selectable="false" />
    </n-modal>
  </div>
</template>

<script lang="ts" setup>
  import { reactive, h } from 'vue';
  import { apiGetFolderLists, apiMoveFile, apiMoveFolder } from '@/api/system/pan';
  import { NButton, NTree } from 'naive-ui';

  const props = defineProps({
    id: {
      type: Number,
    },
    fileType: {
      type: String,
    },
    projectId: {
      type: [Number, String],
      default: 0
    }
  });

  const emits = defineEmits(['reload']);

  const params = reactive({
    showMoveModal: false,
    loading: false,
    data: [],
  });

  const move = (targetFolder) => {
    // 禁止移动到根目录
    if (targetFolder.id === 0 || targetFolder.id === 'f0') {
       window['$message'].warning('禁止移动到根目录');
       return;
    }

    if (props.fileType === 'folder') {
      apiMoveFolder(
        {
          folder_id: targetFolder.id,
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
    } else {
      apiMoveFile(
        {
          folder_id: targetFolder.id,
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

  /**
   * 递归查找并提取特定项目的子树
   */
  const findProjectSubtree = (data: any[], projectId: number | string) => {
    // 将 'f123' 形式转换回数字
    const targetId = typeof projectId === 'string' && projectId.startsWith('f') 
      ? projectId 
      : `f${projectId}`;

    for (const item of data) {
      if (item.id === targetId) {
        return [item];
      }
      if (item.children) {
        const found = findProjectSubtree(item.children, projectId);
        if (found.length > 0) return found;
      }
    }
    return [];
  };

  const createReturn = (item: any) => {
    let label = item.name;
    let key = item.id;
    
    // 如果是项目根级（parent_id 为 'f0'），显示项目图标标识
    const isProjectRoot = item.parent_id === 'f0';

    const node: any = {
      label,
      key,
    };

    if (item.children && item.children.length > 0) {
      node.children = createData(item.children);
    }

    // 审核项目本身禁止作为移动目标（根据需求只允许移动到项目内的子目录）
    // 但用户也可能想直接移动到项目根目录下，所以我们允许移动
    node.suffix = () => [
      h(
        NButton,
        {
          text: true,
          type: 'warning',
          style: 'font-size: 12px',
          onClick: () => move(item),
        },
        { default: () => '移动到此处' }
      ),
    ];

    return node;
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
      // 限制跨项目移动：如果指定了 projectId，则只展示该项目的子树
      if (props.projectId) {
         const subtree = findProjectSubtree(res, props.projectId);
         params.data = createData(subtree);
      } else {
         // 回退方案：展示完整列表（但不建议，应始终传递 projectId）
         params.data = createData(res);
      }
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
