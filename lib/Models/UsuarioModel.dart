// To parse this JSON data, do
//
//     final usuarioModel = usuarioModelFromMap(jsonString);

import 'dart:convert';

class UsuarioModel {
  UsuarioModel({
    required this.usuario,
    required this.clave,
    required this.nombre,
    required this.facturaLibre,
    required this.claveOperacion,
    required this.fechaDesde,
    required this.dias,
    required this.userSql,
    required this.aQuienReporta,
    required this.consigna,
    required this.prestaCnt,
    required this.sucursal,
    required this.impresoraDespachos,
    required this.impresoraEtiquetas,
    required this.secuencia,
    required this.departamento,
    required this.email,
    required this.nivel,
    required this.caja,
  });

  String usuario;
  String clave;
  String nombre;
  String facturaLibre;
  String claveOperacion;
  String fechaDesde;
  double dias;
  String userSql;
  String aQuienReporta;
  String consigna;
  int prestaCnt;
  String sucursal;
  String impresoraDespachos;
  String impresoraEtiquetas;
  int secuencia;
  String departamento;
  String email;
  int nivel;
  String caja;

  factory UsuarioModel.fromJson(String str) => UsuarioModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UsuarioModel.fromMap(Map<String, dynamic> json) => UsuarioModel(
    usuario: json["Usuario"] == null? "": json["Usuario"],
    clave: json["Clave"] == null? "": json["Clave"],
    nombre: json["Nombre"] == null? "": json["Nombre"],
    facturaLibre: json["FacturaLibre"]==null?"":json["FacturaLibre"],
    claveOperacion: json["ClaveOperacion"] == null? "": json["ClaveOperacion"],
    fechaDesde: json["FechaDesde"] == null? "": json["FechaDesde"],
    dias: json["Dias"].toDouble(),
    userSql: json["UserSql"] == null? "": json["UserSql"],
    aQuienReporta: json["AQuienReporta"] == null? "": json["AQuienReporta"],
    consigna: json["Consigna"]==null?"":json["Consigna"],
    prestaCnt: json["PrestaCnt"]==null?0:json["PrestaCnt"],
    sucursal: json["Sucursal"] == null? "": json["Sucursal"],
    impresoraDespachos: json["ImpresoraDespachos"]==null?"":json["ImpresoraDespachos"],
    impresoraEtiquetas: json["ImpresoraEtiquetas"]==null?"":json["ImpresoraEtiquetas"],
    secuencia: json["Secuencia"]==null?0:json["Secuencia"],
    departamento: json["Departamento"] == null? "": json["Departamento"],
    email: json["Email"]==null?"":json["Email"],
    nivel: json["Nivel"]==null?0:json["Nivel"],
    caja: json["Caja"]==null?"":json["Caja"],
  );

  Map<String, dynamic> toMap() => {
    "Usuario": usuario,
    "Clave": clave,
    "Nombre": nombre,
    "Factura_libre": facturaLibre,
    "Clave_Operacion": claveOperacion,
    "Fecha_Desde": fechaDesde,
    "Dias": dias,
    "User_SQL": userSql,
    "A_Quien_Reporta": aQuienReporta,
    "Consigna": consigna,
    "Presta_CNT": prestaCnt,
    "Sucursal": sucursal,
    "Impresora_Despachos": impresoraDespachos,
    "Impresora_Etiquetas": impresoraEtiquetas,
    "Secuencia": secuencia,
    "Departamento": departamento,
    "Email": email,
    "Nivel": nivel,
    "Caja": caja,
  };
}
