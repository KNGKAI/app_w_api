import * as React from 'react';
import Button from '@mui/material/Button';
import Menu from '@mui/material/Menu';
import MenuItem from '@mui/material/MenuItem';
import { Box, Typography } from '@mui/material';

export default function BasicMenu({ value, options, onChange, ...props }: any) {
    const [anchorEl, setAnchorEl] = React.useState<null | HTMLElement>(null);
    const open = Boolean(anchorEl);
    
    const handleClick = (event: React.MouseEvent<HTMLButtonElement>) => {
        setAnchorEl(event.currentTarget);
    };

    const handleClose = () => {
        setAnchorEl(null);
    };

    const handleChange = (value: any) => {
        onChange(value);
        handleClose();
    };

    return (<Box
        sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}
    >
        <Typography
            variant="h6"
            component="div"
            sx={{ flexGrow: 1 }}
        >
            {props.label}
        </Typography>
        <Button
            id="basic-button"
            aria-controls={open ? 'basic-menu' : undefined}
            aria-haspopup="true"
            aria-expanded={open ? 'true' : undefined}
            onClick={handleClick}
        >
            {options.find((option: any) => option.value === value)?.label}
        </Button>
        <Menu
            id="basic-menu"
            anchorEl={anchorEl}
            open={open}
            onClose={handleClose}
            MenuListProps={{
            'aria-labelledby': 'basic-button',
            }}
        >
            {options.map((option: any) => (
                <MenuItem key={option.value === '' ? 'unknown' : option.value} onClick={() => handleChange(option.value)}>
                    {option.label}
                </MenuItem>
            ))}
        </Menu>
    </Box>
  );
}