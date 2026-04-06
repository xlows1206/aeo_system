import { BasicColumn } from '@/components/Table';
export interface ListData {
  username: string;
  mobile: string;
  note: string;
  standing: string;
  role: string;
  login_at: string;
  created_at: string;
}
export const columns: BasicColumn<ListData>[] = [
  {
    title: '用户名',
    key: 'username',
    width: 100,
  },
  {
    title: '公司名称',
    key: 'company',
    width: 100,
  },
  {
    title: '主账号',
    key: 'master',
    width: 100,
  },
  {
    title: '备注',
    key: 'note',
    width: 100,
  },
  {
    title: '账号类型',
    key: 'standingName',
    width: 100,
  },
  {
    title: '审核标准',
    key: 'enterpriseName',
    width: 100,
  },
  {
    title: '角色',
    key: 'role_name',
    width: 100,
  },
  {
    title: '最近登录时间',
    key: 'login_at',
    width: 160,
  },
  {
    title: '注册日期',
    key: 'created_at',
    width: 160,
  },
];
