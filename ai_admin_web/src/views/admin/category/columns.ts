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
    title: '分类id',
    key: 'id',
    width: 80,
  },
  {
    title: '分类名称',
    key: 'name',
    width: 200,
  },
  {
    title: '创建时间',
    key: 'updated_at',
    width: 50,
  },
];
