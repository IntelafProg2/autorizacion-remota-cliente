

import 'package:autorizaciones_remota/Models/SolicitudesModel.dart';
import 'package:autorizaciones_remota/Providers/SolicitudesProvider.dart';
import 'package:flutter/material.dart';

class UiSolicitudesProvider extends ChangeNotifier {
  List<Solicitud> listadoSinResolver = [];
  List<Solicitud> listadoResueltos = [];

  ///Sin resolver

  cargarSinResolver()async{
    SolicitudesModel solicitudes = await CargarSolicitudesSinContestar();
    listadoSinResolver = solicitudes.solicitud;
    notifyListeners();
  }

  agregarSolicitudSinResolver(Solicitud solicitud) {
    listadoSinResolver.add(solicitud);
    notifyListeners();
  }

  asignarListadoSinResolver(List<Solicitud> solicitudes){
    listadoSinResolver = solicitudes;
    notifyListeners();
  }


  ///Resueltas

  cargarResueltas()async{
    SolicitudesModel solicitudes = await CargarSolicitudesResueltas();
    listadoResueltos = solicitudes.solicitud;
    notifyListeners();
  }


  agregarSolicitudResuelta(Solicitud solicitud){
    listadoResueltos.add(solicitud);
    notifyListeners();
  }

  asignarListadoResueltas(List<Solicitud> solicitudes){
    listadoResueltos = solicitudes;
    notifyListeners();
  }


}