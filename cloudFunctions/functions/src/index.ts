import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as express from 'express'



//import { response } from 'express';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();
const app = express();


// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//


app.get('/', (req, res) => res.status(200).send('Hey there!'))

// exports.notiApi = functions.https.onRequest(app);

exports.noti = functions.https.onCall(async (data, context) => {

  console.log("started");
  const querySnapshot = await db
    .collection('users')
    .doc(data.to)
    .collection('tokens')
    .get();
  console.log("token gotten");
  const tokens = querySnapshot.docs.map(snap => snap.id);
  console.log("token");
  console.log(tokens);
  console.log(data.type);
  if(data.type === "brim"){
    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: `New Brim From ${data.from}`,
        body: ` ${data.message} `,
        
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      },
      data:{
        "type" : "brim"
       }
    };
    console.log("sending brim");
    return fcm.sendToDevice(tokens, payload);
  }else{
    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: `New Message From ${data.from}`,
        body: ` ${data.message} `,
       
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      },
     data:{
      "type" : "notbrim"
     }
    };
    console.log("sending noti");
   return fcm.sendToDevice(tokens, payload);
  }
  
  
});
// export const sendBrim = functions.database
//   .ref('/brims/{brimId}')
//   .onCreate(async snapshot => {

//     console.log("noti");
//     const brim = snapshot.val();
//     console.log(brim.user);
//     const querySnapshot = await db
//       .collection('users')
//       .doc(brim.user)
//       .collection('tokens')
//       .get();

//     const tokens = querySnapshot.docs.map(snap => snap.id);
//     console.log(tokens);
//     const payload: admin.messaging.MessagingPayload = {
//       notification: {
//         title: 'New Order!',
//         body: ` ${brim.message}`,

//         click_action: 'FLUTTER_NOTIFICATION_CLICK'
//       }
//     };

//     return fcm.sendToDevice(tokens, payload);
//   });

