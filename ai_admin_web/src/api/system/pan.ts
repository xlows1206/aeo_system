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


export function apiStoreFolder(data) {
  return http.request({
    url: '/v1/folder',
    method: 'post',
    data
  });
}

export function apiRenameFolder(data, id) {
  return http.request({
    url: `/v1/folder/${id}/rename`,
    method: 'patch',
    data
  });
}

export function apiGetUploadToken(data) {
  return http.request({
    url: `/v1/upload/getUploadToken`,
    method: 'post',
    data
  });
}

export function apiStoreFile(data) {
  return http.request({
    url: `/v1/file`,
    method: 'post',
    data
  });
}

export function apiCopyFile(id) {
  return http.request({
    url: `/v1/file/${id}/copy`,
    method: 'post',
  });
}

export function apiRenameFile(data, id) {
  return http.request({
    url: `/v1/file/${id}/rename`,
    method: 'patch',
    data
  });
}

export function apiMoveFile(data, id) {
  return http.request({
    url: `/v1/file/${id}/move`,
    method: 'patch',
    data
  });
}

export function apiMoveFolder(data, id) {
  return http.request({
    url: `/v1/folder/${id}/move`,
    method: 'patch',
    data
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

export function apiGetFolderLists(params?) {
  return http.request({
    url: `/v1/folder/lists`,
    method: 'get',
    params
  });
}

export function apiGetFileById(data) {
  return http.request({
    url: `/v1/file/getFileById`,
    method: 'post',
    data
  });
}

export function apiGetAllStandard(params?) {
  return http.request({
    url: `/v1/file/allStandard`,
    method: 'get',
    params
  });
}

export function apiGetAllProjects(params) {
  return http.request({
    url: `/v1/file/projects/all`,
    method: 'get',
    params
  });
}

export function apiDownloadPassedPackage(params) {
  return http.request({
    url: `/v1/file/downloadPassedPackage`,
    method: 'get',
    params,
    responseType: 'blob'
  });
}
