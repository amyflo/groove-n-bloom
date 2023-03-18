import { initializeApp } from 'firebase/app';
import { getFirestore} from 'firebase/firestore';
import { getAuth } from 'firebase/auth';
import { getDatabase, connectDatabaseEmulator } from "firebase/database";

const firebaseConfig = {
    apiKey: "AIzaSyBEpa8A5IG5yMjdragAoqyFAeQP_kN0tKI",
    authDomain: "cs347-93bf2.firebaseapp.com",
    projectId: 'cs347-93bf2',
    storageBucket: "cs347-93bf2.appspot.com",
    messagingSenderId: "58685331927",
    appId: "1:58685331927:web:a08d0173aaedd48b0e5392"
};

const app = initializeApp(firebaseConfig);

if (location.hostname === "localhost") {
    // Point to the RTDB emulator running on localhost.
    connectDatabaseEmulator(getDatabase(), "localhost", 9000);
}

export const auth = getAuth(app);
export const db = getFirestore(app);
