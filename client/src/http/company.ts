import { get, post } from './service';

export const createCompany = (name: string, description: string) => post('/company/create', {
    name: name,
    description: description
});

export const updateCompany = (id: string, name: string, description: string) => post('/company/update', {
    id: id,
    name: name,
    description: description
});

export const createRole = (company: string, name: string, description: string) => post('/company/createRole', {
    company: company,
    name: name,
    description: description
});

export const updateRole = (id: string, name: string, description: string) => post('/company/updateRole', {
    id: id,
    name: name,
    description: description
});

export const removeRole = (id: string) => post('/company/removeRole', {
    id: id
});

export const createTrade = (company: string, name: string, description: string) => post('/company/createTrade', {   
    company: company,
    name: name,
    description: description
});

export const updateTrade = (id: string, name: string, description: string) => post('/company/updateTrade', {
    id: id,
    name: name,
    description: description
});

export const removeTrade = (id: string) => post('/company/removeTrade', {
    id: id
});

