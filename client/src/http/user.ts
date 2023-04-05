import { get, post } from './service';

export const auth = (email: string, password: string) => post('/user/auth',
{
    email: email,
    password: password,
});

export const refresh = (token: string) => post('/user/refresh',
{
    token: token
});

export const register = (fullname: string, email: string, password: string) => post('/user/register',
{
    fullname: fullname,
    email: email,
    password: password,
});

export const confirm = (token: string) => post('/user/confirm',
{
    token: token
});