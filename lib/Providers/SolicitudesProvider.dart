
import 'package:autorizaciones_remota/Models/SolicitudesModel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:autorizaciones_remota/Utils/variables_globales.dart' as varGlobales;

Future<SolicitudesModel> CargarSolicitudesSinContestar()async{

  final storage = new FlutterSecureStorage();
  String usuario = await storage.read(key: 'Usuario')??"";
  final response = await http.get(
      Uri.parse(varGlobales.urlBase+"solicitud/noAtendidas/$usuario"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }
  );
  final dataJson = SolicitudesModel.fromJson(response.body);
  return dataJson;
}

Future<SolicitudesModel> CargarSolicitudesResueltas()async{

  final storage = new FlutterSecureStorage();
  String usuario = await storage.read(key: 'Usuario')??"";
  final response = await http.get(
      Uri.parse(varGlobales.urlBase+"solicitud/atendidas/$usuario"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }
  );
  final dataJson = SolicitudesModel.fromJson(response.body);
  return dataJson;
}

Future<Solicitud> SolicitudPorId(int idSolicitud)async{
  final response = await http.get(
      Uri.parse(varGlobales.urlBase+"solicitud/$idSolicitud"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }
  );
  final dataJson = Solicitud.fromJson(response.body);
  return dataJson;
}



HacerseCargo(Solicitud solicitud)async{
  final response = await http.put(
      Uri.parse(varGlobales.urlBase+"solicitud/respuesta"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: solicitud.toJson()
  );
  print(response.body);
  final dataJson = Solicitud.fromJson(response.body);
  return dataJson;
}
