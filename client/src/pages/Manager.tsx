import React, { useEffect } from 'react';
import { useSelector } from 'react-redux';
import { useQuery, gql } from '@apollo/client';

import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import Tabs from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';
import Modal from '@mui/material/Modal';

import { createTheme, ThemeProvider } from '@mui/material/styles';
import { Button } from '@mui/material';
import Panel from '../components/Dashboard/Panel';
import TabPanel from '../components/Dashboard/TabPanel';
import AddEditTrade from '../components/Manager/Modals/AddEditTrade';
import { createRole, createTrade, removeRole, removeTrade, updateRole, updateTrade } from '../http/company';
import EditUser from '../components/Manager/Modals/EditUser';
import AddEditRole from '../components/Manager/Modals/AddEditRole';
import { update } from '../http/user';

const ADD_ROLE = 1;
const EDIT_ROLE = 2;
const REMOVE_ROLE = 3;
const ADD_TRADE = 4;
const EDIT_TRADE = 5;
const REMOVE_TRADE = 6;
const ADD_USER = 7;
const EDIT_USER = 8;
const REMOVE_USER = 9;

function a11yProps(index: number) {
  return {
    id: `simple-tab-${index}`,
    'aria-controls': `simple-tabpanel-${index}`,
  };
}


const theme = createTheme();

const QUERY = (id: string) => gql`
{
  user(id: "${id}") {
    id
    username
    role {
      name
    }
    company {
      id
      name
      description
      roles {
        id
        description
        name
      }
      trades {
        id
        description
        name
      }
      users {
        id
        username
        email
        role {
          id
          name
        }
        trades {
          id
          name
        }
      }
    }
  }
}
`;

