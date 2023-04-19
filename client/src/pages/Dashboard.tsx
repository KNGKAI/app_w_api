import React, { useEffect } from 'react';
import { useSelector } from 'react-redux';
import { useQuery, gql } from '@apollo/client';

import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import Grid from '@mui/material/Grid';
import Button from '@mui/material/Button';

import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';

import AddIcon from '@mui/icons-material/Add';

import { createTheme, ThemeProvider } from '@mui/material/styles';
import AddEditSite from '../components/Dashboard/Modals/AddEditSite';
import { Modal } from '@mui/material';
import { createSite, createTask, updateSite, updateTask } from '../http/manager';
import AddEditTask from '../components/Dashboard/Modals/AddEditTask';
import ViewTask from '../components/Dashboard/Modals/ViewTask';

const ADD_SITE = 1;
const EDIT_SITE = 2;
const REMOVE_SITE = 3;
const ADD_TASK = 4;
const EDIT_TASK = 5;
const REMOVE_TASK = 6;
const VIEW_TASK = 7;

const prorities = [
  { value: 0, label: 'Low' },
  { value: 1, label: 'Medium' },
  { value: 2, label: 'High' },
  { value: 3, label: 'Critical' },
];

const statuses = [
    { value: 0, label: 'Open' },
    { value: 1, label: 'In Progress' },
    { value: 2, label: 'Closed' },
];

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
      sites {
        id
        name
        description
        address
        tasks {
          id
          label
          description
          status
          priority
          trade {
            id
            name
          }
          assigned {
            id
            username
          }
          start
          end
        }
      }
    }
  }
}
`;

const theme = createTheme();

function Dashboard() {
  const user = useSelector((state: any) => state.user);
  // const { loading, error, data } = useQuery(GET_USER(user.id));
  const { loading, error, data, refetch } = useQuery(QUERY("642d609010d2137bac321233"));
  const [section, setSection] = React.useState(0);
  const [modal, setModal] = React.useState(0);
  const [selected, setSelected] = React.useState<string | null>(null);

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error : {error.message}</p>;

  var company = data.user.company;
  var sites = company.sites;
  var tasks = sites.map((s: any) => s.tasks).flat();

  const handleModal = (value: number, id: string | null = null) => {
    setSelected(id);
    setModal(value);
  };

  const sections = [
    {
      value: 0,
      name: "Overview",
      component: <Box>
        <Typography component="h1" variant="h6">
          Overview
        </Typography>

        {sites.map((s: any) => (
          <TableContainer>
            <Typography component="h1" variant="h6">
              {s.name}
            </Typography>
            <Table size="small">
              <TableHead sx={{ backgroundColor: "lightgrey" }} >
                <TableRow>
                  <TableCell>Label</TableCell>
                  <TableCell align="right">Priority</TableCell>
                  <TableCell align="right">Status</TableCell>
                  <TableCell></TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {s.tasks.map((task: any) => (
                  <TableRow>
                    <TableCell>
                      {task.label}
                    </TableCell>
                    <TableCell align="right">{prorities[task.priority].label}</TableCell>
                    {/* <TableCell align="right">{statuses[task.status].label}</TableCell> */}
                    <TableCell align="right">
                      <Button
                        variant="outlined"
                        sx={{ mt: 1 }}
                        onClick={() => handleModal(VIEW_TASK, task.id)}
                      >
                        View
                      </Button>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </TableContainer> 
        ))}
      </Box>
    },
    {
      value: 1,
      name: "Sites",
      component: <Box>

        <Button
          startIcon={<AddIcon />}
          variant="outlined"
          sx={{ mt: 1 }}
          onClick={() => handleModal(ADD_SITE)}
        >
          Add Site
        </Button>

        {sites.map((s: any) => (
          <Box
            sx={{
              border: 1,
              borderColor: 'divider',
              borderRadius: 1,
              p: 2,
              mt: 1
            }} >
            <Typography component="h1" variant="h6">
              {s.name}
            </Typography>
            <Typography component="h1" variant="body1">
              {s.description}
            </Typography>
            <Typography component="h1" variant="body1">
              {s.address}
            </Typography>
            <Button
              variant="outlined"
              sx={{ mt: 1 }}
              onClick={() => handleModal(EDIT_SITE, s.id)}
            >
              View
            </Button>
          </Box>
        ))}
      </Box>
    },
    {
      value: 2,
      name: "Tasks",
      component: <Box>
        <Button
          startIcon={<AddIcon />}
          variant="outlined"
          sx={{ mt: 1 }}
          onClick={() => handleModal(ADD_TASK)}
        >
          Add Task
        </Button>
        {tasks.map((t: any) => (
          <Box
            sx={{
              display: 'flex',
              flexDirection: 'row',
              border: 1,
              borderColor: 'divider',
              borderRadius: 1,
              p: 2,
              mt: 1
            }} >
            <Box sx={{ flexGrow: 1 }} >
              <Typography component="h1" variant="h6">
                {t.label}
              </Typography>
              <Typography component="h1" variant="body1">
                {t.description}
              </Typography>
              <Typography component="h1" variant="body1">
                {t.status}
              </Typography>
              <Typography component="h1" variant="body1">
                {prorities[t.priority].label}
              </Typography>
              <Typography component="h1" variant="body1">
                {t.trade?.name || "Unassigned"}
              </Typography>
              <Typography component="h1" variant="body1">
                {t.assigned?.username || "Unassigned"}
              </Typography>
              <Button
                variant="outlined"
                sx={{ mt: 1 }}
                onClick={() => handleModal(EDIT_TASK, t.id)}
              >
                View
              </Button>
            </Box>
          </Box>
        ))}
      </Box>,
    },
  ];

  const modals = [
    {
      value: ADD_SITE,
      name: "Add Site",
      component: <AddEditSite
        id={null}
        onClose={() => setModal(0) }
        onConfirm={(site: any) => {
          createSite(
            company.id,
            site.name,
            site.description,
            site.address,
          )
          .then((res) => {
            refetch();
          })
          .catch((err) => {
            console.log(err);
          })
          .finally(() => {
            setModal(0);
          });
        }}
      />
    },
    {
      value: EDIT_SITE,
      name: "Edit Site",
      component: <AddEditSite
        id={selected}
        onClose={() => setModal(0) }
        onConfirm={(site: any) => {
          updateSite(
            site.id,
            site.name,
            site.description,
            site.address,
          )
          .then((res) => {
            refetch();
          })
          .catch((err) => {
            console.log(err);
          })
          .finally(() => {
            setModal(0);
          });
        }}
      />
    },
    {
      value: REMOVE_SITE,
      name: "Remove Site",
      component: <div>Remove Site</div>,
    },
    {
      value: ADD_TASK,
      name: "Add Task",
      component: <AddEditTask
        id={null}
        onClose={() => setModal(0) }
        onConfirm={(task: any) => {
          createTask(
            task.label,
            task.description,
            task.priority,
            task.site.id,
            task.trade.id,
            task.assigned.id,
            0,
            0
          )
          .then((res) => {
            refetch();
          })
          .catch((err) => {
            console.log(err);
          })
          .finally(() => {
            setModal(0);
          });
        }}
      />
    },
    {
      value: EDIT_TASK,
      name: "Edit Task",
      component: <AddEditTask
        id={selected}
        onClose={() => setModal(0) }
        onConfirm={(task: any) => {
          updateTask(
            task.id,
            task.label,
            task.description,
            task.priority,
            task.status,
            task.site.id,
            task.trade.id,
            task.assigned.id,
            0,
            0,
          )
          .then((res) => {
            refetch();
          })
          .catch((err) => {
            console.log(err);
          })
          .finally(() => {
            setModal(0);
          });
        }}
      />
    },
    {
      value: REMOVE_TASK,
      name: "Remove Task",
      component: <div>Remove Task</div>,
    },
    {
      value: VIEW_TASK,
      name: "View Task",
      component: <ViewTask
        id={selected || '0'}
        onClose={() => handleModal(0) }
      />
    }
  ];

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
          {modals.find((x) => x.value === modal)?.component}
        </Box>
      </Modal>

      <Box sx={{ mt: 3 }}>
        <Typography component="h1" variant="h5">
          Dashboard
        </Typography>

        <Typography component="h1" variant="body1">
          {company.name}
        </Typography>

        <Grid container spacing={3}>
          <Grid item xs={3}>
            <Box
              sx={{
                border: 1,
                borderColor: 'divider',
                borderRadius: 1,
                p: 2,
              }} >
              {sections.map((s) => (
                <Button
                  variant={s.value === section ? "contained" : "outlined"}
                  sx={{ width: '100%', mt: 1 }}
                  onClick={() => setSection(s.value)} >
                  {s.name}
                </Button>
              ))}
            </Box>
          </Grid>

          <Grid item xs={8}
            sx={{
              border: 1,
              borderColor: 'divider',
              borderRadius: 1,
              p: 2,
              ml: 1
            }} >
            {sections[section].component}
          </Grid>
          
        </Grid>
      </Box>
    </ThemeProvider>
  );
};

export default Dashboard;