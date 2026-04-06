import { RouteRecordRaw } from 'vue-router';
import { Layout } from '@/router/constant';
import { FileText } from 'lucide-vue-next';
import { renderIcon } from '@/utils/index';

const routeName = 'pan';

/**
 * @param name 路由名称, 必须设置,且不能重名
 * @param meta 路由元信息（路由附带扩展信息）
 * @param redirect 重定向地址, 访问这个路由时,自定进行重定向
 * @param meta.disabled 禁用整个菜单
 * @param meta.title 菜单名称
 * @param meta.icon 菜单图标
 * @param meta.keepAlive 缓存该路由
 * @param meta.sort 排序越小越排前
 * */
const routes: Array<RouteRecordRaw> = [
  {
    path: '/pan',
    name: routeName,
    redirect: '/pan/index',
    component: Layout,
    meta: {
      title: '资料管理',
      icon: renderIcon(FileText),
      permissions: ['pan.index'],
      sort: 3,
    },
    children: [
      {
        path: 'index',
        name: `${routeName}_index`,
        meta: {
          title: '资料管理',
          permissions: ['pan.index'],
          affix: true,
        },
        component: () => import('@/views/pan/index.vue'),
      },
    ],
  },
];

export default routes;
