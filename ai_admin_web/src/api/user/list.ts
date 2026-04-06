import { http } from '@/utils/http/axios';

//获取table
export function getTableList(params) {
  return http.request({
    url: '/v1/user',
    method: 'get',
    params,
  });
}

export function apiSendMail(params?) {
  return http.request({
    url: '/v1/tool/sendMail',
    method: 'post',
    params,
  });
}

export function apiForgotPassword(params?) {
  return http.request({
    url: '/v1/user/auth/forgotPassword',
    method: 'post',
    params,
  });
}
