import { http } from '@/utils/http/axios';

/**
 * @description: 角色列表
 */
export function apiGetFileLists(params) {
  return http.request({
    url: '/v1/file/lists',
    method: 'GET',
    params
  });
}

export function apiGetPreAuditLog(id) {
  return http.request({
    url: `/v1/pre_audit/${id}/log`,
    method: 'GET',
  });
}

export function apiGetPreAudit(params) {
  return http.request({
    url: '/v1/pre_audit',
    method: 'GET',
    params
  });
}

export function apiStorePreAudit(params) {
  return http.request({
    url: '/v1/pre_audit',
    method: 'POST',
    params
  });
}

export function apiUpdatePreAudit(params, id) {
  return http.request({
    url: `/v1/pre_audit/${id}`,
    method: 'PUT',
    params
  });
}

export function apiStoreSubmitAudit(id) {
  return http.request({
    url: `/v1/pre_audit/${id}/submitAudit`,
    method: 'POST',
  });
}

