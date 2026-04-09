<template>
  <div class="main">
    <n-drawer v-model:show="params.active" :width="502" placement="right">
      <n-drawer-content
        closable
        :title="props.drawerParams.title">
        <n-form
          ref="formRef"
          :model="params.data"
          :rules="standing === 1 ? params.rules : params.rulesStandards"
          label-placement="left"
          label-width="auto"
          require-mark-placement="right-hanging"
          :style="{
            maxWidth: '640px',
          }"
        >
          <n-form-item label="名称" path="name">
            <n-input v-model:value="params.data.name" placeholder="" />
          </n-form-item>
          <n-form-item label="备注" path="path">
            <n-input v-model:value="params.data.note" placeholder="" />
          </n-form-item>
          <n-form-item label="权限列表" path="permission">
            <n-tree
              :cascade="params.cascade"
              checkable
              default-expand-all
              block-line
              :default-checked-keys="params.defaultCheckedKeys"
              @update:checked-keys="updateCheckedKeys"
              :data="params.permissions"
              :selectable="false"
            />
          </n-form-item>
<!--          <n-form-item label="资料列表" path="standard" v-if="standing > 1">-->
<!--            <n-tree-->
<!--              :cascade="params.cascade"-->
<!--              checkable-->
<!--              default-expand-all-->
<!--              block-line-->
<!--              :default-checked-keys="params.defaultStandardCheckedKeys"-->
<!--              @update:checked-keys="updateCheckedStandardKeys"-->
<!--              :data="params.standards"-->
<!--              :selectable="false"-->
<!--            />-->
<!--          </n-form-item>-->
          <n-form-item>
            <n-button
              type="primary"
              @click="handleSubmit"
              size="large"
              :loading="params.loading"
              block
            >
              保存
            </n-button>
          </n-form-item>
        </n-form>
      </n-drawer-content>
    </n-drawer>
  </div>
</template>

<script lang="ts" setup>
  import { h, reactive, ref } from 'vue';
  import { getMenuList } from '@/api/system/menu';
  import { apiStoreRole, apiUpdateRole } from '@/api/system/role';
  import { NButton } from 'naive-ui';
  import { apiGetAllStandard } from '@/api/system/pan';
  import { useUserStore } from '@/store/modules/user';
  const userStore = useUserStore();
  const standing = userStore.getUserInfo.standing;

  const props = defineProps({
    drawerParams: {
      type: Object,
    },
  });

  const emits = defineEmits(['reload']);

  const formRef = ref(null);
  const params = reactive({
    defaultCheckedKeys: [],
    defaultStandardCheckedKeys: [],
    editId: 0,
    loading: false,
    cascade: true,
    active: false,
    rules: {
      name: [{ required: true, message: '名称不能为空' }],
      permission: [{ required: true, message: '权限不能为空' }],
    },
    rulesStandards: {
      name: [{ required: true, message: '名称不能为空' }],
      permission: [{ required: true, message: '权限不能为空' }],
      // standard: [{ required: true, message: '资料列表不能为空' }],
    },
    permissions: [],
    // standards: [],
    data: {
      name: '',
      note: '',
      permission: [],
      // standard: [],
    },
  });

  const handleSubmit = (e) => {
    params.loading = true;
    e.preventDefault();
    formRef.value?.validate((errors) => {
      if (!errors) {
        if (props.drawerParams.type === 'add') {
          apiStoreRole({
            name: params.data.name,
            note: params.data.note,
            permissions: params.data.permission,
            // standards: params.data.standard,
          })
            .then(() => {
              emits('reload');
              window['$message'].success('操作成功');
            })
            .catch((err) => {
              window['$message'].error(err.message);
            });
        } else {
          apiUpdateRole(
            {
              name: params.data.name,
              note: params.data.note,
              permissions: params.data.permission,
              // standards: params.data.standard,
            },
            params.editId
          )
            .then(() => {
              emits('reload');
            })
            .catch((err) => {
              window['$message'].error(err.message);
            });
        }
        params.loading = false;
      } else {
        params.loading = false;
      }
    });
  };

  const openDrawer = () => {
    // params.cascade = false
    if (props.drawerParams.type === 'add') {
      params.defaultCheckedKeys = [];
      params.defaultStandardCheckedKeys = [];
      params.editId = 0;
      params.data = {
        name: '',
        note: '',
        permission: [],
        // standard: [],
      };
    }
    if (props.drawerParams.type === 'edit') {
      params.editId = props.drawerParams.data.id;
      params.defaultCheckedKeys = props.drawerParams.data.permissionsIds;
      params.defaultStandardCheckedKeys = props.drawerParams.data.standardsIds;
      params.data = {
        name: props.drawerParams.data.name,
        note: props.drawerParams.data.note,
        permission: props.drawerParams.data.permissionsIds,
        // standard: props.drawerParams.data.standardsIds,
      };
    }
    getPermissions();
    // getStandard();
    params.active = true;
  };

  const closeDrawer = () => {
    params.active = false;
  };

  const getPermissions = () => {
    params.permissions = [];
    getMenuList().then((res) => {
      params.permissions = createData(res);
    });
  };

  const getStandard = () => {
    params.standards = [];
    apiGetAllStandard().then((res) => {
      params.standards = createData(res);
    });
  };
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
      };
    } else {
      return {
        label,
        key,
      };
    }
  };

  const updateCheckedKeys = (data: any) => {
    // params.cascade = true
    params.data.permission = data;
  };

  const updateCheckedStandardKeys = (data: any) => {
    console.log(data);
    // params.cascade = true
    params.data.standard = data;
  };

  defineExpose({
    openDrawer,
    closeDrawer,
  });
</script>

<style scoped lang="less"></style>
