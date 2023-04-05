import { configureStore } from '@reduxjs/toolkit'

import auth from './features/auth';
import user from './features/user';

export default configureStore({
  reducer: {
    auth: auth,
    user: user,
  },
});;
