<template>
  <div class="upload">
    <n-tooltip v-if="disabled" placement="top" trigger="hover">
      <template #trigger>
        <span style="display: inline-block;">
          <n-button
            style="border-radius: 5px !important"
            type="primary"
            :disabled="true"
          >
            <template #icon>
              <n-icon>
                <UploadOutlined/>
              </n-icon>
            </template>
            上传文件
          </n-button>
        </span>
      </template>
      {{ tooltip }}
    </n-tooltip>
    <n-upload v-else multiple :show-file-list="false" :custom-request="customRequest" :accept="accept">
      <n-button
        style="border-radius: 5px !important"
        type="primary">
        <template #icon>
          <n-icon>
            <UploadOutlined/>
          </n-icon>
        </template>
        上传文件
      </n-button>
    </n-upload>
  </div>
</template>

<script lang="ts" setup>
import {reactive} from 'vue';
import {NIcon} from 'naive-ui';
import {UploadOutlined} from '@vicons/antd';
import {createLyla} from '@lylajs/web';

const {lyla} = createLyla({context: null});
import {apiGetUploadToken, apiStoreFile} from '@/api/system/pan';
import {UploadCustomRequestOptions} from 'naive-ui';

const props = defineProps({
  searchParams: {
    type: Object,
    default: () => {
    },
  },
  disabled: {
    type: Boolean,
    default: false,
  },
  tooltip: {
    type: String,
    default: '',
  },
  accept: {
    type: String,
    default: '',
  }
});

const emits = defineEmits(['reload']);

const params = reactive({
  files: [],
  upload: {
    url: '',
    name: '',
    data: {
      policy: '',
      OSSAccessKeyId: '',
      signature: '',
      host: '',
      callback: '',
      key: '',
      success_action_status: 200,
    },
  }
});

const customRequest = async ({
                               file,
                               withCredentials,
                               headers,
                               onFinish,
                               onError,
                               onProgress,
                             }: UploadCustomRequestOptions) => {
  await apiGetUploadToken({
    file_name: file.name,
    type: 'file',
  }).then(async (res) => {
    let postName = file.name;
    let fileSize = file.size;
    let fileName = makeRandomName(file.name, res.random);
    let host = res.config.host.replace('http://', 'https://');
    params.upload.url = host + '?' + res.random;
    params.upload.name = host + res.name;
    params.upload.data.policy = res.config.policy;
    params.upload.data.OSSAccessKeyId = res.config.accessid;
    params.upload.data.signature = res.config.signature;
    params.upload.data.host = host;
    params.upload.data.callback = res.config.callback;
    params.upload.data.key = res.config.dir + fileName;
    const formData = new FormData();
    Object.keys(params.upload.data).forEach((key) => {
      formData.append(key, params.upload.data[key as keyof UploadCustomRequestOptions['data']]);
    });
    formData.append('file', file.file as File);
    let fileUrl = host + res.prefix + fileName
    await lyla
      .post(params.upload.url, {
        withCredentials,
        headers,
        body: formData,
        onUploadProgress: ({percent}) => {
          onProgress({percent: Math.ceil(percent)});
        },
      })
      .then(() => {
        apiStoreFile({
          name: postName,
          url: fileUrl,
          folder_id: props.searchParams.folder_id,
          standard_id: props.searchParams.standard_id,
          size: fileSize,
        }).then(() => {
          emits('reload');
        });
        onFinish();
      })
      .catch((error) => {
        onError();
      });
  });
};


const makeRandomName = (name: string, random: string) => {
  const randomStr = Math.random().toString().substr(2, 4);
  const suffix = name.substr(name.lastIndexOf('.'));
  return Date.now() + randomStr + random + suffix;
};

defineExpose({
  customRequest,
});
</script>

<style scoped lang="less"></style>
