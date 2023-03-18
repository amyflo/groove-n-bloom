import { Link } from 'react-router-dom';
import { useState } from 'react';
import { AppBar, MenuItem, Menu, IconButton, Container, Toolbar, Typography, Box, Button } from '@mui/material';
import MenuIcon from '@mui/icons-material/Menu';
import { auth } from './firebase';
import { signOut } from 'firebase/auth';
import dayjs from 'dayjs';
import { StyleSheet } from 'react-native';

export default function Navbar() {
    const logout = async () => {
        try {
            await signOut(auth);
        } catch (e) {
            console.log(e);
        }
    };

    const [anchorElNav, setAnchorElNav] = useState(null);

    const handleOpenNavMenu = (event) => {
        setAnchorElNav(event.currentTarget);
    }

    const handleCloseNavMenu = () => {
        setAnchorElNav(null);
    }

    return (
        <AppBar position='static'>
            <Container maxWidth="xl">
                <Toolbar disableGutters>
                    <Box sx={{ flexGrow: 1, display: { xs: 'flex', md: 'none' } }}>
                        <IconButton
                            size='large'
                            aria-label='account of current user'
                            aria-controls='menu-appbar'
                            aria-haspopup='true'
                            onClick={handleOpenNavMenu}
                            color='inherit'
                        >
                            <MenuIcon />
                        </IconButton>
                        <Menu
                            id='menu-appbar'
                            anchorEl={anchorElNav}
                            anchorOrigin={{
                                vertical: 'bottom',
                                horizontal: 'left',
                            }}
                            keepMounted
                            transformOrigin={{
                                vertical: 'top',
                                horizontal: 'left'
                            }}
                            open={Boolean(anchorElNav)}
                            onClose={handleCloseNavMenu}
                            sx={{
                                display: { xs: 'block', md: 'none' }
                            }}
                        >
                            <Link to="/" style={{ textDecoration: 'none' }}>
                                <MenuItem key={"dashboard"} onClick={handleCloseNavMenu}>
                                    <Typography textAlign="center">Dashboard</Typography>
                                </MenuItem>
                            </Link>
                            <Link state={{ date: dayjs() }} to="/entry" style={{ textDecoration: 'none' }}>
                                <MenuItem key={"entry"} onClick={handleCloseNavMenu}>
                                    <Typography textAlign="center">Today's Entry</Typography>
                                </MenuItem>
                            </Link>
                            
                            <Link to="/history" style={{ textDecoration: 'none' }}>
                                <MenuItem key={"past-entries"} onClick={handleCloseNavMenu}>
                                    <Typography textAlign="center">View Past Entries</Typography>
                                </MenuItem>
                            </Link>
                            <Link to="/" style={{ textDecoration: 'none' }}>
                                <MenuItem key={"logout"} onClick={logout}>
                                    <Typography textAlign="center">Logout</Typography>
                                </MenuItem>
                            </Link>
                            
                        </Menu>
                    </Box>
                    <Box sx={{ flexGrow: 1, display: { xs: 'none', md: 'flex' } }}>
                        <Link to="/" style={{ textDecoration: 'none' }}>
                            <Button
                                key={"dashboard"}
                                onClick={handleCloseNavMenu}
                                sx={{ my: 2, color: 'white', display: 'block' }}
                            >
                                Dashboard
                            </Button>
                        </Link>
                        <Link state={{date: dayjs()}} to="/entry" style={{ textDecoration: 'none' }}>
                            <Button
                                key={"entry"}
                                onClick={handleCloseNavMenu}
                                sx={{ my: 2, color: 'white', display: 'block' }}
                            >
                                Today's Entry
                            </Button>
                        </Link>
                        <Link to="/history" style={{ textDecoration: 'none' }}>
                            <Button
                                key={"past-entries"}
                                onClick={handleCloseNavMenu}
                                sx={{ my: 2, color: 'white', display: 'block' }}
                            >
                                View Past Entries
                            </Button>
                        </Link>
                        <Link to="/" style={{ textDecoration: 'none' }}>
                            <Button
                                key={"logout"}
                                onClick={logout}
                                sx={{ my: 2, color: 'white', display: 'block' }}
                            >
                                Logout
                            </Button>
                        </Link>
                    </Box>
                </Toolbar>
            </Container>
        </AppBar>
    );
}