import * as React from 'react';
import { Link, useNavigate } from "react-router-dom"
import { useDispatch } from 'react-redux';

import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import Grid from '@mui/material/Grid';

import { createTheme, ThemeProvider } from '@mui/material/styles';
import { register } from '../http/user';
import { login } from '../features/auth';

const theme = createTheme();

function Register() {
  const dispatch = useDispatch();
  const navigate = useNavigate();

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    
    const data = new FormData(event.currentTarget);

    const first = data.get('firstName') as string;
    const last = data.get('lastName') as string;
    const email = data.get('email') as string;
    const password = data.get('password') as string;

    register(`${first} ${last}`, email, password)
    .then((res) => {
      if (res.status === 200) {
        console.log(res);
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
            Sign up
          </Typography>
          <Box component="form" noValidate onSubmit={handleSubmit} sx={{ mt: 3 }}>
            <Grid container spacing={2}>
              <Grid item xs={6} sm={6}>
                <TextField
                  autoComplete="given-name"
                  name="firstName"
                  required
                  fullWidth
                  id="firstName"
                  label="First Name"
                  autoFocus
                />
              </Grid>
              <Grid item xs={6} sm={6}>
                <TextField
                  required
                  fullWidth
                  id="lastName"
                  label="Last Name"
                  name="lastName"
                  autoComplete="family-name"
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  required
                  fullWidth
                  id="email"
                  label="Email Address"
                  name="email"
                  autoComplete="email"
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  required
                  fullWidth
                  name="password"
                  label="Password"
                  type="password"
                  id="password"
                  autoComplete="new-password"
                />
              </Grid>
            </Grid>
            <Button
              type="submit"
              fullWidth
              variant="contained"
              sx={{ mt: 3, mb: 2 }}
            >
              Sign Up
            </Button>
            <Link to="/login" >
              Already have an account? Sign in
            </Link>
          </Box>
      </Box>
    </ThemeProvider>
  );
}

export default Register