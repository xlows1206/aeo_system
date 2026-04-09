import { http } from '@/utils/http/axios';

/**
 * @description: 文章列表
 */
export function apiGetArticles(params) {
  return http.request({
    url: '/v1/index/article',
    method: 'GET',
    params
  });
}

export function apiAccessRate() {
  return http.request({
    url: '/v1/index/access_rate',
    method: 'GET'
  });
}


export function apiStoreArticle(params) {
  return http.request({
    url: '/v1/admin/article',
    method: 'POST',
    params
  });
}

export function apiUpdateArticle(params,id) {
  return http.request({
    url: '/v1/admin/article/'+id,
    method: 'PUT',
    params
  });
}

export function apiDeleteArticle(id) {
  return http.request({
    url: '/v1/admin/article/'+id,
    method: 'DELETE',
  });
}

export function apiGetCategories() {
  return http.request({
    url: '/v1/admin/article/getCategories',
    method: 'GET'
  });
}

export function apiCreateCategory(params) {
  return http.request({
    url: '/v1/admin/article/createCategory',
    method: 'POST',
    params
  });
}

export function apiDeleteCategory(id) {
  return http.request({
    url: '/v1/admin/article/delCategory/'+id,
    method: 'DELETE',
  });
}
