<template>
  <div class="main">
    <n-drawer v-model:show="params.active" :width="680" placement="right">
      <n-drawer-content :title="props.drawerParams.title" :native-scrollbar="false">

        <!-- 项目审核结果 -->
        <div class="section-title">项目审核结果</div>
        
        <div v-if="groupedProjects.length === 0" class="flex justify-center p-8">
          <n-empty description="暂无审核项目数据" />
        </div>

        <div class="folder-container">
          <div v-for="(project, index) in groupedProjects" :key="project.check_id" class="folder-item">
            <div
              class="folder-row"
              :class="{ 'is-active': expandedIds.includes(project.check_id) }"
              @click="toggleExpand(project.check_id)"
            >
              <div class="folder-left">
                <div class="folder-icon-wrapper">
                  <n-icon size="18">
                    <component :is="expandedIds.includes(project.check_id) ? FolderOpenOutline : FolderOutline" />
                  </n-icon>
                </div>
                <div class="folder-info">
                  <span class="folder-name">
                    {{ extractProjectName(project.project_name || project.folder_name) }}
                  </span>
                  <span v-if="expandedIds.includes(project.check_id)" class="folder-full-path">
                    {{ project.project_name || project.folder_name }}
                  </span>
                </div>
                <n-tag
                  v-if="project.audit_result"
                  :type="project.audit_result.is_access ? 'success' : 'error'"
                  size="small"
                  round
                  strong
                  class="result-tag"
                >
                  {{ project.audit_result.is_access ? '合格' : '不合格' }}
                </n-tag>
              </div>
              <div class="folder-right">
                <n-icon size="16" class="arrow-icon" :class="{ 'is-rotated': expandedIds.includes(project.check_id) }">
                  <ChevronForward />
                </n-icon>
              </div>
            </div>

            <!-- 展开的文件明细 -->
            <transition name="fade-slide">
              <div v-if="expandedIds.includes(project.check_id)" class="file-selection-pane">
                <div class="sub-section-inner-title">关联文件明细</div>
                <div class="file-list">
                  <div v-for="(file, fi) in project.files" :key="fi" class="file-item-with-result">
                    <div class="file-info-row">
                      <div class="file-name-row">
                        <n-icon size="14" class="file-doc-icon"><DocumentOutline /></n-icon>
                        <span class="file-name-bold">{{ file.name }}</span>
                      </div>
                      <span v-if="getFileResult(project, file.name)" :class="['status-tag', getFileResult(project, file.name).status ? 'success' : 'error']">
                        {{ getFileResult(project, file.name).status ? '✓ 合格' : '✗ 不合格' }}
                      </span>
                    </div>
                    <div v-if="getFileResult(project, file.name)" class="file-result-text">
                      {{ getFileResult(project, file.name).text }}
                    </div>
                  </div>
                  <div v-if="project.files.length === 0" class="empty-text">无关联文件</div>
                </div>


              </div>
            </transition>
          </div>
        </div>

      </n-drawer-content>
    </n-drawer>
  </div>
</template>

