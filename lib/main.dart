
import 'package:autorizaciones_remota/Models/SolicitudesModel.dart';
import 'package:autorizaciones_remota/Pages/DetallePage.dart';
import 'package:autorizaciones_remota/Pages/LoginPage.dart';
import 'package:autorizaciones_remota/Pages/PrincipalPage.dart';
import 'package:autorizaciones_remota/Pages/RespuestaPage.dart';
import 'package:autorizaciones_remota/Pages/VerificarLogin.dart';
import 'package:autorizaciones_remota/Providers/ui_solicitudes_provider.dart';
import 'package:autorizaciones_remota/Services/push_notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  ///push notification
  await PushNotificationServicie.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black, // navigation bar color
    statusBarColor: Color.fromRGBO(238, 113, 3, 1.0), // status bar color
  ));

  ///local notification
  ///await LocalNotificationService().init();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{







  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();



    var androidInitialize = new AndroidInitializationSettings('icono_notificacion');
    var initializationSettings = new InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,onDidReceiveNotificationResponse: onSelectNotification);




    PushNotificationServicie.messgesStream.listen((message) {

      print(message.message.toString());




      if(message.tipoRedireccionamiento == 1){
        Solicitud nuevaSolicitud = new Solicitud(
            noSolicitud: int.parse(message.message.data['NoSolicitud']),
            fechaPeticion: message.message.data['FechaPeticion']??"",
            noCaso: int.parse(message.message.data['NoCaso']),
            usuarioActivo: message.message.data['UsuarioActivo']??"",
            sucursal: message.message.data['Sucursal']??"",
            nombreCortoSucursal: message.message.data['NombreCortoSucursal']??"",
            usuarioSolicitud: message.message.data['UsuarioSolicitud']??"",
            programa: message.message.data['Programa']??"",
            fechaAtencion: message.message.data['FechaAtencion']??"",
            fechaResolucion: message.message.data['FechaResolucion']??"",
            resolucion: int.parse(message.message.data['Resolucion']),
            observacionSolicitante: message.message.data['ObservacionSolicitante']??"",
            observacionSupervisor: message.message.data['ObservacionSupervisor']??"",
            referenciaDocumento: message.message.data['ReferenciaDocumento']??"",
            fechaUtilizacion: message.message.data['FechaUtilizacion']??"",
            descripcionProblema: message.message.data['DescripcionProblema']??""
        );

        _mostrarLocalNotification(nuevaSolicitud,message.message.notification!.title??"Nueva solicitud de autorizacion");




        ///refrescar pantalla inicio con nueva notificacion
        _refrescarPantalla();

      }else if(message.tipoRedireccionamiento == 2){
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (BuildContext context) => DetallePage(idSolicitud: int.parse(message.message.data["NoSolicitud"])),
          ),
        );

      }else if(message.tipoRedireccionamiento == 3){

        if(message.message.data["NoSolicitud"] != null){
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (BuildContext context) => DetallePage(idSolicitud: int.parse(message.message.data["NoSolicitud"])),
            ),
          );
        }


      }



    });

  }



  Future onSelectNotification(NotificationResponse notificationResponse) async{

    if(notificationResponse.payload!.isNotEmpty){
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (BuildContext context) => DetallePage(idSolicitud: int.parse(notificationResponse.payload!)),
        ),
      );
    }


  }


  Future _mostrarLocalNotification(Solicitud solicitud,String titulo)async{
    var androidDetails = new AndroidNotificationDetails(
      "fcm_default_channel",
      "autenticacionesName",
      channelDescription: 'channel description',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("intelaf_sound_bells_final"),
      enableVibration: true,
      enableLights: true,
      priority: Priority.max,
      styleInformation: BigTextStyleInformation('')
    );

    var gerealNotificationDetails = new NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
        solicitud.noSolicitud,
        titulo,
        solicitud.descripcionProblema,
        gerealNotificationDetails,
        payload: solicitud.noSolicitud.toString()
    );
  }

  _refrescarPantalla()async{
    final storage = new FlutterSecureStorage();
    String pagina = await storage.read(key: 'paginaActual')??"";

    if(pagina=="Principal"){
      navigatorKey.currentState?..pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context,animation1,animation2)=>PrincipalPage(),
            transitionsBuilder: (BuildContext context,animation,_,__){
              return FadeTransition(opacity: animation,child: PrincipalPage());
            },
            //transitionDuration: Duration.zero
          )
      );

    }

  }


  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> UiSolicitudesProvider(),lazy: true),
      ],
      child: MaterialApp(
        title: 'Autorizaciones remotas',
        debugShowCheckedModeBanner: false,
        initialRoute: 'preLogin',
        navigatorKey: navigatorKey,
        theme: ThemeData(
            accentColor: Color.fromRGBO(248, 147, 31, 1.0)
        ),
        routes: {
          'preLogin': (_)=> VerificarLogin(),
          'login': (_)=> LoginPage(),
          'principal': (_)=> PrincipalPage(),
          'detalle': (_)=> DetallePage(idSolicitud: 0),
          'respuesta': (_)=> RespuestaPage(idSoliciutd: 0)
        },


      ),
    );
  }

}

