import { createApp } from 'vue'
import App from './App.vue'

const wsProtocol = window.location.protocol === 'https:' ? 'wss' : 'ws';

const apiUrl = process.env.VUE_APP_API_URL || 'http://localhost:8080';
const wsUrl = `${wsProtocol}://${apiUrl.split('//')[1]}`;

// Create WebSocket connection
const socket = new WebSocket(wsUrl);

// WebSocket event listeners
socket.onopen = () => {
    console.log('WebSocket Connection Opened');
    socket.send('Hello Server!');
};

socket.onerror = (error) => {
    console.error('WebSocket Error:', error);
};

socket.onmessage = (event) => {
    console.log('WebSocket Message:', event.data);
};

// Create Vue application
const app = createApp(App);

// Provide the socket instance to the whole app
app.provide('socket', socket);

app.mount('#app');
