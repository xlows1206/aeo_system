<template>
  <main class="flex-1 p-8">
    <div class="mb-10">
      <h1 class="text-3xl font-bold text-amber-900 mb-3">欢迎回来，管理员</h1>
      <p class="text-amber-700 text-lg">
        今天是
        {{
          new Date().toLocaleDateString("zh-CN", {
            year: "numeric",
            month: "long",
            day: "numeric",
            weekday: "long",
          })
        }}
      </p>
    </div>

    <div class="grid grid-cols-1 xl:grid-cols-3 gap-8">
      <div class="xl:col-span-2" style="border-right: 1px solid #F9EBA9;
      background: #ffffff;border-top-left-radius: 10px;border-bottom-left-radius: 10px;">
        <div
          class="bg-white/90 backdrop-blur-sm border-amber-200 shadow-xl rounded-xl overflow-hidden h-full">
          <div class="pb-6 bg-gradient-to-r from-amber-50 to-orange-50 border-b border-amber-100">
            <div class="flex items-center gap-3 text-amber-900 text-4xl mb-3 font-semibold"
                 style="padding:20px">
              <div class="p-2 bg-gradient-to-br from-amber-400 to-orange-500 rounded-lg"
                   style="padding:2px;">
                <n-icon size="30" color="#fff">
                  <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
                       viewBox="0 -5 32 32">
                    <path
                      d="M26 4h-4V2h-2v2h-8V2h-2v2H6c-1.1 0-2 .9-2 2v20c0 1.1.9 2 2 2h20c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 22H6V12h20v14zm0-16H6V6h4v2h2V6h8v2h2V6h4v4z"
                      fill="currentColor"></path>
                  </svg>
                </n-icon>
              </div>
              海关政策导引
            </div>
          </div>
          <div class="p-6">
            <div class="space-y-5">
              <div
                v-for="news in params.newsData"
                :key=news.id
                class="group border-l-4 border-amber-400 pl-5 py-4 hover:bg-gradient-to-r hover:from-amber-50/50 hover:to-orange-50/50 transition-all duration-200 cursor-pointer rounded-r-lg"
                @click="articleDetail(news)"
              >
                <div class="flex items-start justify-between">
                  <div class="flex-1">
                    <h3
                      class="text-xl font-semibold text-amber-900 mb-2 group-hover:text-amber-800 transition-colors">
                      {{ news.title }}
                    </h3>
                    <p class="text-amber-700 mb-3 line-clamp-2 leading-relaxed">
                      {{ news.summary }}</p>
                    <div class="flex items-center gap-4 text-sm text-amber-600">
                              <span class="flex items-center gap-1">
                                     <n-icon size="15">
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
     viewBox="0 0 24 24"><g fill="none"><path
  d="M12 2c5.523 0 10 4.478 10 10s-4.477 10-10 10S2 17.522 2 12S6.477 2 12 2zm0 1.667c-4.595 0-8.333 3.738-8.333 8.333c0 4.595 3.738 8.333 8.333 8.333c4.595 0 8.333-3.738 8.333-8.333c0-4.595-3.738-8.333-8.333-8.333zM11.25 6a.75.75 0 0 1 .743.648L12 6.75V12h3.25a.75.75 0 0 1 .102 1.493l-.102.007h-4a.75.75 0 0 1-.743-.648l-.007-.102v-6a.75.75 0 0 1 .75-.75z"
  fill="currentColor"></path></g></svg>
                                     </n-icon>
                                {{ news.date }}
                              </span>
                      <span
                        class="px-3 py-1 bg-amber-100 text-amber-800 rounded-full text-xs font-medium">
                                {{ news.category }}
                              </span>
                    </div>
                  </div>
                  <n-icon size="25"
                          class="h-5 w-5 text-amber-400 ml-4 flex-shrink-0 group-hover:text-amber-600 transition-colors">
                    <svg xmlns="http://www.w3.org/2000/svg"
                         xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 12 12">
                      <g fill="none">
                        <path
                          d="M1.5 6a.5.5 0 0 1 .5-.5h6.793L6.146 2.854a.5.5 0 1 1 .708-.708l3.5 3.5a.5.5 0 0 1 0 .708l-3.5 3.5a.5.5 0 0 1-.708-.708L8.793 6.5H2a.5.5 0 0 1-.5-.5z"
                          fill="currentColor"></path>
                      </g>
                    </svg>
                  </n-icon>
                  <div
                    class="h-5 w-5 text-amber-400 ml-4 flex-shrink-0 group-hover:text-amber-600 transition-colors"/>
                </div>
              </div>
            </div>
            <div class="mt-8 text-center" v-show="params.showMore">
              <Button
                class="border-amber-300 text-amber-700 hover:bg-amber-50 bg-transparent px-8 py-2 rounded-lg font-medium"
                style="border: 1px solid #F9EBA9;"
                @click="loadMore"
              >
                查看更多新闻
              </Button>
            </div>
          </div>
        </div>
      </div>

      <n-modal v-model:show="params.showArticleDetail">
        <n-card
          style="width: 1000px"
          :title="params.currentArticle.title"
          :bordered="false"
          size="huge"
          role="dialog"
          aria-modal="true"
        >
          <template #header-extra>
          </template>
            <pre style="white-space: pre-wrap; word-wrap: break-word;">
            {{ params.currentArticle.summary }}
            </pre>
          <template #footer>
            {{ params.currentArticle.date }}
          </template>
        </n-card>
      </n-modal>

      <div class="space-y-8">
        <div class="bg-gradient-to-br from-amber-100 to-orange-100 border-amber-300 shadow-lg"
             style="border-right: 1px solid #F9EBA9;
      background: #ffffff;border-top-left-radius: 10px;border-bottom-left-radius: 10px;">
          <div class="p-6">
            <div class="text-center space-y-4">
              <div
                class="w-16 h-16 bg-gradient-to-br from-amber-400 to-orange-500 rounded-full flex items-center justify-center mx-auto">
                <n-icon size="40" color="#fff">
                  <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
                       viewBox="0 0 16 16">
                    <g fill="none">
                      <path
                        d="M7.647 2.146a.5.5 0 0 1 .708 0C9.595 3.39 10.969 4 12.5 4a.5.5 0 0 1 .5.5v3.001c0 3.219-1.641 5.407-4.842 6.473a.499.499 0 0 1-.316 0C4.642 12.908 3 10.72 3 7.501V4.5a.5.5 0 0 1 .5-.5c1.53 0 2.904-.611 4.147-1.854zM8 3.19C6.814 4.255 5.48 4.87 4 4.981v2.52c0 1.434.363 2.564 1.021 3.444c.638.852 1.609 1.543 2.979 2.027c1.37-.483 2.341-1.175 2.979-2.027c.658-.88 1.021-2.01 1.021-3.444v-2.52c-1.48-.112-2.815-.726-4-1.792z"
                        fill="currentColor"></path>
                    </g>
                  </svg>
                </n-icon>
              </div>
              <div>
                <h3 class="text-xl font-bold text-amber-900 mb-2">AEO认证标准</h3>
                <p class="text-sm text-amber-700 mb-4">
                  查看最新的AEO认证标准要求，了解申请流程和注意事项</p>
              </div>
              <Button
                @click="openSubmitFile"
                class="w-full bg-gradient-to-r from-amber-500 to-orange-600 hover:from-amber-600 hover:to-orange-700 text-white py-3 text-base font-medium  rounded-lg">
                <n-icon class="mr-2 h-5 w-5" size="20" color="#fff">
                  <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
                       viewBox="0 -2 24 24">
                    <g fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                       stroke-linejoin="round">
                      <path d="M14 3v4a1 1 0 0 0 1 1h4"></path>
                      <path
                        d="M17 21H7a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h7l5 5v11a2 2 0 0 1-2 2z"></path>
                      <path d="M9 15l2 2l4-4"></path>
                    </g>
                  </svg>
                </n-icon>
                提交AEO认证
              </Button>
            </div>
          </div>
        </div>
        <div
          class="bg-white/90 backdrop-blur-sm border-amber-200 shadow-xl rounded-xl overflow-hidden"
          style="border-right: 1px solid #F9EBA9;
      background: #ffffff;border-top-left-radius: 10px;border-bottom-left-radius: 10px;">
          <div class="pb-6 bg-gradient-to-r from-amber-50 to-orange-50 border-b border-amber-100"
               style="padding:20px;">
            <div class="flex items-center justify-between">
              <div class="flex items-center gap-3 text-amber-900 text-4xl mb-3 font-semibold">
                <div class="p-2 bg-gradient-to-br from-amber-400 to-orange-500 rounded-lg">
                  <n-icon size="30" color="#fff">
                    <svg version="1.1" xmlns="http://www.w3.org/2000/svg"
                         xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
                         viewBox="0 -5 512 512" enable-background="new 0 0 512 512"
                         xml:space="preserve"><path d="M464.9,128H344.1c-8.3,0-15.1,6.6-15.1,14.8s6.8,14.8,15.1,14.8h83.7l-138,142.2l-85.9-84.1c-2.9-2.8-6.6-4.3-10.7-4.3
	c-4,0-7.8,1.5-10.7,4.3L36.2,358.8c-1.9,1.9-4.2,5.2-4.2,10.7c0,4.1,1.4,7.5,4.2,10.2c2.9,2.8,6.6,4.3,10.7,4.3
	c4,0,7.8-1.5,10.7-4.3l135.6-132.7l85.9,84.1c2.9,2.8,6.6,4.3,10.7,4.3c4,0,7.8-1.5,10.7-4.3l149.4-151.9v81.7
	c0,8.1,6.8,14.8,15.1,14.8c8.3,0,15.1-6.6,15.1-14.8V142.8C480,134.6,473.2,128,464.9,128z"></path></svg>
                  </n-icon>
                </div>
                资料提交进度
              </div>
              <div class="text-right">
                <div class="text-3xl font-bold text-amber-900 ">{{params.totalRate.percentage}} %</div>
                <div class="text-sm text-amber-600 text-xl">总体完成度</div>
              </div>
            </div>
          </div>
          <div class="p-6">
            <div class="space-y-5">
              <div v-for="item in params.documentProgress" :key=index class="space-y-3">
                <div class="flex items-center justify-between">
                  <span class="text-amber-800 font-medium">{{ item.name }}</span>
                  <span class="text-sm text-amber-600 font-medium">
                            {{ item.completed }}/{{ item.total }} ({{ item.percentage }}%)

                          </span>
                </div>
                <div class="relative">
                  <n-progress
                    type="line"
                    :percentage="item.percentage"
                    indicator-placement="inside"
                    :color="{ stops: ['#f59e0b', '#ea580c'] }"
                    processing
                  />
                </div>
              </div>
            </div>
            <div class="mt-8 flex gap-3">

              <Button
                class="w-full bg-gradient-to-r from-amber-400 to-orange-500 hover:from-amber-500 hover:to-orange-600 text-white rounded-lg font-medium" @click="jumpUpload">
                <n-icon size="18" color="#fff">
                  <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
                       viewBox="-1 -1 24 24">
                    <g fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                       stroke-linejoin="round">
                      <path d="M4 17v2a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-2"></path>
                      <path d="M7 9l5-5l5 5"></path>
                      <path d="M12 4v12"></path>
                    </g>
                  </svg>
                </n-icon>

                去处理/上传
              </Button>
              <Button
                class="border-amber-300 text-amber-700 hover:bg-amber-50 bg-transparent px-3 rounded-lg font-medium"
                style="border: 1px solid #F9EBA9;width: 150px;padding-top: 10px;padding-bottom: 10px;"
                @click="showInfo"
              >
                查看详情
              </Button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <v-home-submit
      ref="homeSubmitRef"
    ></v-home-submit>
  </main>

