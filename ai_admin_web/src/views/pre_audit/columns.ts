import { BasicColumn } from '@/components/Table';
import { h, ref } from "vue";
import { NTag } from "naive-ui";
export interface ListData {
  name: string;
  note: string;
  updated_at: string;
  permissions: string;
}
const STATUS_CN = ref(['正在审核', '不合格', '', '合格']);
const STATUS_TYPE = ref(['default', 'error' ,'warning', 'success']);
export const columns: BasicColumn<ListData>[] = [
  {
    title: '提交人',
    key: 'userName',
    width: 80,
  },
  {
    title: '提交时间',
    key: 'updated_at',
    width: 100,
  },
  {
    title: '预审次数',
    key: 'number',
    width: 50,
  },
  {
    title: '预审结果',
    key: 'status',
    width: 100,
    render(row) {
      return h(
        NTag,
        {
          round: true,
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
