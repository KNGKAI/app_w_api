import { useState, useEffect } from 'react'
import { useDispatch } from 'react-redux';
import { styled, createTheme, ThemeProvider } from '@mui/material/styles';

import MuiAppBar, { AppBarProps as MuiAppBarProps } from '@mui/material/AppBar';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import IconButton from '@mui/material/IconButton';
import Badge from '@mui/material/Badge';
import NotificationsIcon from '@mui/icons-material/Notifications';

import MuiDrawer from '@mui/material/Drawer';

import * as React from 'react';
import ListItemButton from '@mui/material/ListItemButton';
import ListItemIcon from '@mui/material/ListItemIcon';
import ListItemText from '@mui/material/ListItemText';
import DashboardIcon from '@mui/icons-material/Dashboard';
import ShoppingCartIcon from '@mui/icons-material/ShoppingCart';
import PeopleIcon from '@mui/icons-material/People';
import BarChartIcon from '@mui/icons-material/BarChart';
import LayersIcon from '@mui/icons-material/Layers';
import Divider from '@mui/material/Divider';

import List from '@mui/material/List';
import MenuIcon from '@mui/icons-material/Menu';
import ChevronLeftIcon from '@mui/icons-material/ChevronLeft';
import { connect } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { logout } from '../../features/auth';

const mainListItems = (
<React.Fragment>
    <ListItemButton>
    <ListItemIcon>
        <DashboardIcon />
    </ListItemIcon>
    <ListItemText primary="Dashboard" />
    </ListItemButton>
    <ListItemButton>
    <ListItemIcon>
        <ShoppingCartIcon />
    </ListItemIcon>
    <ListItemText primary="Orders" />
    </ListItemButton>
    <ListItemButton>
    <ListItemIcon>
        <PeopleIcon />
    </ListItemIcon>
    <ListItemText primary="Customers" />
    </ListItemButton>
    <ListItemButton>
    <ListItemIcon>
        <BarChartIcon />
    </ListItemIcon>
    <ListItemText primary="Reports" />
    </ListItemButton>
    <ListItemButton>
    <ListItemIcon>
        <LayersIcon />
    </ListItemIcon>
    <ListItemText primary="Integrations" />
    </ListItemButton>
</React.Fragment>
);

const drawerWidth: number = 240;

interface AppBarProps extends MuiAppBarProps {
    open?: boolean;
}
    
const AppBar = styled(MuiAppBar, {
    shouldForwardProp: (prop) => prop !== 'open',
})<AppBarProps>(({ theme, open }) => ({
    zIndex: theme.zIndex.drawer + 1,
    transition: theme.transitions.create(['width', 'margin'], {
        easing: theme.transitions.easing.sharp,
        duration: theme.transitions.duration.leavingScreen,
    }),
    ...(open && {
        marginLeft: drawerWidth,
        width: `calc(100% - ${drawerWidth}px)`,
        transition: theme.transitions.create(['width', 'margin'], {
            easing: theme.transitions.easing.sharp,
            duration: theme.transitions.duration.enteringScreen,
        }),
    }),
}));

const Drawer = styled(MuiDrawer, { shouldForwardProp: (prop) => prop !== 'open' })(
    ({ theme, open }) => ({
      '& .MuiDrawer-paper': {
        position: 'relative',
        whiteSpace: 'nowrap',
        width: drawerWidth,
        transition: theme.transitions.create('width', {
            easing: theme.transitions.easing.sharp,
            duration: theme.transitions.duration.enteringScreen,
        }),
        boxSizing: 'border-box',
        ...(!open && {
          overflowX: 'hidden',
          transition: theme.transitions.create('width', {
            easing: theme.transitions.easing.sharp,
            duration: theme.transitions.duration.leavingScreen,
          }),
          width: theme.spacing(7),
          [theme.breakpoints.up('sm')]: {
            width: theme.spacing(9),
          },
        }),
      },
    }),
);

const mapStateToProps = (state: any) => {
    return {
        authenticated: state.auth.authenticated,
        user: state.user
    }
}

const theme = createTheme();

const Header = ({ authenticated, user }: any) => {
    const navigate = useNavigate();
    const dispatch = useDispatch();
    const [open, setOpen] = useState(authenticated);

    const toggleDrawer = () => {
        setOpen(!open);
    };

    const menuItem = (text: string, icon: any, onClick: any ) => (
        <ListItemButton onClick={onClick} >
            <ListItemIcon>
                {icon}
            </ListItemIcon>
            <ListItemText primary={text} />
        </ListItemButton>
    );
    
    return (
        <ThemeProvider theme={theme}>
            <AppBar position="absolute" open={open} >
                <Toolbar
                    sx={{
                        pr: '24px', // keep right padding when drawer closed
                    }}
                    >
                    {authenticated && (<IconButton
                        edge="start"
                        color="inherit"
                        aria-label="open drawer"
                        onClick={toggleDrawer}
                        sx={{
                            marginRight: '16px',
                            ...(open && { display: 'none' }),
                        }}
                        >
                        <MenuIcon />
                    </IconButton>)}
                    
                    <Typography
                        component="h1"
                        variant="h6"
                        color="inherit"
                        noWrap
                        sx={{ flexGrow: 1 }}
                        >
                        Adora
                    </Typography>
                    {authenticated && (<Typography
                        component="h1"
                        variant="h6"
                        color="inherit"
                        >
                        {user.username}
                    </Typography>)}
                    {authenticated && (<IconButton
                        color="inherit"
                        >
                        <Badge badgeContent={4} color="secondary">
                            <NotificationsIcon />
                        </Badge>
                    </IconButton>)}
                </Toolbar>
            </AppBar>

            {authenticated && (<Drawer variant="permanent" open={open}>
                <Toolbar
                    sx={{
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'flex-end',
                        px: [1],
                    }}
                >
                    <IconButton onClick={toggleDrawer}>
                        <ChevronLeftIcon />
                    </IconButton>
                </Toolbar>
                <Divider />
                <List component="nav">
                    {menuItem('Dashboard', <DashboardIcon />, () => navigate('/'))}
                    {menuItem('Orders', <ShoppingCartIcon />, () => navigate('/orders'))}
                    <Divider />
                    {open && menuItem('Sign Out', <PeopleIcon />, () => {
                        setOpen(false);
                        dispatch(logout());
                        navigate('/login');
                    })}
                </List>
            </Drawer>)}

        </ThemeProvider>
    );
}

export default connect(mapStateToProps)(Header);