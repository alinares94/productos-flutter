

// SHA1: 5E:5C:CD:F1:D3:DE:24:F3:97:7A:A0:A9:F5:0D:93:7B:19:C1:4D:CA
// Token: e9CVJbFiSkOqICJ4t5JZQd:APA91bFuwSbzThyaSNU0svWF9uEl4n_5eYHho2WBDN7CBRXWxCh-szSdAOhp_AcsEAEaJW-kNbi_rsTIVtG8H3GA2I8HnOe_vUi18BkB2CfLmay2pcV_-RBq4qJnvfvFDK8H2YjTO2y_

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushService {

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  static Future _onBackgroundHandler( RemoteMessage message ) async {
    print('Background Handler ${ message.messageId }');
  }

  static Future _onMessagedHandler( RemoteMessage message ) async {
    print('Message Handler ${ message.messageId }');
  }

  static Future _onOpenHandler( RemoteMessage message ) async {
    print('Open Handler ${ message.messageId }');
  }

  static Future initializeApp() async {
    //Push notification
    await Firebase.initializeApp();
    token = await messaging.getToken();
    print('Token: $token');

    //Handlers
    FirebaseMessaging.onBackgroundMessage( _onBackgroundHandler );
    FirebaseMessaging.onMessage.listen( _onMessagedHandler );
    FirebaseMessaging.onMessageOpenedApp.listen( _onOpenHandler );

    //Local notification
    
  }
}