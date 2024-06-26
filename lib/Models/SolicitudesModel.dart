// To parse this JSON data, do
//
//     final solicitudesModel = solicitudesModelFromMap(jsonString);

import 'dart:convert';

class SolicitudesModel {
  SolicitudesModel({
    required this.solicitud,
  });

  List<Solicitud> solicitud;

  factory SolicitudesModel.fromJson(String str) => SolicitudesModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SolicitudesModel.fromMap(Map<String, dynamic> json) => SolicitudesModel(
    solicitud: List<Solicitud>.from(json["solicitud"].map((x) => Solicitud.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "solicitud": List<dynamic>.from(solicitud.map((x) => x.toMap())),
  };
}

class Solicitud {
  Solicitud({
    required this.noSolicitud,
    required this.fechaPeticion,
    required this.noCaso,
    required this.usuarioActivo,
    required this.sucursal,
    required this.nombreCortoSucursal,
    required this.usuarioSolicitud,
    required this.programa,
    required this.fechaAtencion,
    required this.fechaResolucion,
    required this.resolucion,
    required this.observacionSolicitante,
    required this.observacionSupervisor,
    required this.referenciaDocumento,
    required this.fechaUtilizacion,
    required this.descripcionProblema
  });

  int noSolicitud;
  String fechaPeticion;
  int noCaso;
  String usuarioActivo;
  String sucursal;
  String nombreCortoSucursal;
  String usuarioSolicitud;
  String programa;
  String fechaAtencion;
  String fechaResolucion;
  int resolucion;
  String observacionSolicitante;
  String observacionSupervisor;
  String referenciaDocumento;
  String fechaUtilizacion;
  String descripcionProblema;

  factory Solicitud.fromJson(String str) => Solicitud.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Solicitud.fromMap(Map<String, dynamic> json) => Solicitud(
    noSolicitud: json["NoSolicitud"],
    fechaPeticion: json["FechaPeticion"],
    noCaso: json["NoCaso"],
    usuarioActivo: json["UsuarioActivo"]==null?"":json["UsuarioActivo"],
    sucursal: json["Sucursal"]??"",
    nombreCortoSucursal: json["NombreCortoSucursal"]??"",
    usuarioSolicitud: json["UsuarioSolicitud"]??"",
    programa: json["Programa"]??"",
    fechaAtencion: json["FechaAtencion"]==null?"":json["FechaAtencion"],
    fechaResolucion: json["FechaResolucion"]==null?"":json["FechaResolucion"],
    resolucion: json["Resolucion"],
    observacionSolicitante: json["ObservacionSolicitante"]??"",
    observacionSupervisor: json["ObservacionSupervisor"]??"",
    referenciaDocumento: json["ReferenciaDocumento"]??"",
    fechaUtilizacion: json["FechaUtilizacion"]==null?"":json["FechaUtilizacion"],
    descripcionProblema: json["DescripcionProblema"]??""
  );

  Map<String, dynamic> toMap() => {
    "NoSolicitud": noSolicitud,
    "FechaPeticion": fechaPeticion,
    "NoCaso": noCaso,
    "UsuarioActivo": usuarioActivo,
    "Sucursal": sucursal,
    "NombreCortoSucursal": nombreCortoSucursal,
    "UsuarioSolicitud": usuarioSolicitud,
    "Programa": programa,
    "FechaAtencion": fechaAtencion,
    "FechaResolucion": fechaResolucion,
    "Resolucion": resolucion,
    "ObservacionSolicitante": observacionSolicitante,
    "ObservacionSupervisor": observacionSupervisor,
    "ReferenciaDocumento": referenciaDocumento,
    "FechaUtilizacion": fechaUtilizacion,
    "DescripcionProblema": descripcionProblema
  };
}
