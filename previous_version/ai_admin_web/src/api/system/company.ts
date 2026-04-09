import { http } from '@/utils/http/axios';

/**
 * @description: 角色列表
 */
export function apiGetCompanyInfo() {
  return http.request({
    url: '/v1/company/info',
    method: 'GET',
  });
}
export function apiStoreCompany(params?) {
  return http.request({
    url: '/v1/company',
    method: 'POST',
    params,
  });
}

export function apiUpdateCompanyDurationYear(params?) {
  return http.request({
    url: '/v1/company/durationYear',
    method: 'PUT',
    params,
  });
}

export function apiSaveCompanyNotSelfTotal(params?) {
  return http.request({
    url: '/v1/company/notSelfTotal',
    method: 'PUT',
    params,
  });
}

export function apiCheckCompany() {
  return http.request({
    url: '/v1/company/checkCompany',
    method: 'GET',
  });
}

export function apiGetTypes() {
  return http.request({
    url: '/v1/company/types',
    method: 'GET',
  });
}
