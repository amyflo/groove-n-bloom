import * as React from 'react';
import Container from '@mui/material/Container';
import MUIRichTextEditor from 'mui-rte'
import dayjs from 'dayjs';
import { db, auth } from './firebase';
import { useState } from 'react';
import { collection, doc, getDocs, query, where, addDoc, updateDoc, arrayUnion } from 'firebase/firestore';
import { useLocation } from 'react-router-dom';
import { useEffect } from 'react';
import { convertFromHTML, ContentState, convertToRaw, convertFromRaw } from "draft-js";
import { stateToHTML } from "draft-js-export-html";
import { Button } from '@mui/material';
import Typography from '@mui/material/Typography';
import SimpleAccordion from './accordion';
import "./shape.css"

export default function JournalEntry() {
  const location = useLocation();
  const [date, setDate] = useState();
  const [angry, setAngry] = useState(0);
  const [sad, setSad] = useState(0);
  const [happy, setHappy] = useState(0);
  const [fear, setFear] = useState(0);
  const [surprise, setSurprise] = useState(0);
  const [html, setHTML] = useState('')

  const saveToFirebase = async () => {
    const q = query(collection(db, "Entries"), where("Date", "==", dayjs(date).format("MM/DD/YYYY")), where("User", "==", auth.currentUser.displayName));
    const q2 = query(collection(db, "Users"), where("User", "==", auth.currentUser.displayName));
    const querySnapshot = await getDocs(q);
    const querySnapshot2 = await getDocs(q2);

    if (querySnapshot.empty) {
      try {
        await addDoc(collection(db, "Entries"), {
          User: auth.currentUser.displayName,
          Date: dayjs(date).format("MM/DD/YYYY"),
          Entry: html,
          Happy: happy,
          Sad: sad,
          Angry: angry,
          Fear: fear,
          Surprise: surprise
        });

      } catch (e) {
        console.log(e);
      }
    } else {

      const docRef = doc(db, "Entries", querySnapshot.docs[0].id);
      const data = { Entry: html, Angry: angry, Fear: fear, Surprise: surprise, Happy: happy, Sad: sad };

      updateDoc(docRef, data)
        .then(docRef => {
          console.log("Value of an Existing Document Field has been updated");
        })
        .catch(error => {
          console.log(error);
        })
    };

    if (!querySnapshot2.empty) {
      const docRef2 = doc(db, "Users", querySnapshot2.docs[0].id);
      await updateDoc(docRef2, {
        entryDates: arrayUnion(dayjs(date).format("MM/DD/YYYY")),
      });
    }
  }

  // saves the data to firebase
  const save = async (data) => {
    saveToFirebase();
  };

  const [content, setContent] = useState('');
  const url = 'https://amyflo.pythonanywhere.com/classify'
  const [plainText, setPlainText] = useState('');

  const retrieveEntry = async (entryDate) => {
    const q = query(collection(db, "Entries"), where("Date", "==", dayjs(entryDate).format("MM/DD/YYYY")), where("User", "==", auth.currentUser.displayName));
    const querySnapshot = await getDocs(q);
    if (!querySnapshot.empty) {
      const queryData = querySnapshot.docs[0].data();
      const sampleMarkup = queryData["Entry"];
      const contentHTML = convertFromHTML(sampleMarkup)
      const state = ContentState.createFromBlockArray(contentHTML.contentBlocks, contentHTML.entityMap)
      const content = JSON.stringify(convertToRaw(state))
      setContent(content);
      setAngry(queryData["Angry"]);
      setSad(queryData["Sad"]);
      setHappy(queryData["Happy"]);
      setFear(queryData["Fear"]);
      setSurprise(queryData["Surprise"]);
    }
  }

  useEffect(() => {
    if (location != null) {
      const entryDate = new Date(location.state.date.$d);
      setDate(entryDate);
      retrieveEntry(entryDate);
    }
  }, [])

  // updates plainText, passes to Flask python API
  const change = (data) => {
    const text = data.getCurrentContent().getPlainText();
    setPlainText(text.split("\n"))
    setHTML(stateToHTML(data.getCurrentContent()));

    const input = JSON.stringify({ "text": plainText });
    $.post(url, input, (push, status) => {
      console.log(`status is ${status}`);
      const total = push["emotions"];
      setAngry(total["Angry"]);
      setSad(total["Sad"]);
      setHappy(total["Happy"]);
      setFear(total["Fear"]);
      setSurprise(total["Surprise"]);
      console.log(date, surprise, angry, sad, happy, fear, surprise)
    });
  };

  const controls = ["title", "bold", "italic", "underline", "strikethrough", "highlight", "undo", "redo", "link", "media", "numberList", "bulletList", "quote", "clear", "save"]

  return (
    // <div className="viz" style={{ background: 'linear-gradient(0deg, rgba(255, 1, 1, 0) 0%, rgba(255, 1, 1, ' + `${angry}` + ') 150%)' }}>
    //   <div className="viz" style={{ background: 'linear-gradient(72deg, rgba(25, 255, 1, 0) 0%, rgba(1, 255, 79, ' + `${fear}` + ') 150%)' }}>
    //     <div className="viz" style={{ background: 'linear-gradient(144deg, rgba(25, 255, 1, 0) 0%, rgba(1,132,255,' + `${sad}` + ') 150%)' }}>
    //       <div className="viz" style={{ background: 'linear-gradient(216deg, rgba(25, 255, 1, 0) 0%, rgba(255,186,1,' + `${happy}` + ') 150%)' }}>
    //         <div className="viz" style={{ padding: '20px', background: 'linear-gradient(288deg, rgba(25, 255, 1, 0) 0%, rgba(135,1,255,' + `${surprise}` + ') 150%)' }}>
              <Container style={{ margin: '20px auto'}} className="journal" maxWidth="lg">

                <Container style={{ display: 'flex' }}>
                  <Typography style={{width: "100%", "margin:": "auto"}}className="journal-date" variant='h4'>{dayjs(date).format("MM/DD/YYYY")}</Typography>

                  <a style={{ textDecoration: "none", width: "300px", "height": "100%" }} target="_blank" href="https://forms.gle/hwQS13AxBs4Di4YS7">
                    <Button variant="outlined" >Complete Daily Survey</Button>
                  </a>
                  
                  <Button variant="contained" onClick={() => { saveToFirebase(); }}>Save</Button>
                </Container>
                

                <MUIRichTextEditor
                  label="Start typing to see your emotions change in the background..."
                  onChange={change}
                  onSave={save}
                  defaultValue={content}
                  className="text"
                  inlineToolbar={true}
                  controls={controls} />

                <br/>
                <br/>
                {/* <SimpleAccordion>
                  <div className="circle-viz" >
                    <div className="circle-container">
                      <Typography className="circle-text">Sad</Typography>
                      <div style={{ height: 20, width: 400 * `${sad}` }} className="circle sad" />

                    </div>
                    <div className="circle-container">
                      <Typography className="circle-text">Happy</Typography>

                      <div style={{ height: 20, width: 400 * `${happy}` }} className="circle happy" />
                    </div>
                    <div className="circle-container">
                      <Typography className="circle-text">Angry</Typography>
                      <div style={{ height: 20, width: 400 * `${angry}` }} className="circle angry" />
                    </div>
                    <div className="circle-container">
                      <Typography className="circle-text">Fear</Typography>
                      <div style={{ height: 20, width: 400 * `${fear}` }} className="circle fear" />
                    </div>
                    <div className="circle-container">
                      <Typography className="circle-text">Surprise</Typography>
                      <div style={{ height: 20, width: 400 * `${surprise}` }} className="circle surprise" />

                    </div>
                  </div>
                </SimpleAccordion> */}
              </Container>
    //         </div>
    //       </div>
    //     </div>
    //   </div>
    // </div >
  )
}