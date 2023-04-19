import React, { useEffect } from 'react';
import { useQuery, gql } from '@apollo/client';

import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import Tabs from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';
import Modal from '@mui/material/Modal';

import { createTheme, ThemeProvider } from '@mui/material/styles';
import { Button } from '@mui/material';
import TabPanel from '../Dashboard/TabPanel';
import TaskModal from './TaskModal';
import TaskGrid from './TaskGrid';
import { updateTask } from '../../http/manager';

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

const VIEW_TASK = 1;

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
    tasks {
        id
        label
        description
        priority
        status
        site {
            id
            name
        }
        trade {
            id
            name
        }
        assigned {
            id
            username
        }
    }
  }
}
`;

function Activities({ id }: any) {
    const { loading, error, data, refetch } = useQuery(QUERY(id));

    const [panel, setPanel] = React.useState(0);
    const [modal, setModal] = React.useState(0);

    const [selected, setSelected] = React.useState('');

    if (loading) return <p>Loading...</p>;
    if (error) return <p>Error : {error.message}</p>;

    const tasks = data.user.tasks;

    const handleView = (task: any) => {
        setModal(VIEW_TASK);
        setSelected(task.id);
    }

    const tabs = [
        {
        value: 0,
        label: 'Tasks',
        panel: <Box>
            
            <Typography component="h1" variant="h5" mb={1} >
                Open
            </Typography>
            <TaskGrid tasks={tasks.filter((x: any) => x.status === 0 || true)} onView={handleView} />

            <Typography component="h1" variant="h5" mt={1} mb={1}>
                In Progress
            </Typography>
            <TaskGrid tasks={tasks.filter((x: any) => x.status === 1 || true)} onView={handleView} />

        </Box>,
        },
        {
        value: 1,
        label: 'History',
        panel: <Box>
            <Typography component="h1" variant="h5">
                Closed
            </Typography>
            <Box sx={{ mt: 3 }}>
                {tasks.filter((x: any) => x.status === 2).map((task: any) => (
                    <Box key={task.id} sx={{ mt: 3 }}>
                        <Typography component="h1" variant="h6">
                            {task.label}
                        </Typography>
                        <Typography component="h1" variant="body1">
                            {prorities.find((x) => x.value === task.priority)?.label}
                        </Typography>
                        <Button onClick={() => { setModal(VIEW_TASK); setSelected(task.id) }}>View</Button>
                    </Box>
                ))}
            </Box>
        </Box>,
        },
    ];

    const modals = [
        {
            value: VIEW_TASK,
            panel: <TaskModal
                task={tasks.find((x: any) => x.id === selected)}
                onConfirm={(task: any) => {
                    console.log(task);
                    var status = task.status;
                    
                    if (status === 0) {
                        status = 1;
                    } else if (status === 1) {
                        status = 2;
                    } else if (status === 2) {
                        // close task
                    }


                    updateTask(
                        task.id,
                        task.label,
                        task.description,
                        task.priority,
                        status,
                        task.site.id,
                        task.trade.id,
                        task.assigned.id,
                        0,
                        0,
                    )
                    .then(() => {
                        refetch();
                    })
                    .catch((err) => {
                        console.log(err);
                    })
                    .finally(() => {
                        setModal(0);
                    });
                }}
            />,
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

        <Box
            sx={{
                width: '100%',
                typography: 'body1',
            }}
        >
            <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
                <Tabs value={panel} onChange={handleChange}>
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
        </ThemeProvider>
    );
};

export default Activities;