import React, { useEffect } from 'react';
import { useSelector } from 'react-redux';
import { useQuery, gql } from '@apollo/client';
import {
    TextField,
    Box,
    Button,
    Typography
 } from '@mui/material';
import BasicMenu from '../../BasicMenu/BasicMenu';
import { update } from '../../../http/user';


const QUERY = (id: string) => gql`
{
  user(id: "${id}") {
    id
    username
    email
    role {
        id
        name
    }
    trades {
        id
        name
    }
    company {
        id
        name
        description
        roles {
            id
            name
        }
        trades {
            id
            name
        }
    }
  }
}
`;

function EditUser({ id, onConfirm, onClose } : { id: string, onConfirm: any, onClose: any }) {
    const { loading, error, data, ...other } = useQuery(QUERY(id));
    const [user, setUser] = React.useState({
        id: '',
        username: '',
        email: '',
        role: '',
        trades: []
    } as any);

    if (loading) return (<p>Loading...</p>);
    if (error) return (<p>Error : {error.message}</p>);

    if (user.id === '') {
        setUser(data.user);
    }

    const role = user.role ?? { name: "Unknown" } as any;
    const company = user.company ?? { name: "Unknown" } as any;
    const roles = company.roles ?? [];
    const trades = company.roles ?? [];

    return (
        <div>
            <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
                Edit User
            </Typography>

            <Box sx={{ display: 'flex', justifyContent: 'flex-end', mt: 1 }}>
                <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
                    {user.username}
                </Typography>
                <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
                    {user.email}
                </Typography>
            </Box>

            <BasicMenu
                label="Role"
                value={role.id}
                options={roles.map((r: any) => {
                    return { value: r.id, label: r.name };
                })}
                onChange={(value: any) => {
                    setUser({ ...user, role: roles.find((r: any) => r.id === value) });
                    console.log(user);
                }}
            />
            
            <Box sx={{ display: 'flex', justifyContent: 'flex-end', mt: 1 }}>
                <Button onClick={onClose}>Cancel</Button>
                <Button onClick={() => onConfirm(user)}>Confirm</Button>
            </Box>
        </div>
    );
}

export default EditUser;