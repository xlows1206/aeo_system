import { BasicColumn } from '@/components/Table';
import { h, ref } from "vue";
import { NTag } from "naive-ui";
export interface ListData {
  name: string;
  note: string;
  updated_at: string;
  permissions: string;
}
export const columns: BasicColumn<ListData>[] = [
  {
    title: '标题',
    key: 'title',
    width: 80,
  },
  {
    title: '内容',
    key: 'content',
    width: 200,
  },
  {
    title: '更新时间',
    key: 'updated_at',
    width: 50,
  },
];
