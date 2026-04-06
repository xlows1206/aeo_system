import {RouteRecordRaw} from 'vue-router';
import {Layout} from '@/router/constant';
import {Settings} from 'lucide-vue-next';
import {renderIcon} from '@/utils/index';

const routeName = 'admin';

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
    path: '/admin',
    name: routeName,
    redirect: '/admin/article',
    component: Layout,
    meta: {
      title: '后台管理',
      icon: renderIcon(Settings),
      permissions: ['admin'],
      sort: 99,
    },
    children: [
      {
        path: 'article',
        name: `${routeName}_article`,
        meta: {
          title: '文章管理',
          permissions: ['admin.article'],
          affix: true
        },
        component: () => import('@/views/admin/article/index.vue'),
      },
      {
        path: 'category',
        name: `${routeName}_category`,
        meta: {
          title: '文章分类管理',
          permissions: ['admin.category'],
          affix: true
        },
        component: () => import('@/views/admin/category/index.vue'),
      }
    ],
  },
];

export default routes;
