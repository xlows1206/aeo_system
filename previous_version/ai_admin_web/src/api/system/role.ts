import {http} from '@/utils/http/axios';

/**
 * @description: 角色列表
 */
export function getRoleList(params) {
  return http.request({
    url: '/v1/role',
    method: 'GET',
    params
  });
}

export function apiStoreRole(params?) {
  return http.request({
    url: '/v1/role',
    method: 'POST',
    params,
  });
}

export function apiUpdateRole(params, id) {
  return http.request({
    url: `/v1/role/${id}`,
    method: 'PUT',
    params,
  });
}

export function apiDeleteRole(id) {
  return http.request({
    url: `/v1/role/${id}`,
    method: 'DELETE',
  });
}

export function getAllRoleList() {
  return http.request({
    url: '/v1/role/all',
    method: 'GET',
  });
}
