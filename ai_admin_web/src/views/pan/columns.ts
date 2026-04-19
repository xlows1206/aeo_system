import type {BasicColumn} from '@/components/Table';
import {h, ref} from 'vue'
import {NIcon, NButton} from "naive-ui";
import {FolderOpenOutline, ArchiveOutline} from '@vicons/ionicons5'
import {FileOutlined} from '@vicons/antd'
import { extractProjectName } from '@/utils/index';

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
      // 判断是否为顶级审核项目 (parent_id 为 0 或 字符串 '0')
      const isProject = row.type === 1 && (row.parent_id === 0 || row.parent_id === '0');
      
      return h(NButton, {
        text: true,
        style: {'padding-left': '1px'},
        onClick: () => row.type === 1 ? handleClickFn.value(row) : null
      }, {
        icon: () => h(NIcon, {
          size: 20,
          color: isProject ? '#18a058' : '#D6B164', // 项目使用绿色系标识
          component: row.type === 1 
            ? (isProject ? ArchiveOutline : FolderOpenOutline) 
            : FileOutlined,
        }, {}),
        default: () => h('span', {
          style: {
            'padding-left': '1px', 
            color: '#333',
            'font-weight': isProject ? '600' : 'normal'
          },
        }, (row.type === 1 && isProject) ? extractProjectName(row.name) : row.name),
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
];
