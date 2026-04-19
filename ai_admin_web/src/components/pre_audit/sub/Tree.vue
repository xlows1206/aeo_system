<template>
  <div class="main">
    <n-scrollbar style="height: calc(100vh - 160px);">

      <!-- 第二层：文件勾选视图 -->
      <template v-if="params.activeFolder">
        <div class="back-bar" @click="params.activeFolder = null">
          <n-icon size="15"><ChevronBack /></n-icon>
          <span>返回审核项列表</span>
        </div>
        <div class="active-folder-title">{{ params.activeFolder.name }}</div>

        <div class="file-list">
          <n-checkbox-group v-model:value="params.checkedKeys" @update:value="updateCheckedKeys">
            <n-flex vertical gap="10">
              <n-checkbox
                v-for="file in params.activeFolder.files"
                :key="file.id"
                :value="file.id"
                class="file-checkbox"
              >
                <div class="file-label">
                  <n-icon size="14" class="file-icon"><document-outline /></n-icon>
                  {{ file.name }}
                </div>
              </n-checkbox>
              <div v-if="params.activeFolder.files.length === 0" class="empty-tip">
                该审核项下暂无已上传文件
              </div>
            </n-flex>
          </n-checkbox-group>
        </div>
      </template>

      <!-- 第一层：叶子文件夹（审核项）列表 -->
      <template v-else>
        <div v-if="params.leafFolders.length === 0" class="flex justify-center p-8">
          <n-empty description="该分类下暂无审核项目" />
        </div>
        <div
          v-for="folder in params.leafFolders"
          :key="folder.folderId"
          class="folder-row"
          @click="params.activeFolder = folder"
        >
          <div class="folder-left">
            <n-icon size="18" class="folder-icon"><folder-open-outline /></n-icon>
            <span class="folder-name">{{ folder.name }}</span>
            <n-tag v-if="folder.selectedCount > 0" size="tiny" type="success" round class="count-tag">
              已选 {{ folder.selectedCount }}
            </n-tag>
          </div>
          <n-icon size="16" class="arrow-icon"><ChevronForward /></n-icon>
        </div>
      </template>

    </n-scrollbar>
  </div>
</template>

<script lang="ts" setup>
import { reactive, watch } from 'vue';
import { NScrollbar, NCheckboxGroup, NCheckbox, NFlex, NEmpty, NTag, NIcon } from 'naive-ui';
import { ChevronBack, ChevronForward, DocumentOutline, FolderOpenOutline } from '@vicons/ionicons5';
import { apiGetFileLists } from '@/api/system/pre';

const props = defineProps({
  defaultCheckedKeys: {
    type: Array,
    default: () => [],
  },
  standard_id: {
    type: Number,
  },
  createType: {
    type: String,
  },
});

const emits = defineEmits(['getData']);

const params = reactive({
  // 叶子文件夹列表（审核项）
  leafFolders: [] as Array<{
    folderId: string;
    name: string;
    files: Array<{ id: number; name: string }>;
    selectedCount: number;
  }>,
  // 当前展开的文件夹（第二层）
  activeFolder: null as any,
  // 全局选中的文件 ID 列表
  checkedKeys: [...props.defaultCheckedKeys] as any[],
});

const updateCheckedKeys = (data: any) => {
  emits('getData', data);
};

// 同步每个文件夹的已选数量
const syncCounts = () => {
  params.leafFolders.forEach((folder) => {
    folder.selectedCount = folder.files.filter((f) => params.checkedKeys.includes(f.id)).length;
  });
};

watch(() => params.checkedKeys, syncCounts, { deep: true });

/**
 * 收集所有审核项目文件夹（以后端 is_check_folder 标志为权威来源）。
 * 不依赖树结构推断，用户在文件夹下新建子文件夹不会影响判断。
 */
const collectCheckFolders = (nodes: any[]): any[] => {
  const result: any[] = [];

  const traverse = (items: any[]) => {
    for (const item of items) {
      if (item.type !== 'folder') continue;

      if (item.is_check_folder) {
        // 该文件夹被 folder_check_files 标记为审核项，收集其直属文件
        const directFiles = (item.children || [])
          .filter((c: any) => c.type === 'file')
          .map((f: any) => ({ id: f.id, name: f.name }));

        result.push({
          folderId: item.id,
          name: item.name,
          files: directFiles,
          selectedCount: 0,
        });
      }

      // 无论是否是审核项，都继续递归以收集更深层的审核项
      if (item.children && item.children.length > 0) {
        traverse(item.children);
      }
    }
  };

  traverse(nodes);
  return result;
};

apiGetFileLists({
  standard_id: props.standard_id,
}).then((res) => {
  params.leafFolders = collectCheckFolders(res);
  syncCounts();
});
</script>

<style scoped lang="less">
.main {
  padding: 4px 0;
}

/* 返回栏 */
.back-bar {
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 10px 16px;
  font-size: 13px;
  color: #18a058;
  font-weight: 500;
  cursor: pointer;
  border-bottom: 1px solid #f0f0f0;

  &:hover {
    background: #f6fff9;
  }
}

.active-folder-title {
  padding: 10px 16px 8px;
  font-size: 14px;
  font-weight: 600;
  color: #333;
  border-bottom: 1px solid #efefef;
  margin-bottom: 4px;
}

/* 审核项列表行 */
.folder-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 14px 16px;
  border-bottom: 1px solid #f5f5f5;
  cursor: pointer;
  transition: background 0.15s;

  &:hover {
    background: #fafff8;

    .arrow-icon {
      color: #18a058;
    }
  }

  &:last-child {
    border-bottom: none;
  }
}

.folder-left {
  display: flex;
  align-items: center;
  gap: 10px;
  flex: 1;
  min-width: 0;
}

.folder-icon {
  color: #d4a017;
  flex-shrink: 0;
}

.folder-name {
  font-size: 13px;
  color: #333;
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.count-tag {
  flex-shrink: 0;
}

.arrow-icon {
  color: #ccc;
  flex-shrink: 0;
  transition: color 0.15s;
}

/* 文件勾选列表 */
.file-list {
  padding: 14px 20px;
}

.file-checkbox {
  font-size: 13px;
}

.file-label {
  display: flex;
  align-items: center;
  gap: 6px;
  color: #444;
}

.file-icon {
  color: #aaa;
  flex-shrink: 0;
}

.empty-tip {
  color: #bbb;
  font-size: 12px;
  text-align: center;
  padding: 24px 0;
  font-style: italic;
}
</style>