</template>

<script lang="ts" setup>
import {ref, h, reactive} from 'vue';
import {apiGetArticles, apiAccessRate} from '@/api/system/home'
import {useRouter} from "vue-router";
import VHomeSubmit from '@/components/home/Submit.vue';

const router = useRouter();

const homeSubmitRef: any = ref(null);
const formRef: any = ref(null);
const actionRef: any = ref(null);
const auditInfoRef: any = ref(null);
const auditAuditInfoRef: any = ref(null);

const params = reactive({
  newsData: [],
  page: 1,
  showMore: true,
  documentProgress: [

  ],
  totalRate: {
    percentage : 0,
    completed:0,
    total : 0,
    name : '总计'
  },
  currentArticle: {},
  showArticleDetail: false
});

const loadMore = () => {
  params.page++
  loadArticles(params.page)
}
const loadArticles = (page) => {
  apiGetArticles({page: page}).then(res => {
    if (res.list.length > 0) {
      res.list.forEach((item) => {
        params.newsData.push({
          id: item.id,
          title: item.title,
          summary: item.content,
          date: item.updated_at,
          category: item.cate_name,
        });
      })
    } else {
      window['$message'].success('没有更多了');
      params.showMore = false
    }
  })
  console.log(params)
}

const loadRate = () => {
  apiAccessRate().then(res => {
    params.documentProgress = res.standard_rates
    params.totalRate = res.all_rate
  })
}

const openSubmitFile = () => {
  window.open('/submit/file', '_blank')
  // homeSubmitRef.value.openDrawer();
}
const articleDetail = (article) => {
  params.currentArticle = {}
  params.currentArticle = article
  params.showArticleDetail = true
}

const jumpUpload = () => {
  router.replace('/pan/index')
}

const showInfo = () => {
  router.replace('/pre_audit/index')
}

loadArticles(params.page)
loadRate()
// 模拟新闻数据

</script>

<style lang="less" scoped>
.progress-indicator {
  background: linear-gradient(90deg, #f59e0b 0%, #ea580c 100%);
}
</style>
