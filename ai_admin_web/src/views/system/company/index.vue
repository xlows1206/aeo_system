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
              <div class="flex flex-col gap-2 w-full">
                  <div v-if="filteredProjectCategories.length === 0" class="text-gray-400 italic">请先选择业务主体性质</div>
                  <div v-for="category in filteredProjectCategories" :key="category.name" class="p-3 border rounded-md bg-amber-50/20 mb-1">
                      <div class="font-bold text-primary" style="color: #18a058;">{{ category.name }}</div>
                  </div>
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
    company_types: [] as string[],
    bind_projects: [] as string[],
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
      // 整合所有字段通过单一接口保存，彻底解决并发引起的竞态覆盖问题
      const submitData = {
          ...params.data,
          duration_year: (params.data.end_year && params.data.start_year) ? (params.data.end_year - params.data.start_year + 1) : null,
      };

      apiStoreCompany(submitData)
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
  const activeProjectIds = new Set<string>();
  params.data.company_types.forEach(val => {
    const type = params.options.find(opt => String(opt.value) === String(val));
    if (type && type.bind_projects) {
      type.bind_projects.forEach((pId: string) => activeProjectIds.add(String(pId)));
    }
  });

  // 过滤分类：只要该分类下有任何一个项目在 activeProjectIds 中，就显示该大类
  return params.projectCategories.filter(category => {
      return category.options.some((opt: any) => activeProjectIds.has(String(opt.value)));
  });
});

const handleTypeChange = (values: string[]) => {
  const recommendedProjects = new Set<string>();
  values.forEach(val => {
    const type = params.options.find(opt => String(opt.value) === String(val));
    if (type && type.bind_projects) {
      type.bind_projects.forEach((pId: string) => recommendedProjects.add(String(pId)));
    }
  });
  // 切换类型时，重新设置绑定的项目为当前选中类型的并集
  params.data.bind_projects = Array.from(recommendedProjects);
};

const generateYearOptions = () => {
    const currentYear = new Date().getFullYear();
    const years = [];
    for (let i = 0; i < 10; i++) {
        years.push({ label: (currentYear - i).toString(), value: currentYear - i });
    }
    params.yearOptions = years;
};

onMounted(async () => {
  // 1. 获取业务类型并包含绑定项目信息 (这些项目 ID 是 fcf_id)
  const typeRes = await apiGetTypes();
  params.options = Array.isArray(typeRes) ? typeRes : (typeRes.data || typeRes.list || []);

  // 2. 获取所有可选的检测项目 (standard_id=6)
  // 新增 ignore_bind=1 参数，确保即便后端已保存了过滤状态，这里也能拿全量数据字典
  const projectRes = await http.request({
    url: '/v1/file/projects/all?standard_id=6&ignore_bind=1',
    method: 'GET'
  });
  
  // 3. 构建 projectOptions，使用 fcf_id 作为 value
  params.projectOptions = projectRes.list.map((item: any) => ({
    label: item.name,
    value: String(item.fcf_id), 
    parentName: item.name.split(' ')[0].split('-')[0]
  }));

  // 4. 按父级大类分组
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
    // 匹配逻辑：
    // 1. 尝试匹配格式如 "八-20" 开头的名称
    // 2. 尝试匹配格式如 "八、物流运输业务 - 八-20" 中的 "八-20"
    const match = name.match(/([一二三四五六七八九十]+)[-、]/);
    if (match) {
        categoryKey = match[1];
    }
    
    const groupName = parentMap[categoryKey] || '单项标准通用项';
    
    if (!categories[groupName]) categories[groupName] = [];
    categories[groupName].push({
        label: item.name,
        value: String(item.fcf_id)
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

  // 5. 获取公司已有的信息
  const res = await apiGetCompanyInfo();
  params.data.company_name = res.data.company_name;
  params.data.enterprise_person_name = res.data.enterprise_person_name;
  params.data.principal_person_name = res.data.principal_person_name;
  params.data.financial_person_name = res.data.financial_person_name;
  params.data.customs_person_name = res.data.customs_person_name;
  
  // 显式转换为字符串，确信 ID 类型一致
  params.data.company_types = (res.data.company_types || []).filter((id:any) => id !== '' && id !== null).map((id: any) => String(id));
  params.data.bind_projects = (res.data.bind_projects || []).filter((id:any) => id !== '' && id !== null).map((id: any) => String(id));
  
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