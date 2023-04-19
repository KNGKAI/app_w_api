import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import Typography from '@mui/material/Typography';
import AddIcon from '@mui/icons-material/Add';

function Panel(props: any) {
    const { data, onAdd, onEdit, onRemove } = props;
  
    return <Box>
        {onAdd && <Button
            startIcon={<AddIcon />}
            color="primary"
            onClick={onAdd}
            >
            Add
        </Button>}

        {data.length === 0 && <Box>...</Box>}

        {data.map((x: any) => (
            <Box
            key={x.id}
            sx={{
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
                p: 1,
                m: 1,
                bgcolor: 'background.paper',
            }}
            >
            <Typography component="h1" variant="body2">
                {x.name}
            </Typography>
            <Typography component="h1" variant="body2">
                {x.description}
            </Typography>
            <Box>
                {onEdit && <Button
                    variant="contained"
                    color="primary"
                    onClick={() => { onEdit(x.id) }}
                    >
                    Edit
                </Button>}
                {onRemove && <Button
                    variant="contained"
                    color="secondary"
                    sx={{ ml: 1 }}
                    onClick={() => { onRemove(x.id) }}
                    >
                    Remove
                </Button>}
            </Box>
            </Box>
        ))}
    </Box>
}

export default Panel;