import React, { useEffect } from 'react';
import { useSelector } from 'react-redux';
import { useQuery, gql } from '@apollo/client';
import {
    TextField,
    Box,
    Button,
    Typography
 } from '@mui/material';


const QUERY = (id: string) => gql`
{
  role(id: "${id}") {
    id
    name
    description
  }
}
`;

function AddEditRole({ id, onConfirm, onClose } : { id: string | null, onConfirm: any, onClose: any }) {
    const [role, setRole] = React.useState({ id: null, name: "new", description: "enter_description" });
    const { loading, error, data } = id ? useQuery(QUERY(id || "")) : { loading: false, error: false, data: null };

    if (loading) return (<p>Loading...</p>);
    if (error) return (<p>Error : {error.message}</p>);
    if (data && !role.id) setRole(data.role);

    return (
        <div>
            <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
                {id ? "Update Role" : "Add Role"}
            </Typography>
            <TextField
                id="name"
                label="Name"
                defaultValue={role.name}
                variant="standard"
                onChange={(e) => setRole({ ...role, name: e.target.value })}
            />
            <TextField
                id="description"
                label="Description"
                defaultValue={role.description}
                variant="standard"
                onChange={(e) => setRole({ ...role, description: e.target.value })}
            />
            <Box sx={{ display: 'flex', justifyContent: 'flex-end', mt: 1 }}>
                <Button onClick={onClose}>Cancel</Button>
                <Button onClick={() => onConfirm(role)}>Confirm</Button>
            </Box>
        </div>
    );
}

export default AddEditRole;