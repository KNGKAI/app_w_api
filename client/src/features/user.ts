import { createSlice } from '@reduxjs/toolkit'

const slice = createSlice({
  name: 'auth',
  initialState: {} as any | null,
  reducers: {
    setUser(state, action) {
      state = action.payload;
      return state;
    },
    
    getUser(state) {
      return state;
    }
  }
})

export const { setUser, getUser } = slice.actions

export default slice.reducer