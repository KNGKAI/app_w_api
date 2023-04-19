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
  trade(id: "${id}") {
    id
    name
    description
  }
}
`;

function AddEditTrade({ id, onConfirm, onClose } : { id: string | null, onConfirm: any, onClose: any }) {
    const [trade, setTrade] = React.useState({ id: null, name: "", description: "" });
    const { loading, error, data } = id ? useQuery(QUERY(id || "")) : { loading: false, error: false, data: null };

    if (loading) return (<p>Loading...</p>);
    if (error) return (<p>Error : {error.message}</p>);

    if (id && !trade.id && !loading && !error) {
        setTrade(data.trade);
    }

    return (
        <div>
            <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
                {id ? "Update Trade" : "Add Trade"}
            </Typography>
            <TextField
                id="name"
                label="Name"
                defaultValue={trade.name}
                variant="standard"
                onChange={(e) => setTrade({ ...trade, name: e.target.value })}
            />
            <TextField
                id="description"
                label="Description"
                defaultValue={trade.description}
                variant="standard"
                onChange={(e) => setTrade({ ...trade, description: e.target.value })}
            />
            <Box sx={{ display: 'flex', justifyContent: 'flex-end', mt: 1 }}>
                <Button onClick={onClose}>Cancel</Button>
                <Button onClick={() => onConfirm(trade)}>Confirm</Button>
            </Box>
        </div>
    );
}

export default AddEditTrade;