import Card from '@mui/material/Card';
import Button from '@mui/material/Button';
import Typography from '@mui/material/Typography';

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

function TaskCard({ task, onView } : { task: any, onView: any }) {
    return (
        <Card
            sx={{
                width: '100%',
                display: 'flex',
                flexDirection: 'column',
                justifyContent: 'space-between',
                padding: 1,
            }}
        >
            <Typography variant="h6" component="div">
                {task.label}
            </Typography>
            <Typography variant="body2" component="div">
                {prorities[task.priority].label}
            </Typography>
            <Typography variant="body2" component="div">
                {statuses.find((status: any) => status.value === task.status)?.label}
            </Typography>
            <Button onClick={onView}>View</Button>
        </Card>
    );
}

export default TaskCard;