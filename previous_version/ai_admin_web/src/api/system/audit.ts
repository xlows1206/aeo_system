import { http } from '@/utils/http/axios';


export function apiPreAudit(params) {
  return http.request({
    url: '/v1/audit',
    method: 'GET',
    params
  });
}

export function apiRevocationAudit(id) {
  return http.request({
    url: `/v1/audit/${id}/revocation`,
    method: 'patch',
  });
}

export function apiCustomsAudit(params, id) {
  return http.request({
    url: `/v1/audit/${id}`,
    method: 'put',
    params
  });
}

export function apiGetAuditLog(id) {
  return http.request({
    url: `/v1/audit/${id}/log`,
    method: 'GET',
  });
}



