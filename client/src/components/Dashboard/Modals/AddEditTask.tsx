import { useEffect, useState } from 'react';
import { useQuery, gql } from '@apollo/client';
import {
    TextField,
    Box,
    Button,
    Typography
 } from '@mui/material';
import BasicMenu from '../../BasicMenu/BasicMenu';

const prorities = [
    { value: 0, label: 'Low' },
    { value: 1, label: 'Medium' },
    { value: 2, label: 'High' },
    { value: 3, label: 'Critical' },
];

const statuses = [
    { value: 0, label: 'Open' },
    { value: 1, label: 'In Progress' },
    { value: 2, label: 'Closed' },
];

const QUERY = (id: string) => gql`
{
    user(id: "642d609010d2137bac321233") {
        id
        username
        company {
            id
            name
            sites {
                id
                name
            }
            trades {
                id
                name
            }
            users {
                id
                username
                trades {
                    id
                    name
                }
            }
        }
    }
    task(id: "${id}") {
        id
        label
        description
        status
        priority
        site {
            id
            name
        }
        trade {
            id
            name
        }
        assigned {
            id
            username
        }
        start
        end
    }
}
`;

const QUERY_STATIC = () => gql`
{
    user(id: "642d609010d2137bac321233") {
        id
        username
        company {
            id
            name
            sites {
                id
                name
            }
            trades {
                id
                name
            }
            users {
                id
                username
                trades {
                    id
                    name
                }
            }
        }
    }
}
`;

function AddEditTask({ id, onConfirm, onClose } : { id: string | null, onConfirm: any, onClose: any }) {
    const [task, setTask] = useState({ 
        id: '',
        label: '',
        description: '',
        status: 0,
        priority: 0,
        site: {
            id: '',
            name: ''
        },
        trade: {
            id: '',
            name: ''
        },
        assigned: {
            id: '',
            username: ''
        },
        start: new Date().getTime(),
        end: new Date().getTime()
    });

    const [sites, setSites] = useState([] as any[]);
    const [trades, setTrades] = useState([] as any[]);
    const [users, setUsers] = useState([] as any[]);

    const { loading, error, data } = id ? useQuery(QUERY(id || "")) : useQuery(QUERY_STATIC());

    useEffect(() => { }, [task, sites, trades, users]);

    if (loading) return (<p>Loading...</p>);
    if (error) return (<p>Error : {error.message}</p>);
    if (data) {
        if (id && !task.id) {
            setTask({ 
                id: data.task.id || '',
                label: data.task.label,
                description: data.task.description,
                status: data.task.status,
                priority: data.task.priority,
                site: {
                    id: data.task.site.id,
                    name: data.task.site.name
                },
                trade: {
                    id: data.task.trade?.id || '',
                    name: data.task.trade?.name || ''
                },
                assigned: {
                    id: data.task.assigned?.id || '',
                    username: data.task.assigned?.username || ''    
                },
                start: data.task.start,
                end: data.task.end
            });
        }

        if (sites.length === 0) {
            setSites(data.user.company.sites.map((s: any) => ({
                id: s.id,
                name: s.name
            })));
        }

        if (trades.length === 0) {
            setTrades(data.user.company.trades.map((t: any) => ({
                id: t.id,
                name: t.name
            })));
        }
        
        if (users.length === 0) {
            setUsers(data.user.company.users.map((u: any) => ({
                id: u.id,
                username: u.username,
                trades: u.trades !== null ? u.trades.map((t: any) => ({
                    id: t.id,
                    name: t.name
                })) : []
            })));
        }
    }

    console.log(task);
    console.log(sites);
    console.log(trades);
    console.log(users);

    return (
        <div>
            <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
                {id ? "Update Task" : "Add Task"}
            </Typography>

            <TextField
                id="label"
                label="Label"
                value={task.label}
                variant="standard"
                fullWidth
                onChange={(e) => setTask({ ...task, label: e.target.value })}
            />
            <TextField
                id="description"
                label="Description"
                value={task.description}
                variant="standard"
                fullWidth
                onChange={(e) => setTask({ ...task, description: e.target.value })}
            />

            <BasicMenu
                id="priority"
                label="Priority"
                value={task.priority}
                options={prorities}
                onChange={(value: any) => setTask({ ...task, priority: value })}
            />

            <BasicMenu
                id="site"
                label="Site"
                value={task.site.id}
                options={[
                    { value: '', label: 'None' },
                    ...sites.map((s: any) => ({ value: s.id, label: s.name }))
                ]}
                onChange={(value: any) => setTask({ ...task, site: sites.find((s: any) => s.id === value) || { id: '', name: '' } })}
            />

            <BasicMenu
                id="trade"
                label="Trade"
                value={task.trade.id}
                options={[
                    { value: '', label: 'None' },
                    ...trades.map((t: any) => ({ value: t.id, label: t.name }))
                ]}
                onChange={(value: any) => setTask({ ...task, trade: trades.find((t: any) => t.id === value) || { id: '', name: '' } })}
            />

            <BasicMenu
                id="assigned"
                label="Assigned"
                value={task.assigned.id}
                options={[
                    { value: '', label: 'None' },
                    ...users.map((u: any) => ({ value: u.id, label: u.username }))
                ]}
                onChange={(value: any) => setTask({ ...task, assigned: users.find((u: any) => u.id === value) || { id: '', username: '' } })}
            />

            <Box sx={{ display: 'flex', justifyContent: 'flex-end', mt: 1 }}>
                <Button onClick={onClose}>Cancel</Button>
                <Button onClick={() => onConfirm(task)}>Confirm</Button>
            </Box>
        </div>
    );
}

export default AddEditTask;