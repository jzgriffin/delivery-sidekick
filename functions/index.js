const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

const db = admin.firestore();

const createUser = (user) => {
  return db.collection('users').doc(user.uid)
    .create()
    .catch(console.error);
};

const deleteUser = (user) => {
  return db.collection('users').doc(user.uid)
    .delete()
    .catch(console.error);
};

module.exports = {
  authOnCreate: functions.auth.user().onCreate(createUser),
  authOnDelete: functions.auth.user().onDelete(deleteUser),
};
