import { useState, useEffect } from 'react'
import { useDispatch } from 'react-redux';
import {  Routes, Route, useNavigate } from "react-router-dom";

import { createTheme, ThemeProvider } from '@mui/material/styles';

import CssBaseline from '@mui/material/CssBaseline';

import Box from '@mui/material/Box';
import Toolbar from '@mui/material/Toolbar';
import Container from '@mui/material/Container';

import Cookies from 'js-cookie';
import { refresh } from './http/user';
import { setUser } from './features/user';
import { login, logout } from './features/auth';
import Login from './pages/Login';
import Register from './pages/Register';
import Header from './components/Header/Header';
import Dashboard from './pages/Dashboard';

import './App.css'
import Confirm from './pages/Confirm';

const theme = createTheme();

function App() {  
  const dispatch = useDispatch();
  const navigate = useNavigate();

  useEffect(() => {
    // stop if login or register
    if (window.location.pathname === '/login'
    || window.location.pathname === '/register'
    || window.location.pathname === '/confirm') {
      return;
    }

    const token = Cookies.get('token');
    
    if (token) {
      refresh(token)
      .then((res) => {
        if (res.status === 200) {
          dispatch(setUser(res.data.user));
          dispatch(login({
            token: res.data.token,
            admin: res.data.admin
          }));
          Cookies.set('token', res.data.token);
        } else {
          navigate('/login');
        }
      })
      .catch((err) => {
        console.log(err);
        navigate('/login');
      });
    } else {
      navigate('/login');
    }

  }, [dispatch, navigate, setUser, login]);

  return (
    <ThemeProvider theme={theme}>
      <Box sx={{ display: 'flex' }}>
        <CssBaseline />

        <Header />

        <Box
          component="main"
          sx={{
            backgroundColor: (theme) =>
              theme.palette.mode === 'light'
                ? theme.palette.grey[100]
                : theme.palette.grey[900],
            flexGrow: 1,
            height: '100vh',
            overflow: 'auto',
          }}
        >
          <Toolbar />
          <Container sx={{ mt: 4, mb: 4 }}>
            
            <Routes>
              <Route path="/login" element={<Login />} />
              <Route path="/register" element={<Register />} />
              <Route path="/confirm" element={<Confirm />} />
              <Route path="/" element={<Dashboard />} />
            </Routes>

          </Container>
        </Box>
      </Box>
    </ThemeProvider>
  );
}

export default App