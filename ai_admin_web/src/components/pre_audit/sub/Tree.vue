<template>
  <div class="main">
    <n-scrollbar style="height: 100%;">
      <div v-if="params.leafFolders.length === 0" class="flex justify-center p-8">
        <n-empty description="该分类下暂无审核项目" />
      </div>
      
      <n-collapse v-model:expanded-names="params.activeGroupNames" class="category-collapse">
        <n-collapse-item 
          v-for="(folders, groupName) in groupedFolders" 
          :key="groupName" 
          :name="groupName"
        >
          <template #header>
            <div class="group-header">
              <span class="group-title">{{ groupName }}</span>
              <n-tag v-if="getGroupSelectedCount(folders) > 0" size="tiny" type="success" round class="ml-2">
                已选 {{ getGroupSelectedCount(folders) }}
              </n-tag>
            </div>
          </template>

          <div class="folder-container">
            <div v-for="folder in folders" :key="folder.folderId" class="folder-item">
              <div 
                class="folder-row"
                :class="{ 'is-active': params.expandedFolderIds.includes(folder.folderId) }"
                @click="toggleFolder(folder.folderId)"
              >
                <div class="folder-left">
                  <div class="folder-icon-wrapper">
                    <n-icon size="18">
                      <component :is="params.expandedFolderIds.includes(folder.folderId) ? FolderOpenOutline : FolderOutline" />
                    </n-icon>
                  </div>
                  <div class="folder-info">
                    <span class="folder-name">{{ formatFolderName(folder.name) }}</span>
                    <span v-if="params.expandedFolderIds.includes(folder.folderId)" class="folder-full-path">
                      {{ folder.name }}
                    </span>
                  </div>
                  <n-tag v-if="folder.selectedCount > 0" size="tiny" type="success" round strong class="count-tag">
                    已选 {{ folder.selectedCount }}
                  </n-tag>
                </div>
                <div class="folder-right">
                  <n-icon size="16" class="arrow-icon" :class="{ 'is-rotated': params.expandedFolderIds.includes(folder.folderId) }">
                    <ChevronForward />
                  </n-icon>
                </div>
              </div>

              <!-- 文件选择区域：改为分组结构 -->
              <transition name="fade-slide">
                <div v-if="params.expandedFolderIds.includes(folder.folderId)" class="file-selection-pane">
                  <div v-if="folder.groups.length === 0" class="empty-file-placeholder">
                    <n-icon size="14"><EyeOutline /></n-icon>
                    <span>该项暂无待审文件</span>
                  </div>
                  
                  <div v-else class="groups-container">
                    <div v-for="group in folder.groups" :key="group.id" class="file-group">
                      <div class="group-checkbox-row">
                        <n-checkbox 
                          :checked="isGroupChecked(group.files)" 
                          :indeterminate="isGroupIndeterminate(group.files)"
                          @update:checked="(val) => toggleGroup(val, group.files)"
                        >
                          <div class="group-label">
                            <n-icon size="16"><FolderOpenOutline /></n-icon>
                            <span class="group-name-text">{{ group.name }}</span>
                          </div>
                        </n-checkbox>
                      </div>
                      
                      <div class="group-files-list">
                        <n-checkbox-group v-model:value="params.checkedKeys" @update:value="updateCheckedKeys">
                          <div class="file-grid">
                            <n-checkbox
                              v-for="file in group.files"
                              :key="file.id"
                              :value="file.id"
                              class="file-checkbox-item"
                            >
                              <div class="file-content">
                                <n-icon size="16" class="file-icon"><document-outline /></n-icon>
                                <span class="file-text">{{ file.name }}</span>
                              </div>
                            </n-checkbox>
                          </div>
                        </n-checkbox-group>
                      </div>
                    </div>
                  </div>
                </div>
              </transition>
            </div>
          </div>
        </n-collapse-item>
      </n-collapse>
    </n-scrollbar>
  </div>
</template>

<script lang="ts" setup>
import { reactive, watch, h, ref, computed } from 'vue';
import { NScrollbar, NCheckboxGroup, NCheckbox, NFlex, NEmpty, NTag, NIcon, NButton, NModal, NImage, NCollapse, NCollapseItem } from 'naive-ui';
import { ChevronBack, ChevronForward, DocumentOutline, FolderOpenOutline, FolderOutline, EyeOutline } from '@vicons/ionicons5';
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
    groupName: string;
    groups: Array<{
      id: string;
      name: string;
      files: Array<{ id: number; name: string }>;
    }>;
    selectedCount: number;
    check_type?: number;
  }>,
  // 展开的文件夹 ID 列表
  expandedFolderIds: [] as string[],
  // 全局选中的文件 ID 列表
  checkedKeys: [...props.defaultCheckedKeys] as any[],
  activeGroupNames: [] as string[],
});

