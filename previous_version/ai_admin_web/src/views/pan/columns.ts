import type {BasicColumn} from '@/components/Table';
import {h, ref} from 'vue'
import {NIcon, NButton} from "naive-ui";
import {FolderOpenOutline} from '@vicons/ionicons5'
import {FileOutlined} from '@vicons/antd'

export interface ListData {
  name: string;
  updated_at: string;
  size: string;
}

const handleClickFn: any = ref(null)
export const getFn = ({handleClick}) => {
  handleClickFn.value = handleClick
}

export const columns: BasicColumn<ListData>[] = [
  {
    title: '文件名',
    key: 'name',
    width: 150,
    render(row) {
      return h(NButton, {
        text: true,
        style: {'padding-left': '1px'},
        onClick: () => row.type === 1 ? handleClickFn.value(row) : null
      }, {
        icon: () => h(NIcon, {
          size: 20,
          component: row.type === 1 ? FolderOpenOutline : FileOutlined,
        }, {}),
        default: () => h('span', {
          style: {'padding-left': '1px', color: '#333'},
        }, row.name),
      });
    },
  },
  {
    title: '修改时间',
    key: 'updated_at',
    width: 100,
    render(row) {
      return h('span', {
        // style: {color: '#D6B164'},
      }, row.updated_at);
    }
  },
  // {
  //   title: '大小',
  //   key: 'size',
  //   width: 100,
  //   // auth: ['basic_list'], // 同时根据权限控制是否显示
  //   // ifShow: (_column) => {
  //   //   return true; // 根据业务控制是否显示
  //   // },
  // }
];
