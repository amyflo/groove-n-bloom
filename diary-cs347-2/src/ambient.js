
import * as React from 'react';
import { Button, Typography } from '@mui/material';
import { collection, getDocs, query, where } from 'firebase/firestore';
import { useState, useEffect } from 'react';
import moment from 'moment/moment';
import dayjs from 'dayjs';
import { auth, db } from './firebase';
import { StyleSheet } from 'react-native';
import EditIcon from '@mui/icons-material/Create';
import CalendarTodayIcon from '@mui/icons-material/CalendarToday';
import { Link } from 'react-router-dom';
import "./shape.css"

function Clock() {
    const [time, setTime] = useState(new Date());

    useEffect(() => {
        const interval = setInterval(() => {
            setTime(new Date());
        }, 1000);
        return () => clearInterval(interval);
    }, []);

    return (
        <Typography style={styles.time} variant="h1">
            {time.toLocaleTimeString([], { hour: 'numeric', minute: '2-digit' })}
        </Typography>
    )
}

export default function Ambient() {
    const [angry, setAngry] = useState(0);
    const [sad, setSad] = useState(0);
    const [happy, setHappy] = useState(0);
    const [fear, setFear] = useState(0);
    const [surprise, setSurprise] = useState(0);
    const [prevEntry, setPrevEntry] = useState(false);

    const checkPosts = async () => {
        const q = query(collection(db, "Entries"), where("Date", "==", dayjs().format("MM/DD/YYYY")), where("User", "==", auth.currentUser.displayName));
        const querySnapshot = await getDocs(q);
        if (querySnapshot.docs.length >= 1) { // entry written today
            setPrevEntry(true);
        } else {
            setPrevEntry(false);
        }
    }

    const fetchData = () => {
        let message;
        checkPosts();
        if (!prevEntry) {
            message = "Write today's entry";
        } else {
            message = "Edit today's entry";
        }
        return (
            <div style={styles.caption}>
                {message}
                <Link state={{ date: dayjs() }} to="/entry" style={{ textDecoration: 'none' }}>
                    <Button className='edit-button'>
                        <EditIcon fontSize='large' sx={{ color: 'black' }} />
                    </Button>
                </Link>
            </div>
        )
    }

    const getWelcome = () => {
        let welcome;
        if (moment().format('LT').includes("AM")) {
            welcome = "Good morning, "
        } else {
            welcome = "Good evening, "

        }
        welcome += auth.currentUser.displayName
        return (
            <Typography variant="h2">{welcome}</Typography>
        )
    }



    const getHighestSentiment = async () => {
        const q = query(collection(db, "Entries"), where("Date", "==", dayjs().format("MM/DD/YYYY")), where("User", "==", auth.currentUser.displayName));
        const querySnapshot = await getDocs(q);
        if (!querySnapshot.empty) {
            let doc = querySnapshot.docs[0].data();
            setAngry(doc["Angry"]);
            setSad(doc["Sad"]);
            setHappy(doc["Happy"]);
            setSurprise(doc["Surprise"]);
            setFear(doc["Fear"]);
        }
        // return Math.max(angry, sad, happy, surprise, fear);
    }

    useEffect(() => {
        getHighestSentiment();
    }, [])

    return (
        <div className='dashboard-container'>

            <div id='timeContainer' style={styles.time}>
                <Clock />
            </div>
            <div style={styles.welcome}>
                {getWelcome()}
                <div className='edit-or-write'>
                    {fetchData()}
                </div>
            </div>
            <div style={styles.buttonGroup}>

                <Link to="/history" style={{ textDecoration: 'none' }}> <Button className='calendar' style={styles.button}><CalendarTodayIcon /></Button> </Link>
                <Link state={{ date: dayjs() }} to="/entry" style={{ textDecoration: 'none' }}><Button className='new-entry' style={styles.button}><EditIcon /></Button></Link>
                <a style={{ textDecoration: "none", width: "300px", "height": "100%" }} target="_blank" href="https://forms.gle/hwQS13AxBs4Di4YS7">
                    <Button variant="outlined" >Complete Daily Survey</Button>
                </a>

            </div>


        </div>
    )
}

const styles = StyleSheet.create({

    buttonGroup: {
        display: 'flex',
        flexDirection: 'row',
        margin: 'auto',
        justifyContent: 'center',
        alignItems: 'center',
    },

    time: {
        margin: 'auto',
        padding: "2rem",
        fontFamily: 'Roboto',
        fontStyle: 'normal',
        display: 'flex',
        alignItems: 'center',
        textAlign: 'center',
        justifyContent: 'center',
        letterSpacing: 1,
    },

    welcome: {
        width: "100%",
        fontFamily: 'Roboto',
        fontStyle: 'normal',
        alignItems: 'center',
        textAlign: 'center',
        justifyContent: 'center',
        letterSpacing: 1.5,
    },

    caption: {

        fontFamily: 'Roboto',
        fontStyle: 'normal',
        fontWeight: 700,
        fontSize: 50,
        display: 'flex',
        alignItems: 'center',
        textAlign: 'center',
        letterSpacing: 1.5,
        justifyContent: 'center',
    },

    button: {
        margin: '20px',
        justifyContent: 'center',
        alignItems: 'center',
        width: 60,
        height: 60,
        borderRadius: 56,

    }
});