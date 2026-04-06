import { http } from '@/utils/http/axios';

/**
 * @description: 角色列表
 */
export function apiGetPan(params?) {
  return http.request({
    url: '/v1/file',
    method: 'GET',
    params
  });
}

export function apiGetStandard() {
  return http.request({
    url: '/v1/file/standard',
    method: 'GET',
  });
}


export function apiStoreFolder(params) {
  return http.request({
    url: '/v1/folder',
    method: 'post',
    params
  });
}

export function apiRenameFolder(params, id) {
  return http.request({
    url: `/v1/folder/${id}/rename`,
    method: 'patch',
    params
  });
}

export function apiGetUploadToken(params) {
  return http.request({
    url: `/v1/upload/getUploadToken`,
    method: 'post',
    params
  });
}

export function apiStoreFile(params) {
  return http.request({
    url: `/v1/file`,
    method: 'post',
    params
  });
}

export function apiCopyFile(id) {
  return http.request({
    url: `/v1/file/${id}/copy`,
    method: 'post',
  });
}

export function apiRenameFile(params, id) {
  return http.request({
    url: `/v1/file/${id}/rename`,
    method: 'patch',
    params
  });
}

export function apiMoveFile(params, id) {
  return http.request({
    url: `/v1/file/${id}/move`,
    method: 'patch',
    params
  });
}

export function apiMoveFolder(params, id) {
  return http.request({
    url: `/v1/folder/${id}/move`,
    method: 'patch',
    params
  });
}

export function apiDeleteFile(id) {
  return http.request({
    url: `/v1/file/${id}`,
    method: 'delete',
  });
}
export function apiDeleteFolder(id) {
  return http.request({
    url: `/v1/folder/${id}`,
    method: 'delete',
  });
}

export function apiGetFolderLists() {
  return http.request({
    url: `/v1/folder/lists`,
    method: 'get',
  });
}

export function apiGetFileById(params) {
  return http.request({
    url: `/v1/file/getFileById`,
    method: 'post',
    params
  });
}

export function apiGetAllStandard(params?) {
  return http.request({
    url: `/v1/file/allStandard`,
    method: 'get',
    params
  });
}