const toggleFolder = (id: string) => {
  const index = params.expandedFolderIds.indexOf(id);
  if (index > -1) {
    params.expandedFolderIds.splice(index, 1);
  } else {
    params.expandedFolderIds.push(id);
  }
};

const formatFolderName = (name: string) => {
  if (!name) return '';
  const slashParts = name.split(' / ');
  const baseName = slashParts[slashParts.length - 1];
  const commaParts = baseName.split(' 、 ');
  return commaParts[commaParts.length - 1];
};

const updateCheckedKeys = (data: any) => {
  emits('getData', data);
};

// 分组全选逻辑
const isGroupChecked = (files: any[]) => {
  if (files.length === 0) return false;
  return files.every(f => params.checkedKeys.includes(f.id));
};

const isGroupIndeterminate = (files: any[]) => {
  const checkedCount = files.filter(f => params.checkedKeys.includes(f.id)).length;
  return checkedCount > 0 && checkedCount < files.length;
};

const toggleGroup = (checked: boolean, files: any[]) => {
  const fileIds = files.map(f => f.id);
  let newCheckedKeys = [...params.checkedKeys];
  
  if (checked) {
    fileIds.forEach(id => {
      if (!newCheckedKeys.includes(id)) {
        newCheckedKeys.push(id);
      }
    });
  } else {
    newCheckedKeys = newCheckedKeys.filter(id => !fileIds.includes(id));
  }
  
  params.checkedKeys = newCheckedKeys;
  updateCheckedKeys(newCheckedKeys);
};

// 动态分组逻辑：按顶级分类名称分组
const groupedFolders = computed(() => {
  const groups: Record<string, any[]> = {};
  
  params.leafFolders.forEach(folder => {
      const groupName = (!folder.groupName || folder.groupName === '根目录') ? '其他审核项' : folder.groupName;
      
      if (!groups[groupName]) {
          groups[groupName] = [];
      }
      groups[groupName].push(folder);
  });

  const sortedGroups: Record<string, any[]> = {};
  const weights = ['一', '二', '三', '四', '五', '六', '七', '八', '九', '十'];
  
  Object.keys(groups).sort((a, b) => {
    const weightA = weights.indexOf(a.substring(0, 1)) === -1 ? 99 : weights.indexOf(a.substring(0, 1));
    const weightB = weights.indexOf(b.substring(0, 1)) === -1 ? 99 : weights.indexOf(b.substring(0, 1));
    return weightA - weightB;
  }).forEach(key => {
    sortedGroups[key] = groups[key];
  });

  return sortedGroups;
});

const getGroupSelectedCount = (folders: any[]) => {
    return folders.reduce((sum, f) => sum + (f.selectedCount || 0), 0);
};

// 同步每个文件夹的已选数量
const syncCounts = () => {
  params.leafFolders.forEach((folder) => {
    let count = 0;
    folder.groups.forEach(group => {
       count += group.files.filter(f => params.checkedKeys.includes(f.id)).length;
    });
    folder.selectedCount = count;
  });
};

watch(() => params.checkedKeys, syncCounts, { deep: true });

/**
 * 收集所有审核项目文件夹。
 */
const collectCheckFolders = (nodes: any): any[] => {
  const result: any[] = [];
  if (!nodes || !Array.isArray(nodes)) return result;

  const getAllFiles = (item: any, currentPath: string = ''): any[] => {
    let files: any[] = [];
    if (!item.children || !Array.isArray(item.children)) return files;
    
    for (const child of item.children) {
      if (child.type === 'file') {
        files.push({ 
          id: child.id, 
          name: currentPath ? `${currentPath} / ${child.name}` : child.name 
        });
      } else if (child.type === 'folder') {
        const subFiles = getAllFiles(child, currentPath ? `${currentPath} / ${child.name}` : child.name);
        files = files.concat(subFiles);
      }
    }
    return files;
  };

  const getStructure = (item: any): any[] => {
    const groups: any[] = [];
    if (!item.children || !Array.isArray(item.children)) return groups;

    // 1. 提取根目录下的直接文件
    const rootFiles = item.children
      .filter((c: any) => c.type === 'file')
      .map((c: any) => ({ id: c.id, name: c.name }));
    
    if (rootFiles.length > 0) {
      groups.push({
        id: 'root-' + item.id,
        name: '项目根目录',
        files: rootFiles
      });
    }

    // 2. 提取直接子文件夹，并递归获取其内所有文件（用于打平显示子目录）
    const subFolders = item.children.filter((c: any) => c.type === 'folder');
    subFolders.forEach((sub: any) => {
      const files = getAllFiles(sub);
      if (files.length > 0) {
        groups.push({
          id: sub.id,
          name: sub.name,
          files: files
        });
      }
    });

    return groups;
  };

  const traverse = (items: any[], currentGroupName: string = '') => {
    if (!items || !Array.isArray(items)) return;
    for (const item of items) {
      if (!item || item.type !== 'folder') continue;

      let groupName = currentGroupName;
      if (!groupName && item.name !== '根目录') {
          groupName = item.name;
      }

      if (item.is_check_folder) {
        result.push({
          folderId: item.id,
          name: item.name,
          groupName: groupName,
          groups: getStructure(item),
          selectedCount: 0,
          check_type: item.check_type || 0,
        });
      }

      if (item.children && item.children.length > 0) {
        traverse(item.children, groupName);
      }
    }
  };

  traverse(nodes);
  return result;
};

