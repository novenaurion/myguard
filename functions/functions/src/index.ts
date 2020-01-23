import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();


  export const askedForHelp = functions.firestore
  .document('showuser/{notiId}')
  .onCreate(async snapshot => {
    const help = snapshot.data();

    if(help!=null){
        console.log(help.sender);
        const querySnapshot = await db
        .collection ('users')
        .doc(help.showuser)
        .collection('tokens')
        .get();
  
      const tokens = querySnapshot.docs.map(snap => snap.id);
      console.log('token'+tokens)
  
      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: 'Noti from My Guard',
          body: `Message: ${help.message}`,
          click_action: 'FLUTTER_NOTIFICATION_CLICK'
        }
      };
  
      return fcm.sendToDevice(tokens, payload);
    }
    else{
        return null;
    }
   
  });

  
