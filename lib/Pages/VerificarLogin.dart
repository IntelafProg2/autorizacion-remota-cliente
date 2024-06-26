import 'dart:async';


import 'package:autorizaciones_remota/Models/SolicitudesModel.dart';
import 'package:autorizaciones_remota/Pages/LoginPage.dart';
import 'package:autorizaciones_remota/Pages/PrincipalPage.dart';
import 'package:autorizaciones_remota/Pages/RespuestaPage.dart';
import 'package:autorizaciones_remota/Providers/SolicitudesProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VerificarLogin extends StatefulWidget {
  const VerificarLogin({Key? key}) : super(key: key);

  @override
  _VerificarLoginState createState() => _VerificarLoginState();
}

class _VerificarLoginState extends State<VerificarLogin> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = new Duration(milliseconds: 1200);
    return new Timer(duration, route);
  }
  route()async{
    ///validar si hay login
    final storage = new FlutterSecureStorage();
    String usuario = await storage.read(key: 'Usuario')??"";

    if(usuario == ""){
      storage.write(key: 'paginaActual', value: 'Login');
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_ , __ ,___) => LoginPage(),
              transitionDuration: Duration(seconds: 0)
          ));

    }else{

      ///validar si hay una autorizacion sin contestar, regresar a la pagina de respuesta
      String solicitud = await storage.read(key: 'IdSolicitud')??"";

      if(solicitud.length>0){
        storage.write(key: 'paginaActual', value: 'Respuesta');
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (_ , __ ,___) => RespuestaPage(idSoliciutd: int.parse(solicitud)),
                transitionDuration: Duration(seconds: 0)
            )
        );
      }else{
        storage.write(key: 'paginaActual', value: 'Principal');
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (_ , __ ,___) => PrincipalPage(),
                transitionDuration: Duration(seconds: 0)
            )
        );
      }







    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Center(
            child: Image.asset("assets/img/loading_gif.gif")
        ),
      ),
    );
  }
}

