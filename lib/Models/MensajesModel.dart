import 'package:firebase_messaging/firebase_messaging.dart';

class MensajeModel {

  MensajeModel({
    required this.message,
    required this.tipoRedireccionamiento
});

  final RemoteMessage message;
  final int tipoRedireccionamiento;


}