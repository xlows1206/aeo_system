import { http } from '@/utils/http/axios';

/**
 * @description: 根据用户id获取用户菜单
 */
export function adminMenus() {
  return http.request({
    url: '/menus',
    method: 'GET',
  });
}

/**
 * 获取tree菜单列表
 * @param params
 */
export function getMenuList(params?) {
  return http.request({
    url: '/v1/menu/list',
    method: 'GET',
    params,
  });
}

export function apiStoreMenu(params?) {
  return http.request({
    url: '/v1/menu',
    method: 'POST',
    params,
  });
}

export function apiUpdateMenu(params, id) {
  return http.request({
    url: `/v1/menu/${id}`,
    method: 'PUT',
    params,
  });
}

export function apiDeleteMenu(id) {
  return http.request({
    url: `/v1/menu/${id}`,
    method: 'DELETE',
  });
}
