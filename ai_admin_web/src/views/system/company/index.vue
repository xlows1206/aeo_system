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
       <n-form-item path="company_types" label="业务类型">
           <n-select v-model:value="params.data.company_types" multiple :options="params.options" />
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
import {ref, reactive} from 'vue';
import {apiGetCompanyInfo, apiStoreCompany, apiGetTypes} from '@/api/system/company';

const formRef = ref(null);

const params = reactive({
  loading: false,
  data: {
    company_name: '',
    enterprise_person_name: '',
    principal_person_name: '',
    financial_person_name: '',
    customs_person_name: '',
    company_types: []
  },
  options: [],
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
      apiStoreCompany(params.data)
        .then(() => {
          window['$message'].success('操作成功');
          params.loading = false;
        })
        .catch((err) => {
          window['$message'].error(err.message);
          params.loading = false;
        });
    } else {
      params.loading = false;
    }
  });
};

apiGetTypes().then((res) => {
  params.options = res;
})

apiGetCompanyInfo().then((res) => {
  params.data.company_name = res.data.company_name;
  params.data.enterprise_person_name = res.data.enterprise_person_name;
  params.data.principal_person_name = res.data.principal_person_name;
  params.data.financial_person_name = res.data.financial_person_name;
  params.data.customs_person_name = res.data.customs_person_name;
  params.data.company_types = res.data.company_types;
});
</script>

<style scoped lang="less">
.setting {
  display: flex;
}
</style>
