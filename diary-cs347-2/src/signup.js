import { db, auth } from "./firebase";
import { createUserWithEmailAndPassword, updateProfile } from 'firebase/auth';
import { Text, TouchableOpacity, TextInput, StyleSheet } from 'react-native';
import { useState } from 'react';
import { Link } from 'react-router-dom';
import { addDoc, collection } from "firebase/firestore";
import { useNavigate } from 'react-router-dom';

export default function Signup() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [username, setUsername] = useState('');
  const [error, setError] = useState('');
  const navigate = useNavigate();

  const createAccount = async () => {
    try {
      if (password === confirmPassword) {
        await createUserWithEmailAndPassword(auth, email, password);
        await updateProfile(auth.currentUser, { displayName: username });
      } else {
        setError("Passwords do not match");
      }
    } catch (e) {
      if (e.code === 'auth/email-already-in-use') {
        setError("An account with this email already exists");
      } else if (e.code === 'auth/weak-password') {
        setError("Password must be at least 6 characters");
      } else {
        console.log(e);
        setError("There was a problem creating your account");
      }
    }
    await addDoc(collection(db, "Users"), {
      User: username,
      entryDates: []
    });
    navigate('/');
  };

  return (
    <div style={styles.container}>
      <div style={styles.inputContainer}>
        <Text>Username</Text>
        <TextInput
          value={username}
          onChangeText={setUsername}
          placeholder="Enter a display name"
          style={styles.input}
        />
      </div>
      <div style={styles.inputContainer}>
        <Text>Email</Text>
        <TextInput
          value={email}
          onChangeText={setEmail}
          keyboardType="email-address"
          placeholder='Enter email address'
          style={styles.input}
        />
      </div>
      <div style={styles.inputContainer}>
        <Text>Password</Text>
        <TextInput
          value={password}
          onChangeText={setPassword}
          secureTextEntry
          placeholder='Enter password'
          style={styles.input}
        />
      </div>
      <div style={styles.inputContainer}>
        <Text>Confirm Password</Text>
        <TextInput
          value={confirmPassword}
          onChangeText={setConfirmPassword}
          secureTextEntry
          placeholder='Confirm password'
          style={styles.input}
        />
      </div>
      <div style={styles.inputContainer}><Text style={{ color: 'red' }}>{error}</Text></div>
        <TouchableOpacity onPress={createAccount} disabled={!email || !password || !confirmPassword || !username} style={styles.button}>
          <Text style={styles.caption}>Create Account</Text>
        </TouchableOpacity>
      <Link to="/" style={{ textDecoration: 'none' }}>
        <TouchableOpacity style={styles.button}>
          <Text style={styles.caption}>Sign in to existing account</Text>
        </TouchableOpacity>
      </Link>
    </div>
  );
}

const styles = StyleSheet.create({
  container: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    flexDirection: 'column',
    marginTop: 300
  },

  button: {
    position: 'relative',
    padding: 8,
    marginTop: 5,
    width: 175,
    fontSize: 16,
    lineHeight: 20,
    textAlign: 'center',
    letterSpacing: 1,
    borderRadius: 10,
    backgroundColor: '#1976D2'
  },

  input: {
    marginBottom: 5,
    padding: 5,
    width: 175,
    backgroundColor: "#D3D3D3",
    lineHeight: 20,
    borderRadius: 10
  },

  caption: {
    color: '#fff',
  },

  inputContainer: {
    display: 'flex',
    flexDirection: 'column'
  }
});