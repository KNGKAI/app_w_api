import Button from '@mui/material/Button';
import Grid from '@mui/material/Grid';
import TaskCard from './TaskCard';

function TaskGrid({ tasks, onView } : { tasks: any, onView: any }) {
    return (
        <Grid container spacing={2}>
            {tasks.map((task: any) => (
                <Grid key={task.id} item xs={4} sm={3} md={2}>
                    <TaskCard task={task} onView={() => onView(task)} />
                </Grid>
            ))}
        </Grid>
    );
}

export default TaskGrid;