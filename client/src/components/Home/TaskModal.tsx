import Button from '@mui/material/Button';
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';

function TaskModal({ task, onConfirm } : { task: any, onConfirm: any }) {
    return (
        <Box>
            <Typography variant="h6" component="h2">
                {task.label}
            </Typography>
            <Typography variant="body2" component="div">
                {task.description}
            </Typography>
            <Typography variant="body2" component="div">
                {task.site.name}
            </Typography>
            <Typography variant="body2" component="div">
                {task.trade.name}
            </Typography>
            <Button onClick={() => onConfirm(task)}>Confirm</Button>
        </Box>
    );
}

export default TaskModal;