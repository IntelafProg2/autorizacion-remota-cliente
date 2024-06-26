import 'package:flutter/material.dart';

String ConvertirFecha(String fechaInicial){
  //print("Esto trae: $fechaInicial");
  if(fechaInicial=="") {
    return "";
  }else{

    if(fechaInicial.split("T").length!=1){
      String fecha = fechaInicial.split("T")[0];
      String hora = fechaInicial.split("T")[1];

      String fechaOrdenada = fecha.split("-")[2]+"/"+fecha.split("-")[1]+"/"+fecha.split("-")[0];
      String horaCorta = hora.split(".")[0]+" hrs.";


      return fechaOrdenada+" a las "+horaCorta;
    }else{
      String fecha = fechaInicial.split(" ")[0];
      String hora = fechaInicial.split(" ")[1];

      String fechaOrdenada = fecha.split("-")[2]+"/"+fecha.split("-")[1]+"/"+fecha.split("-")[0];


      return fechaOrdenada+" a las "+hora+" hrs.";
    }

  }




}