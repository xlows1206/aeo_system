<template>
  <div class="main">
    <n-drawer v-model:show="params.active" :width="600" placement="right">
      <n-drawer-content :title="props.drawerParams.title">
        <n-scrollbar x-scrollable style="height: 38px" id="scrollbar" ref="scrollbarRef">
          <div style="padding: 5px">
            <n-steps
              :current="params.current"
              :status="params.currentStatus"
              size="small"
              @update:current="changeCurrent"
            >
              <n-step
                v-for="(item, index) in params.preLists"
                :key="index"
                :id="`step-${index + 1}`"
                :title="item.name"
              />
            </n-steps>
          </div>
        </n-scrollbar>

        <div v-for="(item, index) in params.preLists">
          <component
            v-if="params.current - 1 === index"
            class="page-item"
            @next="nextCurrent"
            :maxPre="params.preLists.length"
            :currentData="props.drawerParams.data"
            :currentPreIndex="params.current"
            :currentPre="item"
            :is="componentMapper[item.component]"
          />
        </div>
      </n-drawer-content>
    </n-drawer>

    <n-modal v-model:show="params.showModal" preset="dialog" title="Dialog">
      <template #header>
        <div>审核结果</div>
      </template>
      <div>
        <n-input v-model:value="params.result" type="textarea" placeholder="请输入不达标原因" />
      </div>
      <template #action>
        <div>
          <n-button type="primary" @click="goNext">确认</n-button>
        </div>
      </template>
    </n-modal>
  </div>
</template>

<script lang="ts" setup>
  import { reactive, ref } from 'vue';
  import componentMapper from '@/components/audit/sub/componentMapper';
  import { apiCustomsAudit } from '@/api/system/audit';

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

  const emits = defineEmits(['reloadTable']);

  const formRef = ref(null);
  const params = reactive({
    active: false,
    currentStatus: 'process',
    current: 1,
    preLists: [],
    currentPreIndex: 0,
    perData: {},
    showModal: false,
    result: '',
    status: 0,
  });

  const scrollbarRef: any = ref(null);

  const changeCurrent = (index: number) => {
    params.current = index;
    const scroll =
      document.getElementById(`step-${index}`)?.offsetLeft -
      document.getElementById(`scrollbar`)?.offsetLeft;
    scrollbarRef.value.scrollTo(scroll);
  };

  const nextCurrent = (data: any) => {
    params.perData[params.current - 1] = {
      data: data.data,
      score: data.currentPre.score,
      result: data.currentPre.result,
      customsResult: data.customsResult,
      type: data.currentPre.type,
      name: data.currentPre.name,
      id: data.currentPre.id,
      component: data.currentPre.component,
    };
    console.log(params.perData);

    let score = 0;
    // 每次提交，需要检查是否不符合
    for (let item of params.perData) {
      if (item.customsResult === 1) {
        params.showModal = true;
        params.status = 1;
        return;
      }

      if (item.customsResult === 2) {
        score = score + 1;
      }

      if (score >= 5) {
        params.showModal = true;
        params.status = 1;
        return;
      }
    }

    if (data.currentPreIndex >= params.preLists.length) {
      params.status = 3;
      for (let item of params.perData) {
        if (!item.customsResult || item.customsResult === 0) {
          window['$message'].error('请完成所有项目的审核');
          return;
        }
      }
      goNext();
    } else {
      changeCurrent(++data.currentPreIndex);
    }
  };

  const goNext = () => {
    if (params.status === 1 && !params.result) {
      window['$message'].error('请输入审核失败原因');
      return;
    }
    apiCustomsAudit(
      {
        info: params.perData,
        result: params.result,
        status: params.status,
      },
      props.drawerParams.data.id
    )
      .then(() => {
        emits('reloadTable');
        window['$message'].success('操作成功');
        params.result = '';
        params.status = 0;
        params.showModal = false;
      })
      .catch((err) => {
        window['$message'].error(err.message);
      });
  };

  const openDrawer = () => {
    params.active = true;
    params.preLists = props.drawerParams.data.info || [];
    params.perData = props.drawerParams.data.info || [];
  };

  const closeDrawer = () => {
    params.active = false;
  };

  defineExpose({
    openDrawer,
    closeDrawer,
  });
</script>

<style scoped lang="less"></style>