function Manager() {
  const user = useSelector((state: any) => state.user);
  // const { loading, error, data } = useQuery(GET_USER(user.id));
  const { loading, error, data, refetch } = useQuery(QUERY("642d609010d2137bac321233"));

  const [panel, setPanel] = React.useState(0);
  const [modal, setModal] = React.useState(0);

  const [selected, setSelected] = React.useState('');

  useEffect(() => { }, [user]);

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error : {error.message}</p>;

  const role = data.user.role ?? { name: "Unknown" } as any;
  const company = data.user.company ?? { name: "Unknown" } as any;
  const roles = company.roles ?? [];
  const trades = company.trades ?? [];
  var users = company.users ?? [];

  const tabs = [
    {
      value: 0,
      label: 'Roles',
      panel: <Panel
        data={roles}
        onAdd={() => { setModal(ADD_ROLE) }}
        onEdit={(id: string) => { setModal(EDIT_ROLE); setSelected(id) }}
        onRemove={(id: string) => { setModal(REMOVE_ROLE); setSelected(id) }}
      />,
    },
    {
      value: 1,
      label: 'Trades',
      panel: <Panel
        data={trades}
        onAdd={() => { setModal(ADD_TRADE) }}
        onEdit={(id: string) => { setModal(EDIT_TRADE); setSelected(id) }}
        onRemove={(id: string) => { setModal(REMOVE_TRADE); setSelected(id) }}
      />,
    },
    {
      value: 2,
      label: 'Users',
      panel: <Panel
        data={users.map((x: any) => ({ ...x, name: x.username, description: x.role.name }))}
        onEdit={(id: string) => { setModal(EDIT_USER); setSelected(id) }}
      />,
    },
  ];

  const modals = [
    {
      value: ADD_ROLE,
      label: 'Add role',
      panel: <Box>
        <AddEditRole
          id={null}
          onConfirm={(role: any) => {
            createRole(
              company.id,
              role.name,
              role.description,
            )
            .then((res: any) => {
              refetch();
            })
            .catch((err: any) => {
              console.log(err);
            })
            .finally(() => {
              setModal(0);
            })
          }}
          onClose={() => { setModal(0) }}
        />
      </Box>,
    },
    {
      value: EDIT_ROLE,
      label: 'Edit role',
      panel: <Box>
        <AddEditRole
          id={selected}
          onConfirm={(role: any) => {
            updateRole(
              role.id,
              role.name,
              role.description,
            )
            .then((res: any) => {
              refetch();
            })
            .catch((err: any) => {
              console.log(err);
            })
            .finally(() => {
              setModal(0);
            })
          }}
          onClose={() => { setModal(0) }}
        />
      </Box>,
    },
    {
      value: REMOVE_ROLE,
      label: 'Remove role',
      panel: <Box>
        <Typography component="h1" variant="body2">
          Are you sure you want to remove this role?
        </Typography>
        <Box
          sx={{
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            p: 1,
            m: 1,
            bgcolor: 'background.paper',
          }}
        >
          <Button
            variant="contained"
            onClick={() => {
              removeRole(selected)
              .then((res: any) => {
                refetch();
              })
              .catch((err: any) => {
                console.log(err);
              })
              .finally(() => {
                setModal(0);
              })
            }}
          >
            Yes
          </Button>
          <Button
            variant="contained"
            onClick={() => { setModal(0) }}
          >
            No
          </Button>
        </Box>
      </Box>,
    },
    {
      value: ADD_TRADE,
      label: 'Add trade',
      panel: <Box>
        <AddEditTrade
          id={null}
          onConfirm={(trade: any) => {
            createTrade(
              company.id,
              trade.name,
              trade.description,
            )
            .then((res: any) => {
              refetch();
            })
            .catch((err: any) => {
              console.log(err);
            })
            .finally(() => {
              setModal(0);
            });
          }}
          onClose={() => { setModal(0) }}
        />
      </Box>,
    },
    {
      value: EDIT_TRADE,
      label: 'Edit trade',
      panel: <Box>
        <AddEditTrade
          id={selected}
          onConfirm={(trade: any) => {
            updateTrade(
              trade.id,
              trade.name,
              trade.description,
            )
            .then((res: any) => {
              refetch();
            })
            .catch((err: any) => {
              console.log(err);
            })
            .finally(() => {
              setModal(0);
            });
          }}
          onClose={() => { setModal(0) }}
        />
      </Box>,
    },
    {
      value: REMOVE_TRADE,
      label: 'Remove trade',
      panel: <Box>
        <Typography component="h1" variant="body2">
          Are you sure you want to remove this trade?
        </Typography>
        <Box
          sx={{
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            p: 1,
            m: 1,
            bgcolor: 'background.paper',
          }}
        >
          <Button
            variant="contained"
            color="primary"
            onClick={() => {
              removeTrade(selected)
              .then((res: any) => {
                refetch();
              })
              .catch((err: any) => {
                console.log(err);
              })
              .finally(() => {
                setModal(0);
              });
            }}
          >
            Yes
          </Button>
          <Button variant="contained" color="secondary" onClick={() => { setModal(0) }}>No</Button>
        </Box>
      </Box>,
    },
    {
      value: ADD_USER,
      label: 'Add user',
      panel: <Box>
        <Typography component="h1" variant="body2">
          Add user
        </Typography>
      </Box>,
    },
    {
      value: EDIT_USER,
      label: 'Edit user',
      panel: <Box>
        <EditUser
          id={selected}
          onConfirm={(user: any) => {
            update(
              user.id,
              user.username,
              user.email,
              user.role.id,
              user.trades?.map((t: any) => t.id) ?? [],
            )
            .then((res: any) => {
              refetch();
            })
            .catch((err: any) => {
              console.log(err);
            })
            .finally(() => {
              setModal(0);
            });
          }}
          onClose={() => { setModal(0) }}
        />
      </Box>,
    },
    {
      value: REMOVE_USER,
      label: 'Remove user',
      panel: <Box>
        <Typography component="h1" variant="body2">
          Remove user
        </Typography>
      </Box>,
    }
  ];

  const handleChange = (event: React.SyntheticEvent, value: number) => {
    setPanel(value);
  };

  return (
    <ThemeProvider theme={theme}>

      <Modal
        open={modal > 0}
        onClose={() => { setModal(0) }}
        aria-labelledby="modal-modal-title"
        aria-describedby="modal-modal-description"
      >
        <Box sx={{
          position: 'absolute',
          top: '50%',
          left: '50%',
          transform: 'translate(-50%, -50%)',
          width: 400,
          bgcolor: 'background.paper',
          border: '2px solid #000',
          boxShadow: 24,
          p: 4,
        }}>
          {modals.find((x) => x.value === modal)?.panel}
        </Box>
      </Modal>

      <Box>
        <Typography component="h1" variant="h5">
          Manager
        </Typography>
        <Box sx={{ mt: 3 }}>
          <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
            <Tabs value={panel} onChange={handleChange} aria-label="basic tabs example">
              {tabs.map((tab) => (
                <Tab key={tab.value} label={tab.label} value={tab.value} {...a11yProps(tab.value)} />
              ))}
            </Tabs>
          </Box>
          {tabs.map((tab) => (
            <TabPanel value={panel} index={tab.value}>
              {tab.panel}
            </TabPanel>
          ))}

        </Box>
      </Box>
    </ThemeProvider>
  );
};

export default Manager;