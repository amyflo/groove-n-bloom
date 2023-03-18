import { Link } from '@mui/material';
import React from 'react';

export default function Error() {
    return(
        <div>
            This page does not exist. 
            Go back to <Link href="/"> Home </Link>
        </div>
    )
}