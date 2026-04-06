import {RouteRecordRaw} from 'vue-router';
import {Layout} from '@/router/constant';
import {Settings} from 'lucide-vue-next';
import {renderIcon} from '@/utils/index';

const routeName = 'system';

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
    path: '/system',
    name: routeName,
    redirect: '/system/index',
    component: Layout,
    meta: {
      title: '系统管理',
      icon: renderIcon(Settings),
      permissions: ['system.index', 'system.company', 'system.permission', 'system.role'],
      sort: 98,
    },
    children: [
      {
        path: 'index',
        name: `${routeName}_index`,
        meta: {
          title: '账号设置',
          permissions: ['system.index'],
          affix: true,
        },
        component: () => import('@/views/system/administrator/index.vue'),
      },
      {
        path: 'company',
        name: `${routeName}_company`,
        meta: {
          title: '公司设置',
          permissions: ['system.company'],
          affix: true,
        },
        component: () => import('@/views/system/company/index.vue'),
      },
      {
        path: 'permission',
        name: `${routeName}_permission`,
        meta: {
          title: '权限设置',
          permissions: ['system.permission'],
          affix: true,
        },
        component: () => import('@/views/system/permission/index.vue'),
      },
      {
        path: 'role',
        name: `${routeName}_role`,
        meta: {
          title: '角色管理',
          permissions: ['system.role'],
          affix: true,
        },
        component: () => import('@/views/system/role/index.vue'),
      }
    ],
  },
];

export default routes;
