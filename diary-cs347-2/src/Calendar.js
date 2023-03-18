import * as React from 'react';
import Container from '@mui/material/Container';
import dayjs from 'dayjs';
import Badge from '@mui/material/Badge'
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { CalendarPicker } from '@mui/x-date-pickers/CalendarPicker';
import { PickersDay } from '@mui/x-date-pickers/PickersDay';
import { useState } from 'react';
import { Button } from '@mui/material';
import { useNavigate } from 'react-router-dom';
import Grid from '@mui/material/Grid';
import { db, auth } from './firebase';
import Typography from '@mui/material/Typography';
import Card from '@mui/material/Card';
import { useEffect } from 'react';
import CardContent from '@mui/material/CardContent';
import { collection, getDocs, query, where } from 'firebase/firestore';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import TextField from '@mui/material/TextField';

export default function Calendar() {
    const [date, setDate] = useState(dayjs());
    const [angry, setAngry] = useState(0);
    const [sad, setSad] = useState(0);
    const [happy, setHappy] = useState(0);
    const [fear, setFear] = useState(0);
    const [surprise, setSurprise] = useState(0);
    const [entry, setEntry] = useState("No entry for this date.");
    const navigate = useNavigate();
    const [entryDates, setEntryDates] = useState([]);

    const getEntryDates = async () => {
        const q = query(collection(db, "Users"), where("User", "==", auth.currentUser.displayName));
        const snapshot = await getDocs(q);
        if (!snapshot.empty) {
            setEntryDates(snapshot.docs[0].data()["entryDates"]);
        }
    }
    getEntryDates();

    const passToJournal = () => {
        navigate('/entry', { state: { date: date } });
    }

    useEffect(() => {
        retrieveEntry(date);
    }, [])

    const retrieveEntry = async (entryDate) => {
        const q = query(collection(db, "Entries"), where("Date", "==", dayjs(entryDate).format("MM/DD/YYYY")), where("User", "==", auth.currentUser.displayName));
        const querySnapshot = await getDocs(q);

        if (!querySnapshot.empty) {
            const queryData = querySnapshot.docs[0].data();
            setAngry(queryData["Angry"]);
            setSad(queryData["Sad"]);
            setHappy(queryData["Happy"]);
            setFear(queryData["Fear"]);
            setSurprise(queryData["Surprise"]);
            setEntry("Entry available")
        } else {
            setAngry(0);
            setSad(0);
            setHappy(0);
            setFear(0);
            setSurprise(0);
            setEntry("No entry for this date.")
        }

    }

    return (


        <Container maxWidth="lg">
            <Grid container spacing={2} padding={10}>
                <Grid item lg={6}>
                    <Card>
                        <CardContent mx={2}>
                            <Container mx="auto" style={{ align: "center", display: "flex" }}>
                                <LocalizationProvider dateAdapter={AdapterDayjs}>
                                    <DatePicker style={{ display: "flex" }} disableOpenPicker={true} value={date} disableFuture={true} onChange={newDate => { setDate(newDate); retrieveEntry(newDate) }} renderInput={(params) => <TextField {...params} />} />
                                </LocalizationProvider>
                                <Button style={{ flex: "flex-end" }} variant="outlined" onClick={() => { setDate(dayjs()); retrieveEntry(dayjs()) }}>Today</Button>
                            </Container>
                            <LocalizationProvider dateAdapter={AdapterDayjs}>
                                <CalendarPicker
                                    date={date}
                                    disableFuture={true}
                                    onChange={newDate => { setDate(newDate); retrieveEntry(newDate) }}
                                    renderDay={(day) => {
                                        const formattedDate = day.format("MM/DD/YYYY");
                                        const shouldDisplay = entryDates.includes(formattedDate);

                                        return (
                                            <Badge badgeContent={shouldDisplay ? '✏️' : undefined} overlap="circular">
                                                <PickersDay day={day} onDaySelect={newDate => { setDate(newDate); retrieveEntry(newDate) }} />
                                            </Badge>
                                        )
                                    }}
                                />
                                <br />

                            </LocalizationProvider>
                        </CardContent>
                    </Card>
                </Grid>
                <Grid item lg={6}>
                    <Card>
                        <CardContent mx={2}>

                            <Typography mx="auto" variant="h4">{date.format("MM/DD/YYYY")}</Typography>
                            <Typography variant="subtitle2" mt={2}>{entry}</Typography>

                            <br />

                            <Button variant="contained" style={{ alignSelf: "flex-end" }} onClick={() => { passToJournal() }}>Edit entry</Button>
                        </CardContent>
                    </Card>
                </Grid>
            </Grid>
        </Container >

    )
}
