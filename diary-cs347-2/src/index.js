import { CssBaseline, ThemeProvider } from '@mui/material';
import React from 'react';
import App from './app.js'
import theme from './theme.js';
import * as ReactDOM from 'react-dom/client';
import Error from "./Error"
import { BrowserRouter } from 'react-router-dom'

const root = ReactDOM.createRoot(document.getElementById('root'));

root.render(

    <React.StrictMode>
        <BrowserRouter>
            <ThemeProvider theme={theme}>
                <CssBaseline />
                <App />
            </ThemeProvider>
        </BrowserRouter>
    </React.StrictMode>

);
