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
  site(id: "${id}") {
    id
    name
    description
    address
  }
}
`;

function AddEditSite({ id, onConfirm, onClose } : { id: string | null, onConfirm: any, onClose: any }) {
    const [site, setSite] = React.useState({ id: null, name: "new", description: "enter_description", address: "enter_address" });
    const { loading, error, data } = id ? useQuery(QUERY(id || "")) : { loading: false, error: false, data: null };

    if (loading) return (<p>Loading...</p>);
    if (error) return (<p>Error : {error.message}</p>);
    if (data && !site.id) setSite(data.site);

    return (
        <div>
            <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
                {id ? "Update Site" : "Add Site"}
            </Typography>
            <TextField
                id="name"
                label="Name"
                defaultValue={site.name}
                variant="standard"
                onChange={(e) => setSite({ ...site, name: e.target.value })}
            />
            <TextField
                id="description"
                label="Description"
                defaultValue={site.description}
                variant="standard"
                onChange={(e) => setSite({ ...site, description: e.target.value })}
            />
            <TextField
                id="address"
                label="Address"
                defaultValue={site.address}
                variant="standard"
                onChange={(e) => setSite({ ...site, address: e.target.value })}
            />
            <Box sx={{ display: 'flex', justifyContent: 'flex-end', mt: 1 }}>
                <Button onClick={onClose}>Cancel</Button>
                <Button onClick={() => onConfirm(site)}>Confirm</Button>
            </Box>
        </div>
    );
}

export default AddEditSite;