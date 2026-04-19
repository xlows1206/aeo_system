<template>
  <div class="p-5">
   <div class="bg-white p-5 rounded-md shadow-md custom-header-main">
     <n-form
       ref="formRef"
       :model="params.data"
       :rules="params.rules"
       style="width: 500px"
       label-placement="left"
       label-align="left"
       label-width="auto"
     >
       <n-form-item path="company_name" label="公司名称">
         <n-input v-model:value="params.data.company_name"/>
       </n-form-item>
       <n-form-item path="enterprise_person_name" label="企业法定代表人">
         <n-input v-model:value="params.data.enterprise_person_name"/>
       </n-form-item>
       <n-form-item path="principal_person_name" label="主要负责人">
         <n-input v-model:value="params.data.principal_person_name"/>
       </n-form-item>
       <n-form-item path="financial_person_name" label="财务负责人">
         <n-input v-model:value="params.data.financial_person_name"/>
       </n-form-item>
       <n-form-item path="customs_person_name" label="关务负责人">
         <n-input v-model:value="params.data.customs_person_name"/>
       </n-form-item>
         <n-form-item path="company_types" label="业务主体性质">
             <n-select v-model:value="params.data.company_types" multiple :options="params.options" @update:value="handleTypeChange" />
         </n-form-item>
          <n-form-item path="bind_projects" label="绑定检测项目">
              <div class="flex flex-col gap-4 w-full">
                  <div v-if="filteredProjectCategories.length === 0" class="text-gray-400 italic">请先选择业务主体性质</div>
                  <div v-for="category in filteredProjectCategories" :key="category.name" class="p-4 border rounded-md bg-gray-50 mb-2">
                      <div class="font-bold mb-2 text-primary border-b pb-1" style="color: #18a058; border-bottom: 1px solid #18a05833;">{{ category.name }}</div>
                      <n-checkbox-group v-model:value="params.data.bind_projects">
                          <n-space item-style="display: flex;">
                              <n-checkbox v-for="option in category.options" :key="option.value" :value="option.value" :label="option.label" />
                          </n-space>
                      </n-checkbox-group>
                  </div>
                  <div v-if="filteredProjectCategories.length > 0" class="text-gray-400 text-xs">根据业务性质自动推荐显示相关大类，可手动勾选调整</div>
              </div>
          </n-form-item>
        <n-form-item label="审计开始年份">
           <n-select
              v-model:value="params.data.start_year"
              :options="params.yearOptions"
              placeholder="请选择"
            />
        </n-form-item>
        <n-form-item label="审计结束年份">
           <n-select
              v-model:value="params.data.end_year"
              :options="params.yearOptions"
              placeholder="请选择"
            />
        </n-form-item>
        <n-form-item label="报关单数量">
            <n-input-number 
               v-model:value="params.data.not_self_total" 
               class="w-full"
               :min="0"
               placeholder="请输入报关单总数" 
            />
        </n-form-item>
       <n-button
         style="width: 500px"
         :loading="params.loading"
         type="primary"
         @click="handleSubmit"
       >
         确认
       </n-button>
     </n-form>
   </div>
  </div>
</template>

<script lang="ts" setup>
import {ref, reactive, onMounted, computed} from 'vue';
import {apiGetCompanyInfo, apiStoreCompany, apiGetTypes, apiUpdateCompanyDurationYear, apiSaveCompanyNotSelfTotal} from '@/api/system/company';
import {http} from '@/utils/http/axios';

const formRef = ref(null);

const params = reactive({
  loading: false,
  data: {
    company_name: '',
    enterprise_person_name: '',
    principal_person_name: '',
    financial_person_name: '',
    customs_person_name: '',
    company_types: [] as number[],
    bind_projects: [] as number[],
    start_year: null,
    end_year: null,
    not_self_total: 0,
  },
  options: [] as any[],
  projectOptions: [] as any[],
  projectCategories: [] as any[],
  yearOptions: [] as any[],
  rules: {
    company_name: [{required: true, message: '请输入公司名称'}],
    enterprise_person_name: [{required: true, message: '请输入企业法定代表人'}],
    principal_person_name: [{required: true, message: '请输入主要负责人'}],
    financial_person_name: [{required: true, message: '请输入财务负责人'}],
    customs_person_name: [{required: true, message: '请输入关系负责人'}],
  },
});