const loadData = () => {
  apiGetFileLists({
    standard_id: props.standard_id,
  }).then((res: any) => {
    const data = res?.tree || (Array.isArray(res) ? res : (res?.data || []));
    params.leafFolders = collectCheckFolders(data);
    syncCounts();
    params.activeGroupNames = Object.keys(groupedFolders.value);
  }).catch(err => {
    console.error('[DEBUG] API Error:', err);
  });
};

watch(() => props.standard_id, loadData, { immediate: true });
</script>

<style scoped lang="less">
.main {
  padding: 0;
  height: 100%;
  background: #fff;
}

.category-collapse {
  padding: 0 12px;
  
  :deep(.n-collapse-item__header) {
    padding-top: 12px !important;
    padding-bottom: 12px !important;
  }
}

.group-header {
  display: flex;
  align-items: center;
}

.group-title {
  font-weight: 800;
  color: #d4a017;
  font-size: 15px;
  letter-spacing: 0.5px;
}

.folder-container {
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding: 8px 0 16px 4px;
}

.folder-item {
  border-radius: 8px;
  overflow: hidden;
  border: 1px solid #f0f0f0;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  
  &:hover {
    border-color: #d4a017;
    box-shadow: 0 2px 8px rgba(212, 160, 23, 0.1);
  }
}

.folder-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 14px;
  cursor: pointer;
  background: #fff;
  transition: all 0.3s;

  &.is-active {
    background: linear-gradient(90deg, #fffef0 0%, #fff 100%);
    border-bottom: 1px solid #fdf6d2;
    
    .folder-icon-wrapper {
      background: #d4a017;
      color: #fff;
    }
    
    .folder-name {
      color: #d4a017;
      font-weight: 600;
    }
  }
}

.folder-left {
  display: flex;
  align-items: center;
  gap: 12px;
  flex: 1;
  min-width: 0;
}

.folder-icon-wrapper {
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 6px;
  background: #fff9e6;
  color: #d4a017;
  transition: all 0.3s;
}

.folder-info {
  display: flex;
  flex-direction: column;
  flex: 1;
  min-width: 0;
}

.folder-name {
  font-size: 13.5px;
  color: #333;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.folder-full-path {
  font-size: 11px;
  color: #999;
  margin-top: 2px;
}

.count-tag {
  margin-left: 8px;
}

.arrow-icon {
  color: #c0c0c0;
  transition: transform 0.3s;
  
  &.is-rotated {
    transform: rotate(90deg);
    color: #d4a017;
  }
}

.file-selection-pane {
  padding: 12px 12px 16px 12px;
  background: rgba(249, 249, 249, 0.5);
}

.groups-container {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.file-group {
  background: #fff;
  border-radius: 6px;
  border: 1px solid #f0f0f0;
  padding: 10px;
}

.group-checkbox-row {
  padding-bottom: 8px;
  border-bottom: 1px dashed #eee;
  margin-bottom: 10px;
  
  .group-label {
    display: flex;
    align-items: center;
    gap: 6px;
    color: #d4a017;
    font-weight: bold;
  }
  
  .group-name-text {
    font-size: 13px;
  }
}

.group-files-list {
  padding-left: 24px;
}

.file-grid {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.file-checkbox-item {
  :deep(.n-checkbox__label) {
    padding-left: 8px;
    width: 100%;
  }
}

.file-content {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #555;
  transition: color 0.2s;
  
  &:hover {
    color: #d4a017;
  }
}

.file-icon {
  color: #999;
}

.file-text {
  font-size: 13px;
}

.empty-file-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  padding: 16px 0;
  color: #bbb;
  font-size: 12px;
  font-style: italic;
}

/* 动画效果 */
.fade-slide-enter-active,
.fade-slide-leave-active {
  transition: all 0.3s ease-out;
  max-height: 800px;
}

.fade-slide-enter-from,
.fade-slide-leave-to {
  opacity: 0;
  max-height: 0;
  transform: translateY(-10px);
}
</style>
