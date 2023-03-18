import React, { useState } from 'react';
import { onAuthStateChanged } from 'firebase/auth';
import { auth } from "./firebase"
import { Route, Routes } from 'react-router-dom';
import Signup from './signup';
import Login from './login';
import Ambient from './ambient';
import JournalEntry from './JournalEntry';
import Calendar from './Calendar';
import Navbar from './navbar';

export default function App() {
  const [loggedIn, setLoggedIn] = useState(false);

  onAuthStateChanged(auth, (user) => {
    if (user) {
      setLoggedIn(true);
    } else {
      setLoggedIn(false);
    }
  });

  if (loggedIn) {
    return (
      <div className="app">
        <Navbar />
        <div className='container'>
          <Routes>
            <Route path="/" element={<Ambient />} />
            <Route path="/entry" element={<JournalEntry />} />
            <Route path="/history" element={<Calendar />} />
          </Routes>
        </div>
      </div>
    );
  } else {
    return (
      <div className='app'>
        <div className='container'>
          <Routes>
            <Route path="/" element={<Login />} />
            <Route path="/signup" element={<Signup />} />
          </Routes>
        </div>
      </div>
    );
  }
}