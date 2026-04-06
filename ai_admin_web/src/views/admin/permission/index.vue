<template>
  <div class="p-5">
    <div class="bg-white p-5 rounded-md shadow-md custom-header-main">
      <div class="tree">
        <n-tree default-expand-all block-line :data="data" :selectable="false"/>
      </div>
    </div>

    <drawer ref="drawerRef" :drawerParams="drawerParams" @reload="reload"></drawer>
  </div>
</template>

<script lang="ts" setup>
import {ref, reactive, h} from 'vue';
import {NButton} from 'naive-ui';
import Drawer from '@/components/role/Drawer.vue';
import {apiDeleteMenu, getMenuList} from '@/api/system/menu';

const drawerRef: any = ref(null);

const params = reactive({});
const createData = (data) => {
  let temp = [];
  for (let item of data) {
    temp.push(createReturn(item));
  }
  return temp;
};

const createReturn = (item: any) => {
  let label = item.name;
  let key = item.id;
  if (item.children && item.children.length > 0) {
    return {
      label,
      key,
      children: createData(item.children),
      suffix: () => [
        h(
          NButton,
          {
            text: true,
            type: 'warning',
            style: {color: '#7AA5E1'},
            onClick: () => addItem(item),
          },
          {default: () => '新增'}
        ),
        h(
          NButton,
          {
            text: true,
            type: 'warning',
            onClick: () => removeItem(item),
            style: {
              marginLeft: '15px',
              color: '#7AA5E1',
              display: item.id === 0 ? 'none' : 'block',
            },
          },
          {
            default: () => '删除',
          }
        ),
        h(
          NButton,
          {
            text: true,
            type: 'warning',
            onClick: () => editItem(item),
            style: {
              marginLeft: '15px',
              color: '#7AA5E1',
              display: item.id === 0 ? 'none' : 'block',
            },
          },
          {
            default: () => '编辑',
          }
        ),
      ],
    };
  } else {
    return {
      label,
      key,
      suffix: () => [
        h(
          NButton,
          {
            text: true,
            type: 'warning',
            style: {color: '#7AA5E1'},
            onClick: () => addItem(item),
          },
          {default: () => '新增'}
        ),
        h(
          NButton,
          {
            text: true,
            type: 'warning',
            onClick: () => removeItem(item),
            style: {
              marginLeft: '15px',
              color: '#7AA5E1'
            },
          },
          {
            default: () => '删除',
          }
        ),
        h(
          NButton,
          {
            text: true,
            type: 'warning',
            onClick: () => editItem(item),
            style: {
              marginLeft: '15px',
              color: '#7AA5E1'
            },
          },
          {
            default: () => '编辑',
          }
        ),
      ],
    };
  }
};

const data = ref();

const reload = () => {
  data.value = [];
  getMenuList().then((res) => {
    data.value = createData(res);
  });
  if (drawerRef.value) {
    drawerRef.value.closeDrawer();
  }
};
reload();

const drawerParams = reactive({
  title: '',
  data: {},
  type: 0,
});
const addItem = (data: any) => {
  drawerParams.title = '新增';
  drawerParams.data = data;
  drawerParams.type = 1;
  drawerRef.value.openDrawer();
};
const removeItem = (data: any) => {
  window['$dialog'].info({
    title: '提示',
    content: `确定删除 ${data.name} ？`,
    positiveText: '确定',
    negativeText: '取消',
    onPositiveClick: () => {
      apiDeleteMenu(data.id)
        .then(() => {
          reload();
          window['$message'].success('删除成功');
        })
        .catch((err) => {
          window['$message'].error(err.message);
        });
    },
    onNegativeClick: () => {
    },
  });
};
const editItem = (data: any) => {
  drawerParams.title = '编辑';
  drawerParams.data = data;
  drawerParams.type = 2;
  drawerRef.value.openDrawer();
};
</script>

<style scoped lang="less">

</style>
