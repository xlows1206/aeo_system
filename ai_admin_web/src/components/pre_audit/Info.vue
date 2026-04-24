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
              <div class="flex items-center justify-between w-full">
                <div class="flex items-center">
                  <span class="text-sm font-bold text-gray-800">
                    {{ extractProjectName(project.folder_name) }}
                  </span>

                </div>
                <!-- 移除了项目列表中的状态标签 -->
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

    <n-modal v-model:show="params.showExample" preset="card" :title="params.exampleTitle" style="width: 800px">
      <n-image width="100%" :src="params.exampleUrl" />
    </n-modal>
  </div>
</template>

<script lang="ts" setup>
  import { reactive, computed, ref } from 'vue';
  import { NDrawer, NDrawerContent, NCollapse, NCollapseItem, NTag, NTimeline, NTimelineItem, NEmpty, NButton, NModal, NImage, NIcon } from 'naive-ui';
  import { apiGetPreAuditLog } from '@/api/system/pre';
  import { extractProjectName } from '@/utils/index';
  import { EyeOutline } from '@vicons/ionicons5';

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
    showExample: false,
    exampleUrl: '',
    exampleTitle: '',
  });

  /**
   * 按文件夹（项目）对文件进行分组，并关联审计结果
   */
  /**
   * 按文件夹对文件进行分组，并关联审计结果
   */
  const groupedProjects = computed(() => {
    const groups: Record<string, any> = {};
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

    params.auditResults.forEach(result => {
      const folderId = result.folder_id;
      if (groups[folderId]) {
        groups[folderId].audit_result = result;
        groups[folderId].check_type = result.check_type;
      } else {
        // 如果没有匹配的文件（可能是因为后端返回的 folder_id 不对应）
        // 也可以创建一个虚拟分组来显示这个审计结果
        const fakeId = `result-${result.folder_id}`;
        groups[fakeId] = {
          folder_id: result.folder_id,
          folder_name: result.folder_name,
          files: [],
          audit_result: result,
          check_type: result.check_type
        };
      }
    });

    return Object.values(groups).sort((a, b) => (typeof a.folder_id === 'number' ? a.folder_id - b.folder_id : 1));
  });

  const getExampleImage = (name: string) => {
      if (name.includes('审计报告')) return '/examples/sample_audit_report.png';
      if (name.includes('合规') || name.includes('守法') || name.includes('惩戒')) return '/examples/sample_compliance.png';
      if (name.includes('资产负债') || name.includes('财务') || name.includes('报告')) return '/examples/sample_balance_sheet.png';
      if (name.includes('无犯罪')) return '/examples/sample_no_criminal.png';
      if (name.includes('货物安全')) return '/examples/sample_cargo_security.png';
      return '';
  };

  const handleViewExample = (e: MouseEvent, project: any) => {
      e.stopPropagation();
      const url = getExampleImage(project.folder_name);
      if (url) {
          params.exampleUrl = url;
          params.exampleTitle = `${extractProjectName(project.folder_name)} - 示例文件`;
          params.showExample = true;
      } else {
          window['$message'].info('暂无该项目的示例图片');
      }
  };

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
:deep(.n-drawer-header__main) {
  color: #d4a017 !important;
  font-weight: 800;
}

.section-title {
  font-size: 14px;
  font-weight: 700;
  color: #333;
  border-left: 4px solid #d4a017;
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
  color: #d4a017;
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
