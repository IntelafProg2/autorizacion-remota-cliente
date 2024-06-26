import 'dart:convert';

import 'package:autorizaciones_remota/Models/UsuarioModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:autorizaciones_remota/Utils/variables_globales.dart' as varGlobales;

class LoginFormProvider extends ChangeNotifier{

  GlobalKey<FormState> formKey = new GlobalKey();

  String email = '';
  String password = '';
  bool _isLoading = false;

  bool verContrasenia = false;
  bool confirmContrasenia = false;


  bool get isLoading => _isLoading;
  set isLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }


  bool isValidForm(){
    this._isLoading = false;
    return formKey.currentState?.validate()??false;
  }
}



Login(String usuario,String clave,String token)async{

  final response = await http.post(
      Uri.parse(varGlobales.urlBase+"Login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String,String>{
            'Usuario': usuario,
            'Clave': clave,
            'Token': token
          }
      )
  );
  final dataJson = UsuarioModel.fromJson(response.body);
  return dataJson;
}


Logout(String usuario, String token) async{
  final storage = new FlutterSecureStorage();
  await http.post(
      Uri.parse(varGlobales.urlBase+"Logout"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },body: jsonEncode(
      <String,String>{
        'usuario': usuario,
        'token': token
      }
  )
  );

  await storage.deleteAll();
  await storage.write(key: 'paginaActual', value: 'Login');
  await storage.write(key: 'token', value: token);


}

Future<String> NombreUsuario () async{
  final storage = new FlutterSecureStorage();
  String usuario = await storage.read(key: 'Usuario')??"";
  return usuario;

}


Future<String> ValidarLogin()async{
  final storage = new FlutterSecureStorage();
  String usuario = await storage.read(key: 'Usuario')??"";

  return usuario;
}

