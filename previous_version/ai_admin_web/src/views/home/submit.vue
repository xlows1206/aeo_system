<template>
  <div class="file-download-page">
    <!-- 页面标题 -->
    <div class="page-header">
      <h2>提交AEO认证</h2>
      <p>点击下方操作按钮打开或下载对应文件</p>
    </div>

    <!-- 文件列表卡片 -->
    <div class="file-card-list">
      <div class="file-card" v-for="(file, index) in fileList" :key="index">
        <!-- 文件信息 -->
        <div class="file-info">
          <h3 class="file-title">{{ file.title }}</h3>
<!--          <p class="file-link-desc">新链接：<span class="file-link">{{ file.newUrl }}</span></p>-->
        </div>

        <!-- 操作按钮组 -->
        <div class="file-actions">
          <button
            class="btn download-btn"
            @click="handleDownloadFile(file.newUrl, file.title)"
            type="button"
          >
            下载文件
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import dxbzFile from '@/assets/docs/dxbz.doc'
import tybzFile from '@/assets/docs/tybz.doc'
import smFile from '@/assets/docs/sm.doc'

const fileList = ref([
  {
    title: '《海关高级认证企业标准》（单项标准）',
    newUrl: dxbzFile
  },
  {
    title: '《海关高级认证企业标准》（通用标准）.doc',
    newUrl: tybzFile
  },
  {
    title: '《海关高级认证企业标准》说明.doc',
    newUrl: smFile
  }
]);

/**
 * 下载文件（处理浏览器下载逻辑，支持大多数文件格式）
 * @param {string} url 文件链接
 * @param {string} fileName 下载后的文件名
 */
const handleDownloadFile = (url, fileName) => {
  if (!url) {
    alert('文件链接无效，请检查！');
    return;
  }

  // 方式1：创建a标签实现下载（兼容大部分场景）
  const link = document.createElement('a');
  link.href = url;
  link.download = fileName || '下载文件'; // 自定义下载文件名
  link.target = '_blank';
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
};
</script>

<style scoped>
/* 全局页面样式 */
.file-download-page {
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 20px;
  font-family: "Microsoft YaHei", Arial, sans-serif;
  background-color: #f5f7fa;
  min-height: 100vh;
}

/* 页面头部 */
.page-header {
  text-align: center;
  margin-bottom: 40px;
}

.page-header h2 {
  color: #1f2937;
  font-size: 28px;
  margin-bottom: 12px;
}

.page-header p {
  color: #6b7280;
  font-size: 16px;
}

/* 文件卡片列表 */
.file-card-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(360px, 1fr));
  gap: 24px;
}

/* 单个文件卡片 */
.file-card {
  background-color: #ffffff;
  border-radius: 12px;
  padding: 28px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.file-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
}

/* 文件信息样式 */
.file-info {
  margin-bottom: 24px;
}

.file-title {
  color: #1f2937;
  font-size: 20px;
  margin-bottom: 16px;
  padding-bottom: 12px;
  border-bottom: 1px solid #e5e7eb;
}

.file-link-desc {
  color: #6b7280;
  font-size: 14px;
  line-height: 1.6;
}

.file-link {
  color: #2563eb;
  word-break: break-all;
  font-family: "Consolas", monospace;
}

/* 操作按钮组 */
.file-actions {
  display: flex;
  gap: 16px;
  justify-content: flex-start;
}

/* 按钮通用样式 */
.btn {
  padding: 12px 24px;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 500;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

/* 打开按钮样式 */
.open-btn {
  background-color: #3b82f6;
  color: #ffffff;
}

.open-btn:hover {
  background-color: #2563eb;
}

/* 下载按钮样式 */
.download-btn {
  background-color: #10b981;
  color: #ffffff;
}

.download-btn:hover {
  background-color: #059669;
}

/* 响应式适配（移动端） */
@media (max-width: 768px) {
  .file-card-list {
    grid-template-columns: 1fr;
  }

  .file-actions {
    flex-direction: column;
    gap: 12px;
  }

  .btn {
    width: 100%;
  }
}
</style>
