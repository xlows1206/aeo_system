import { http } from '@/utils/http/axios';

//获取table
export function apiRegisterUser(params) {
  return http.request({
    url: '/v1/user/auth/register',
    method: 'post',
    params,
  });
}

export function apiStoreUser(params) {
  return http.request({
    url: '/v1/user',
    method: 'post',
    params,
  });
}

export function apiUpdateUser(id, params) {
  return http.request({
    url: `/v1/user/${id}`,
    method: 'put',
    params,
  });
}

export function apiDestroyUser(id) {
  return http.request({
    url: `/v1/user/${id}`,
    method: 'delete',
  });
}

export function apiResetPassword(id) {
  return http.request({
    url: `/v1/user/${id}/resetPassword`,
    method: 'patch',
  });
}
