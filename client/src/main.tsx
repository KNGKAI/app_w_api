import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'
import { BrowserRouter } from 'react-router-dom'

import { ApolloClient, InMemoryCache, ApolloProvider, gql } from '@apollo/client';

import { Provider } from 'react-redux'
import store from './store'

const client = new ApolloClient({
  uri: 'http://localhost:5000/gql',
  cache: new InMemoryCache(),
  
});

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
  <React.StrictMode>
    <BrowserRouter>
      <Provider store={store}>
      <ApolloProvider client={client}>
        <App />
      </ApolloProvider>
      </Provider>
    </BrowserRouter>
  </React.StrictMode>,
)
