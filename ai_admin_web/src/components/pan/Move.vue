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
    },
    standardId: {
      type: Number,
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
          folder_id: String(targetFolder.id).replace('f', ''),
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
          folder_id: String(targetFolder.id).replace('f', ''),
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

  const findProjectNode = (data: any[], projectId: number | string) => {
    const targetId = typeof projectId === 'string' && projectId.startsWith('f') 
      ? projectId 
      : `f${projectId}`;

    for (const item of data) {
      if (item.id === targetId) {
        return item;
      }
      if (item.children) {
        const found = findProjectNode(item.children, projectId);
        if (found) return found;
      }
    }
    return null;
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

    if (item.type === 'folder') {
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
    }

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
    apiGetFolderLists({ standard_id: props.standardId }).then((res: any) => {
      const treeData = res?.tree || [];
      
      if (props.projectId) {
         // 查找项目文件夹节点
         const projectNode = findProjectNode(treeData, props.projectId);
         if (projectNode) {
            // 构造一个包含“项目根目录”和其子目录的新树
            const rootNode = {
               ...projectNode,
               name: '项目根目录 (点此移动到根目录)',
               children: projectNode.children || []
            };
            params.data = createData([rootNode]);
         } else {
            params.data = [];
         }
      } else {
         params.data = createData(treeData);
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
