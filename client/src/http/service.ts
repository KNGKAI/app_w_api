import axios from 'axios';

const instance = axios.create({
  baseURL: 'http://localhost:5000/api',
});

export const post = (url: string, data: any) => {
  return instance.post(url, data);
};

export const get = (url: string) => {
  return instance.get(url);
}