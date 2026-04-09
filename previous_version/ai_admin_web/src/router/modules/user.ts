import { RouteRecordRaw } from 'vue-router';
import { Layout } from '@/router/constant';
import { renderIcon } from '@/utils/index';

import { Users } from 'lucide-vue-next';

const routeName = 'user';

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
    path: '/user',
    name: routeName,
    redirect: '/user/index',
    component: Layout,
    meta: {
      title: '用户管理',
      icon: renderIcon(Users),
      permissions: ['user.index'],
      sort: 2,
    },
    children: [
      {
        path: 'index',
        name: `${routeName}_index`,
        meta: {
          title: '用户列表',
          permissions: ['user.index'],
          affix: true,
        },
        component: () => import('@/views/user/lists/index.vue'),
      },
    ],
  },
];

export default routes;
