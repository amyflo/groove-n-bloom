import * as React from 'react';
import Accordion from '@mui/material/Accordion';
import AccordionSummary from '@mui/material/AccordionSummary';
import AccordionDetails from '@mui/material/AccordionDetails';
import Typography from '@mui/material/Typography';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';

export default function SimpleAccordion(props) {
    return (
        <Accordion className='emotion-accordion'>

            <AccordionSummary
                expandIcon={<ExpandMoreIcon />}
                aria-controls="panel1a-content"
                id="panel1a-header"
            >
                <Typography variant="h6">About your emotions</Typography>
            </AccordionSummary>
            <AccordionDetails>
                Each of the five basic emotions is represented by a color. When you type, the gradient in the background will change as well the bars below.
                <br /> Sad: blue, Angry: red, Happy: yellow, Fear: green, and Surprise: purple.
                {props.children}
            </AccordionDetails>
        </Accordion>
    );
}