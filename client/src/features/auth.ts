import { createSlice } from '@reduxjs/toolkit';
import Cookies from 'js-cookie';

const slice = createSlice({
    name: 'auth',
    initialState:  {
        authenticated: false,
        admin: false,
        token: Cookies.get('token') || null,
    },
    reducers: {
        login(state, action) {
            // Cookies.set('token', action.payload.token);
            state = {
                ...state,
                authenticated: true,
                admin: action.payload.admin,
                token: action.payload.token,
            }
            return state;
        },
        logout(state) {
            // Cookies.remove('token');
            state = {
                ...state,
                authenticated: false,
                admin: false,
                token: null,
            }
            return state;
        },
    }
})

export const { login, logout } = slice.actions

export default slice.reducer