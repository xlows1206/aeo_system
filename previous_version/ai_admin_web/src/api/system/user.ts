import { http } from '@/utils/http/axios';

export interface BasicResponseModel<T = any> {
  code: number;
  message: string;
  result: T;
}

export interface BasicPageParams {
  pageNumber: number;
  pageSize: number;
  total: number;
}

/**
 * @description: 获取用户信息
 */
export function getUserInfo() {
  return http.request({
    url: '/v1/user/info',
    method: 'get',
  });
}

/**
 * @description: 用户登录
 */
export function login(params) {
  return http.request<BasicResponseModel>(
    {
      url: '/v1/user/auth/login',
      method: 'POST',
      params,
    },
    {
      isTransformResponse: false,
    }
  );
}

export function apiGetMaster() {
  return http.request({
    url: '/v1/user/allMaster',
    method: 'get',
  });
}

/**
 * @description: 用户修改密码
 */
export function changePassword(params, uid) {
  return http.request(
    {
      url: `/user/u${uid}/changepw`,
      method: 'POST',
      params,
    },
    {
      isTransformResponse: false,
    }
  );
}

/**
 * @description: 用户登出
 */
export function logout(params) {
  return http.request({
    url: '/login/logout',
    method: 'POST',
    params,
  });
}

export function apiUpdateAdminInfo(params) {
  return http.request({
    url: '/v1/admin/administrator/updatePassword',
    method: 'PUT',
    params,
  });
}

