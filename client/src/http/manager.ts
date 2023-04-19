import { get, post } from './service';

export const createSite = (company: string, name: string, description: string, address: string) => post('/manager/createSite', {
    company: company,
    name: name,
    description: description,
    address: address,
});

export const updateSite = (id: string, name: string, description: string, address: string) => post('/manager/updateSite', {
    id: id,
    name: name,
    description: description,
    address: address,
});

export const removeSite = (id: string) => post('/manager/removeSite', {
    id: id
});

export const createTask = (label: string, description: string, priority: number, site: string, trade: string, assigned: string, start: number, end: number) => post('/manager/createTask', {
    label: label,
    description: description,
    priority: priority,
    site: site,
    trade: trade,
    assigned: assigned,
    start: start,
    end: end,
});

export const updateTask = (id: string, label: string, description: string, priority: number, site: string, trade: string, assigned: string, start: number, end: number) => post('/manager/updateTask', {
    id: id,
    label: label,
    description: description,
    priority: priority,
    site: site,
    trade: trade,
    assigned: assigned,
    start: start,
    end: end,
});