<script lang="ts" setup>
  import { reactive, computed, ref } from 'vue';
  import { NDrawer, NDrawerContent, NTag, NEmpty, NIcon } from 'naive-ui';
  import { apiGetPreAuditLog } from '@/api/system/pre';
  import { extractProjectName } from '@/utils/index';
  import { FolderOpenOutline, FolderOutline, ChevronForward, DocumentOutline } from '@vicons/ionicons5';

  const props = defineProps({
    drawerParams: {
      type: Object,
      default: () => {
        return {
          title: '审核详情',
        };
      },
    },
  });

  const params = reactive({
    active: false,
    lists: [],
    files: [],
    auditResults: [],
  });

  const expandedIds = ref<number[]>([]);

  const toggleExpand = (id: number) => {
    const idx = expandedIds.value.indexOf(id);
    if (idx > -1) {
      expandedIds.value.splice(idx, 1);
    } else {
      expandedIds.value.push(id);
    }
  };

  /**
   * 按审核项目 (check_id) 对文件进行分组
   * check_id 和 project_name 现在由后端通过 folder_closure JOIN 正确提供
   */
  const groupedProjects = computed(() => {
    const groups: Record<number, any> = {};
    params.files.forEach(file => {
      const checkId = file.check_id || 0;
      if (!groups[checkId]) {
        groups[checkId] = {
          check_id: checkId,
          project_name: file.project_name || '',
          folder_name: file.folder_name || '未归类项目',
          files: [],
          audit_result: null
        };
      }
      groups[checkId].files.push(file);
    });

    // 关联审核结果（按 check_id 匹配）
    params.auditResults.forEach(result => {
      const checkId = result.check_id;
      if (checkId && groups[checkId]) {
        groups[checkId].audit_result = result;
        groups[checkId].check_type = result.check_type;
      }
    });

    return Object.values(groups).sort((a, b) => a.check_id - b.check_id);
  });



  const openDrawer = () => {
    params.active = true;
    expandedIds.value = [];
    apiGetPreAuditLog(props.drawerParams.data.id).then((res) => {
      params.lists = res.list;
      params.files = res.all_files;
      params.auditResults = res.audit_results || [];
    });
  };

  const closeDrawer = () => {
    params.active = false;
    params.lists = [];
    params.auditResults = [];
    params.files = [];
    expandedIds.value = [];
  };

  /**
   * 从项目审计结果中匹配特定文件的结论
   */
  const getFileResult = (project, fileName) => {
    if (!project.audit_result || !project.audit_result.result_str) return null;
    
    const resultStr = project.audit_result.result_str;
    const parts = resultStr.split('; ');
    const detail = parts.find(p => p.includes(`【${fileName}】`));
    
    if (!detail) return null;

    const isError = detail.includes('不符合') || detail.includes('ERROR') || detail.includes('未能') || detail.includes('失败') || detail.includes('无效');
    let text = detail.split('】: ')[1] || detail;
    
    return {
      status: !isError,
      text: text
    };
  };

  defineExpose({
    openDrawer,
    closeDrawer,
  });
</script>

<style scoped lang="less">
  .section-title {
    font-size: 15px;
    font-weight: 700;
    color: #1a1a2e;
    border-left: 4px solid #d4a017;
    padding-left: 12px;
    margin-bottom: 18px;
    letter-spacing: 0.5px;
  }

  .sub-section-inner-title {
    font-size: 13px;
    font-weight: bold;
    color: #4b5563;
    margin: 0 0 10px 0;
  }

  /* 与 Tree.vue 统一的文件夹卡片样式 */
  .folder-container {
    display: flex;
    flex-direction: column;
    gap: 8px;
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
    flex-shrink: 0;
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

  .result-tag {
    margin-left: 8px;
    flex-shrink: 0;
  }

  .folder-right {
    flex-shrink: 0;
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
    padding: 14px 14px 16px 14px;
    background: rgba(249, 249, 249, 0.5);
  }

  .file-list {
    background: #fff;
    border-radius: 6px;
    border: 1px solid #f0f0f0;
    padding: 12px;
  }

  .file-item-with-result {
    margin-bottom: 10px;
    padding-bottom: 10px;
    border-bottom: 1px dashed #eee;
    &:last-child {
      margin-bottom: 0;
      padding-bottom: 0;
      border-bottom: none;
    }
  }

  .file-info-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 4px;
  }

  .file-name-row {
    display: flex;
    align-items: center;
    gap: 6px;
  }

  .file-doc-icon {
    color: #999;
    flex-shrink: 0;
  }

  .file-name-bold {
    font-size: 13px;
    font-weight: 500;
    color: #4a5568;
  }

  .status-tag {
    font-size: 11px;
    font-weight: bold;
    padding: 2px 8px;
    border-radius: 4px;
    flex-shrink: 0;
    &.success {
      color: #18a058;
      background: #e7f5ee;
    }
    &.error {
      color: #d03050;
      background: #f9e7e9;
    }
  }

  .file-result-text {
    font-size: 12px;
    color: #718096;
    line-height: 1.6;
    margin-left: 22px;
  }

  .empty-text {
    font-size: 13px;
    color: #9ca3af;
    text-align: center;
    padding: 20px 0;
  }

  /* 动画 */
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
