import { signInWithEmailAndPassword } from 'firebase/auth';
import { Text, TouchableOpacity, TextInput, StyleSheet } from 'react-native';
import { auth } from "./firebase";
import { Link } from 'react-router-dom';
import { useState } from 'react';

export default function Login() {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');
  
    const loginUser = async () => {
      try {
        await signInWithEmailAndPassword(auth, email, password);
      } catch (e) {
        if (e.code === 'auth/invalid-email' || e.code === 'auth/wrong-password') {
          setError('Incorrect email or password');
        } else {
          setError("There was a problem with your request");
        }
      }
    };
  
    return (
      <div style={styles.container}>
        <div style={styles.inputContainer}>
        <Text style={{ alignSelf: 'flex-start', marginBottom: 2 }}>Email</Text>
        <TextInput
          value={email}
          onChangeText={setEmail}
          keyboardType="email-address"
          placeholder='Enter email address'
          style={styles.input}
        />
        </div>
        <div style={styles.inputContainer}>
        <Text style={{ marginBottom: 2 }}>Password</Text>
        <TextInput
          value={password}
          onChangeText={setPassword}
          secureTextEntry
          placeholder='Enter password'
          style={styles.input}
        />
        </div>
        <div style={styles.inputContainer}><Text style={{ color: 'red' }}>{error}</Text></div>
        <TouchableOpacity onPress={loginUser} disabled={!email || !password} style={styles.button}>
          <Text style={styles.caption}>Login</Text>
        </TouchableOpacity>
        <Link to="/signup" style={{ textDecoration: 'none' }}>
          <TouchableOpacity style={styles.button}>
            <Text style={styles.caption}>Create an account</Text>
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