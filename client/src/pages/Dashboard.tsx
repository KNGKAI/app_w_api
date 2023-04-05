import React, { useEffect } from 'react';
import { useSelector } from 'react-redux';
import { useQuery, gql } from '@apollo/client';

import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import Grid from '@mui/material/Grid';
import Divider from '@mui/material/Divider';

import { createTheme, ThemeProvider } from '@mui/material/styles';

const theme = createTheme();

const GET_USER = (id: string) => gql`
{
  user(id: "${id}") {
    username
    role {
      name
    }
    company {
      name
      description
    }
  }
}
`;

function Dashboard() {
  const user = useSelector((state: any) => state.user);
  // const { loading, error, data } = useQuery(GET_USER(user.id));
  const { loading, error, data } = useQuery(GET_USER("642d609010d2137bac321233"));

  useEffect(() => { }, [user]);

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error : {error.message}</p>;

  var company = data.user.company;
  var role = data.user.role;

  return (
    <ThemeProvider theme={theme}>
      <Box>
        <Typography component="h1" variant="h5">
          Dashboard
        </Typography>
        <Box sx={{ mt: 3 }}>
          <Grid container spacing={2}>

            {/* Company */}
            <Grid item xs={6} >
              <Typography component="h1" variant="h6">
                {company.name}
              </Typography>
              <Typography component="h1" variant="body2">
                {company.description}
              </Typography>
            </Grid>

            {/* User */}
            <Grid item xs={6} >
              {user.username} ({role.name})
            </Grid>

            <Grid item xs={12} >
              <Divider />
            </Grid>

            {/* Dashboard */}


            <Grid item xs={12} >
              <Divider />
            </Grid>
            
            <Grid item xs={12} >
              Lorem ipsum dolor sit, amet consectetur adipisicing elit. Voluptas modi similique sequi voluptatum eos porro, possimus non dignissimos sed, nesciunt dicta ea quos, iste ratione eveniet error! Porro, nam in!
            </Grid>

            {/* FOOTER BLOCKS */}
            {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].map((item) => (
              <Grid item xs={1} key={item}>
                <Box sx={{ height: 100, bgcolor: 'primary.main' }} />
              </Grid>
            ))}
          </Grid>
        </Box>
      </Box>
    </ThemeProvider>
  );
};

export default Dashboard;