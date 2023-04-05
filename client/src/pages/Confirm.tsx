import * as React from 'react';
import { Link, useNavigate } from "react-router-dom"
import { useDispatch } from 'react-redux';

import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';

import { createTheme, ThemeProvider } from '@mui/material/styles';
import { confirm } from '../http/user';
import { login } from '../features/auth';
import Cookies from 'js-cookie';

const theme = createTheme();

function Confirm() {
  const dispatch = useDispatch();
  const navigate = useNavigate();

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const data = new FormData(event.currentTarget);
    const token = data.get('token') as string;
    confirm(token)
    .then((res) => {
      if (res.status === 200) {
        Cookies.set('token', res.data.token);
        dispatch(login(res.data.token));
        navigate('/');
      } else {
        console.log(res.data);
      }
    })
    .catch((err) => {
      console.log(err);
    });
  };

  return (
    <ThemeProvider theme={theme}>
      <Box>
        <Typography component="h1" variant="h5">
          Confirm
        </Typography>
        <Box component="form" onSubmit={handleSubmit} noValidate sx={{ mt: 1 }}>
          <TextField
            margin="normal"
            required
            fullWidth
            id="token"
            label="Token"
            name="token"
            autoComplete="token"
            autoFocus
          />
          <Button
            type="submit"
            fullWidth
            variant="contained"
            sx={{ mt: 3, mb: 2 }}
          >
            Confirm
          </Button>
          <Link to="/login" >
            Login page
          </Link>
        </Box>
      </Box>
    </ThemeProvider>
  );
}

export default Confirm