const handleSubmit = (e) => {
  params.loading = true;
  e.preventDefault();
  formRef.value?.validate((errors) => {
    if (!errors) {
      Promise.all([
        apiStoreCompany(params.data),
        apiUpdateCompanyDurationYear({
          start_year: params.data.start_year,
          end_year: params.data.end_year,
          duration_year: (params.data.end_year && params.data.start_year) ? (params.data.end_year - params.data.start_year + 1) : null,
        }),
        apiSaveCompanyNotSelfTotal({
          not_self_total: params.data.not_self_total,
        })
      ])
        .then(() => {
          window['$message'].success('操作成功');
          params.loading = false;
        })
        .catch((err) => {
          window['$message'].error(err.message || '保存失败');
          params.loading = false;
        });
    } else {
      params.loading = false;
    }
  });
};

const filteredProjectCategories = computed(() => {
  if (params.data.company_types.length === 0) return [];
  
  // 获取当前选中的所有业务类型推荐的项目 ID 并集
  const activeProjectIds = new Set<number>();
  params.data.company_types.forEach(val => {
    const type = params.options.find(opt => opt.value === val);
    if (type && type.bind_projects) {
      type.bind_projects.forEach((pId: number) => activeProjectIds.add(pId));
    }
  });

  // 过滤分类：只要该分类下有任何一个项目在 activeProjectIds 中，就显示该大类
  return params.projectCategories.filter(category => {
      // 提取该分类标识，如 "一"
      return category.options.some((opt: any) => activeProjectIds.has(opt.value));
  });
});

const handleTypeChange = (values: number[]) => {
  const recommendedProjects = new Set<number>();
  values.forEach(val => {
    const type = params.options.find(opt => opt.value === val);
    if (type && type.bind_projects) {
      type.bind_projects.forEach((pId: number) => recommendedProjects.add(pId));
    }
  });
  // 切换类型时，重新设置绑定的项目为当前选中类型的并集
  params.data.bind_projects = Array.from(recommendedProjects);
};

onMounted(async () => {
  // 获取业务类型并包含绑定项目信息
  const typeRes = await apiGetTypes();
  params.options = typeRes;

  // 获取所有可选的检测项目 (standard_id=6)
  const projectRes = await http.request({
    url: '/v1/file/projects/all?standard_id=6',
    method: 'GET'
  });
  params.projectOptions = projectRes.list.map((item: any) => ({
    label: item.name,
    value: Number(item.id.toString().replace('f', '')), // 强制转为数字
    parentName: item.name.split(' ')[0].split('-')[0]
  }));

  // 按父级大类分组
  const categories: Record<string, any[]> = {};
  const parentMap: Record<string, string> = {
      '一': '一、加工贸易以及保税进出口业务',
      '二': '二、卫生检疫业务',
      '三': '三、动植物检疫业务',
      '五': '五、进出口商品检验业务',
      '六': '六、代理报关业务',
      '八': '八、物流运输业务'
  };

  projectRes.list.forEach((item: any) => {
    let categoryKey = '';
    const name = item.name;
    if (name.startsWith('一')) categoryKey = '一';
    else if (name.startsWith('二')) categoryKey = '二';
    else if (name.startsWith('三')) categoryKey = '三';
    else if (name.startsWith('五')) categoryKey = '五';
    else if (name.startsWith('六')) categoryKey = '六';
    else if (name.startsWith('八')) categoryKey = '八';
    
    const groupName = parentMap[categoryKey] || '其他业务';
    
    if (!categories[groupName]) categories[groupName] = [];
    categories[groupName].push({
        label: item.name,
        value: Number(item.id.toString().replace('f', ''))
    });
  });

  params.projectCategories = Object.keys(categories).map(key => ({
      name: key,
      options: categories[key]
  })).sort((a, b) => {
      const order = ['一', '二', '三', '五', '六', '八'];
      const charA = Object.keys(parentMap).find(k => parentMap[k] === a.name) || '其';
      const charB = Object.keys(parentMap).find(k => parentMap[k] === b.name) || '其';
      return (order.indexOf(charA) === -1 ? 99 : order.indexOf(charA)) - 
             (order.indexOf(charB) === -1 ? 99 : order.indexOf(charB));
  });

  generateYearOptions();

  const res = await apiGetCompanyInfo();
  params.data.company_name = res.data.company_name;
  params.data.enterprise_person_name = res.data.enterprise_person_name;
  params.data.principal_person_name = res.data.principal_person_name;
  params.data.financial_person_name = res.data.financial_person_name;
  params.data.customs_person_name = res.data.customs_person_name;
  params.data.company_types = res.data.company_types || [];
  params.data.bind_projects = res.data.bind_projects || [];
  params.data.start_year = res.data.start_year;
  params.data.end_year = res.data.end_year;
  params.data.not_self_total = res.data.not_self_total;
});
</script>

<style scoped lang="less">
.setting {
  display: flex;
}
</style>
