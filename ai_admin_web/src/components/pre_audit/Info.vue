<template>
  <div class="main">
    <n-drawer v-model:show="params.active" :width="680" placement="right">
      <n-drawer-content :title="props.drawerParams.title" :native-scrollbar="false">

        <!-- 审核项目列表 (替换原有的审核文件列表与检查项明细) -->
        <div class="section-title">审核项目列表</div>
        <n-collapse :default-expanded-names="[]" accordion arrow-placement="right">
          <n-collapse-item
            v-for="(project, index) in groupedProjects"
            :key="project.folder_id"
            :name="project.folder_id"
            class="project-collapse-item"
          >
            <template #header>
              <div class="project-header">
                <span class="project-num">{{ index + 1 }}.</span>
                <span class="project-title">{{ extractProjectName(project.folder_name) }}</span>
                <div class="project-badges">
                  <n-tag v-if="project.audit_result" :type="project.audit_result.is_access == 1 ? 'success' : 'error'" size="small" round>
                    {{ project.audit_result.is_access == 1 ? '合格' : '不合格' }}
                  </n-tag>
                </div>
              </div>
            </template>
            
            <div class="project-content">
              <!-- 文件列表 -->
              <div class="sub-section-inner-title">关联文件</div>
              <div class="file-list">
                <div v-for="(file, fi) in project.files" :key="fi" class="file-item">
                  <span class="file-dot">•</span>
                  <span class="file-name">{{ file.name }}</span>
                </div>
                <div v-if="project.files.length === 0" class="empty-text">无关联文件</div>
              </div>

              <!-- 审计详情 (如果存在) -->
              <div v-if="project.audit_result && project.audit_result.details.length > 0" class="audit-details-section">
                <div class="sub-section-inner-title">审核详情</div>
                <div class="details-list">
                  <div v-for="(detail, di) in project.audit_result.details" :key="di" class="detail-line">
                    <span class="detail-idx">{{ di + 1 }}.</span>
                    <span class="detail-text">{{ detail }}</span>
                  </div>
                </div>
              </div>
            </div>
          </n-collapse-item>
        </n-collapse>

        <n-empty v-if="groupedProjects.length === 0" description="暂无审核项目数据" style="margin-top: 40px" />

        <!-- 提交历史时间线 -->
        <div class="section-title" style="margin-top:30px">提交历史</div>
        <n-timeline>
          <n-timeline-item
            v-for="(item, index) in params.lists"
            :key="index"
            :type="params.status_type[item.status]"
            :title="params.status_cn[item.status]"
            :time="item.created_at"
          >
            <template #default>
              <div v-html="item.ai_result" class="ai-result-html"></div>
            </template>
          </n-timeline-item>
        </n-timeline>

      </n-drawer-content>
    </n-drawer>
  </div>
</template>

<script lang="ts" setup>
  import { reactive, computed } from 'vue';
  import { NDrawer, NDrawerContent, NCollapse, NCollapseItem, NTag, NTimeline, NTimelineItem, NEmpty } from 'naive-ui';
  import { apiGetPreAuditLog } from '@/api/system/pre';
  import { extractProjectName } from '@/utils/index';

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
    status_cn: ['正在审核', '不合格', '', '合格'],
    status_type: ['default', 'error', 'warning', 'success'],
  });

  /**
   * 按文件夹（项目）对文件进行分组，并关联审计结果
   */
  const groupedProjects = computed(() => {
    const groups: Record<string, any> = {};
    
    // 1. 先按文件夹 ID 分组文件
    params.files.forEach(file => {
      const folderId = file.folder_id || 0;
      if (!groups[folderId]) {
        groups[folderId] = {
          folder_id: folderId,
          folder_name: file.folder_name || '未归类项目',
          files: [],
          audit_result: null
        };
      }
      groups[folderId].files.push(file);
    });

    // 2. 关联审计结果
    params.auditResults.forEach(result => {
      // 通过 folder_name 或 check_id 匹配。通常 folder_name 是唯一的项目标识
      // 先寻找名称一致的组
      const group = Object.values(groups).find(g => g.folder_name === result.folder_name);
      if (group) {
        group.audit_result = result;
      } else {
        // 如果没找到对应的文件组（可能只审计了文件夹但没上传文件，或者名称匹配不上）
        // 这里创建一个空的组展示结果
        const fakeId = `result-${result.folder_name}`;
        groups[fakeId] = {
          folder_id: fakeId,
          folder_name: result.folder_name,
          files: [],
          audit_result: result
        };
      }
    });

    return Object.values(groups).sort((a, b) => (typeof a.folder_id === 'number' ? a.folder_id - b.folder_id : 1));
  });

  const openDrawer = () => {
    params.active = true;
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
  };

  defineExpose({
    openDrawer,
    closeDrawer,
  });
</script>

<script lang="ts">
export default {
  name: 'VPreAuditInfo'
}
</script>

<style scoped lang="less">
.section-title {
  font-size: 14px;
  font-weight: 700;
  color: #333;
  border-left: 4px solid #18a058;
  padding-left: 10px;
  margin-bottom: 16px;
  letter-spacing: 0.5px;
}

.project-collapse-item {
  margin-bottom: 10px;
  border: 1px solid #f0f0f0;
  border-radius: 8px;
  overflow: hidden;
  transition: all 0.2s;

  &:hover {
    border-color: #d9f7be;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
  }

  :deep(.n-collapse-item__header) {
    padding: 12px 16px !important;
    background: #fdfdfd;
  }
}

.project-header {
  display: flex;
  align-items: center;
  gap: 10px;
  width: 100%;
}

.project-num {
  font-weight: 500;
  color: #999;
  font-size: 13px;
}

.project-title {
  flex: 1;
  font-weight: 600;
  color: #444;
  font-size: 14px;
}

.project-badges {
  margin-right: 8px;
}

.project-content {
  padding: 12px 16px 16px 36px;
  background: #fff;
  border-top: 1px dashed #f0f0f0;
}

.sub-section-inner-title {
  font-size: 12px;
  font-weight: 600;
  color: #888;
  margin-bottom: 8px;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.file-list {
  margin-bottom: 16px;
}

.file-item {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 4px 0;
  font-size: 13px;
  color: #666;
}

.file-dot {
  color: #18a058;
}

.empty-text {
  font-size: 12px;
  color: #bbb;
  font-style: italic;
}

.audit-details-section {
  padding-top: 12px;
  border-top: 1px solid #f5f5f5;
}

.details-list {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.detail-line {
  display: flex;
  gap: 8px;
  font-size: 13px;
  line-height: 1.6;
}

.detail-idx {
  font-weight: 600;
  color: #fa8c16;
}

.detail-text {
  color: #555;
}

.ai-result-html {
  font-size: 13px;
  color: #666;
  line-height: 1.8;
  padding-top: 4px;
}
</style>
