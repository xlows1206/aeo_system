import { BasicColumn } from '@/components/Table';
import { h, ref } from "vue";
import { NTag } from "naive-ui";
export interface ListData {
  name: string;
  note: string;
  updated_at: string;
  permissions: string;
}
const STATUS_CN = ref(['正在审核', '不达标', '基本达标', '达标', '撤销']);
const STATUS_TYPE = ref(['default', 'error' ,'warning', 'success', 'default']);
export const columns: BasicColumn<ListData>[] = [
  {
    title: '公司名称',
    key: 'companyName',
    width: 100,
  },
  {
    title: '公司类型',
    key: 'enterprise',
    width: 100,
  },
  {
    title: '提交时间',
    key: 'created_at',
    width: 100,
  },
  {
    title: '预审结果',
    key: 'status',
    width: 100,
    render(row) {
      return h(
        NTag,
        {
          // @ts-ignore
          type: STATUS_TYPE.value[row.status],
        },
        {
          // @ts-ignore
          default: () => STATUS_CN.value[row.status],
        }
      );
    },
  }
];
