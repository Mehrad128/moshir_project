importScripts('https://www.gstatic.com/firebasejs/10.11.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.11.1/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyD1vl-OjP1aKfp2j44yT8_31iWrt7bJWdY",
  authDomain: "moshir-bb5ff.firebaseapp.com",
  projectId: "moshir-bb5ff",
  storageBucket: "moshir-bb5ff.firebasestorage.app",
  messagingSenderId: "848364028034",
  appId: "1:848364028034:web:a0596b73cfafc0a9b9749b"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('📨 پیام پس‌زمینه:', payload);
  const notificationTitle = payload.notification?.title || 'اعلان جدید';
  const notificationOptions = {
    body: payload.notification?.body || 'متن پیام',
    icon: '/icons/Icon-192.png'
  };
  self.registration.showNotification(notificationTitle, notificationOptions);
});