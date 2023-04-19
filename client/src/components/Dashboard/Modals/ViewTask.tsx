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

function ViewTask({ id, onClose } : { id: string, onClose: any }) {
    const { loading, error, data } = useQuery(QUERY(id));

    if (loading) return (<p>Loading...</p>);
    if (error) return (<p>Error : {error.message}</p>);

    const { user, task } = data;

    return (
        <div>
            <Typography variant="h5" component="div" sx={{ flexGrow: 1 }}>
                View Task
            </Typography>
            
            <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
                Label: {task.label}
            </Typography>

            <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
                Description: {task.description}
            </Typography>

            <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
                Priority: {prorities[task.priority].label}
            </Typography>
            
            <Button fullWidth variant='contained' onClick={onClose} >OK</Button>
        </div>
    );
}

export default ViewTask;