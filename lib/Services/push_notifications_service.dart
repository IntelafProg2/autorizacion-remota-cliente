import 'dart:async';

import 'package:autorizaciones_remota/Models/MensajesModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//primer plano        = 1
//segundo plano       = 2
//aplicacion cerrada  = 3



class PushNotificationServicie{



  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  static StreamController<MensajeModel> _messageStream = new StreamController.broadcast();
  static Stream<MensajeModel> get messgesStream => _messageStream.stream;


  ///aplicacion en primer plano
  static Future _onMessageHandler(RemoteMessage message)async{
    MensajeModel mensaje = new MensajeModel(message: message, tipoRedireccionamiento: 1);
    _messageStream.add(mensaje);
  }


  ///aplicacion en segundo plano
  static Future _backgroundHandler(RemoteMessage message)async{
    //_messageStream.add(message);
    MensajeModel mensaje = new MensajeModel(message: message, tipoRedireccionamiento: 2);
    _messageStream.add(mensaje);
  }

  ///aplicacion cerrada
  static Future _onMessageOpenApp(RemoteMessage message)async{
    MensajeModel mensaje = new MensajeModel(message: message, tipoRedireccionamiento: 3);
    _messageStream.add(mensaje);
    //_messageStream.add(message);
  }

  static Future initializeApp()async{
    //push notification
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();

    print("el token es: $token");
    final storage = new FlutterSecureStorage();
    await storage.write(key: 'token', value: token);



    ///Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    ///local Notification



  }

  ///por si se desea cancelar el stream
  static closeStream(){
    _messageStream.close();
  }



}