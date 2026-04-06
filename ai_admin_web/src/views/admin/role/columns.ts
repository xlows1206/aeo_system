import { BasicColumn } from '@/components/Table';
export interface ListData {
  name: string;
  note: string;
  updated_at: string;
  permissions: string;
}
export const columns: BasicColumn<ListData>[] = [
  {
    title: '角色名称',
    key: 'name',
    width: 80,
  },
  {
    title: '角色备注',
    key: 'note',
    width: 100,
  },
  {
    title: '更新时间',
    key: 'updated_at',
    width: 100,
  }
];
