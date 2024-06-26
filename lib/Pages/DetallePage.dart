
import 'package:autorizaciones_remota/Models/SolicitudesModel.dart';
import 'package:autorizaciones_remota/Pages/LoginPage.dart';
import 'package:autorizaciones_remota/Pages/PrincipalPage.dart';
import 'package:autorizaciones_remota/Pages/RespuestaPage.dart';
import 'package:autorizaciones_remota/Providers/LoginProvider.dart';
import 'package:autorizaciones_remota/Providers/SolicitudesProvider.dart';
import 'package:autorizaciones_remota/Utils/ConversorFecha.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

class DetallePage extends StatefulWidget {
  int idSolicitud;
  DetallePage({Key? key, required this.idSolicitud}) : super(key: key);

  @override
  _DetallePageState createState() => _DetallePageState();
}

class _DetallePageState extends State<DetallePage> {

  late Future<Solicitud> solicitud;

  @override
  void initState() {
    solicitud = SolicitudPorId(widget.idSolicitud);
    super.initState();
    initializeDateFormatting();

  }



  @override
  Widget build(BuildContext context) {

    String diaLetras = DateFormat('EEEE', 'es').format(DateTime.now());
    String diaNumeros = DateFormat('d', 'es').format(DateTime.now());
    String mes = DateFormat('MMMM', 'es').format(DateTime.now());
    String anio = DateFormat('y', 'es').format(DateTime.now());

    final storage = new FlutterSecureStorage();


    validarRespuestaPendiente()async{
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
      }
    }

    validarRespuestaPendiente();

    return WillPopScope(
      onWillPop: ()async =>false,
      child: Scaffold(

          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Color.fromRGBO(250, 250, 250, 1.0),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[


                Container(
                color: Color.fromRGBO(238, 113, 3, 1.0),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    ///IMAGEN DE INTELAF
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 35,right: 20,top: 25.0,bottom: 20.0),
                          child: const Image(image: AssetImage('assets/img/I-Vector 2.png'),width: 65,),
                        ),
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.only(right: 35.0),
                            child: Icon(Icons.power_settings_new_rounded,color: Colors.white,size: 25),
                          ),
                          onTap: ()async{

                            String usuarioLogout = await storage.read(key: 'Usuario')??"";
                            String tokenLogout = await storage.read(key: 'token')??"";
                            Logout(usuarioLogout,tokenLogout);

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => LoginPage(),
                              ),
                                  (route) => false,
                            );
                          },
                        )
                      ],
                    ),

                    Container(
                      padding: EdgeInsets.only(left: 20.0,top: 15.0,right: 20.0),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: ()async{
                                await storage.write(key: 'paginaActual', value: 'Principal');

                                Navigator.push(context,PageRouteBuilder(
                                  pageBuilder: (context,animation1,animation2)=>DetallePage(idSolicitud: widget.idSolicitud),
                                  transitionsBuilder: (BuildContext context,animation,_,__){
                                    return FadeTransition(opacity: animation,child: PrincipalPage());
                                  },
                                  //transitionDuration: Duration.zero
                                )
                                );
                              },
                              icon: Icon(Icons.arrow_back,color: Colors.white,)),
                          Text("Regresar",style: TextStyle(fontFamily: 'Text-Bold',fontSize: 24,color: Colors.white,letterSpacing: -1.5)),
                        ],
                      ),
                    ),
                    Container(
                      transform: Matrix4.translationValues(0.0, -9.0, 0.0),
                      padding: EdgeInsets.only(left: 35.0,right: 35.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          Divider(
                            color: Colors.white,
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              Icon(Icons.calendar_today_outlined,color: Colors.white,size: 15),
                              SizedBox(width: 10.0),
                              Text("Guatemala, ${diaLetras+" "+diaNumeros+" de "+mes+" de "+anio}",style: TextStyle(fontFamily: 'Text-Regular',fontSize: 12,color: Colors.white,letterSpacing: -0.5)),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      //height: Orientation.portrait==orientation?MediaQuery.of(context).size.height*0.9:MediaQuery.of(context).size.height*2.0,
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 30),
                      transform: Matrix4.translationValues(0, 1, 0),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(250, 250, 250, 1.0),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(60))
                      ),
                      child: FutureBuilder(
                          future: solicitud,
                          builder: (context,AsyncSnapshot<Solicitud> snapshot){

                            if(ConnectionState.active != null && !snapshot.hasData){
                              return Container(
                                height: MediaQuery.of(context).size.height*0.6,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(color: Color.fromRGBO(240, 118, 29, 1.0))
                                      ]
                                  )
                              );
                            }

                            if(ConnectionState.done != null && snapshot.hasError) return Center(child: Text("Error, algo salio mal"));

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(left: 20,right: 20,bottom: 8.0),
                                    child: Text("Detalle de la solicitud #"+snapshot.data!.noSolicitud.toString(),style: TextStyle(fontSize: 22,letterSpacing: -1.5, fontFamily: "Text-Bold"),)
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(left: 20,right: 20,bottom: 15.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Estado: ",style: TextStyle(fontSize: 16,letterSpacing: -1, fontFamily: "Text-Bold",color: Color.fromRGBO(202, 202, 204, 1.0)),),
                                        Text(snapshot.data!.resolucion==0?"Sin contestar":(snapshot.data!.resolucion==1?"Autorizado":"Denegado"),style: TextStyle(fontSize: 16,letterSpacing: -1, fontFamily: "Text-HeavyItalic",color: Color.fromRGBO(202, 202, 204, 1.0)),)
                                      ],
                                    )
                                ),



                                Container(
                                    padding: EdgeInsets.only(left: 20.0,right: 20.0,top: 5),
                                    child:  Text("LA SUCURSAL ${snapshot.data!.nombreCortoSucursal} PIDE AUTORIZACIÓN PARA:",
                                      style: TextStyle(color: Color.fromRGBO(238, 113, 3, 1.0),fontSize: 14,fontFamily: 'Text-Bold',letterSpacing: -0.8),)
                                ),

                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20,top: 10),
                                  child: Text(snapshot.data!.descripcionProblema,
                                      style: TextStyle(fontSize: 14,fontFamily: 'Text-Regular')),
                                ),

                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20,top: 15),
                                  child: Divider(),
                                ),


                                snapshot.data!.observacionSolicitante!=""
                                    ?Container(
                                  padding: EdgeInsets.only(left: 20, right: 20,top: 10),
                                  child: Text("Observaciones: "+snapshot.data!.observacionSolicitante,
                                      style: TextStyle(fontSize: 14,fontFamily: 'Text-Regular')),
                                )
                                    :Container(
                                  padding: EdgeInsets.only(left: 20, right: 20,top: 10),
                                  child: Text("Observaciones: No hay observaciones extras",
                                      style: TextStyle(fontSize: 14,fontFamily: 'Text-Regular',color: Color.fromRGBO(150,150,150, 1))),
                                ),

                                Container(
                                  padding: EdgeInsets.only(left: 20,right: 20,top: 15),
                                  child: Wrap(
                                    children: [
                                      Text("El usuario que lo pide es: ",style: TextStyle(color: Color.fromRGBO(173, 173, 173, 1.0),fontFamily: 'Text-Bold',fontSize: 13,letterSpacing: -0.7)),
                                      Text(snapshot.data!.usuarioSolicitud,style: TextStyle(color: Color.fromRGBO(173, 173, 173, 1.0),fontFamily: 'Text-Bold',fontSize: 13,letterSpacing: -0.7))
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20,right: 20,top: 5),
                                  child: Text("Fecha y hora de la petición ${ConvertirFecha(snapshot.data!.fechaPeticion)}",style: TextStyle(color: Colors.black,letterSpacing: -0.7,fontFamily: 'Text-Bold',fontSize: 13)),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20,right: 20,top: 5),
                                  child: Text("Documento de referencia ${snapshot.data!.referenciaDocumento}",style: TextStyle(color: Colors.black,letterSpacing: -0.7,fontFamily: 'Text-Bold',fontSize: 13)),
                                ),

                                Container(
                                  padding: EdgeInsets.only(right: 30,left: 30,top: 30),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    child: MaterialButton(

                                      height: 70,
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                      minWidth: double.infinity,
                                      disabledColor: Color.fromRGBO(229, 229, 229, 1.0),
                                      color: snapshot.data!.usuarioActivo==""?Colors.black:Color.fromRGBO(229, 229, 229, 1.0),
                                      child: Text(snapshot.data!.usuarioActivo==""?" ME HARÉ CARGO":"YA SE HICIERON CARGO", style: TextStyle(fontFamily:  'Text-Heavy', color: Colors.white,fontSize: 16,letterSpacing: -1.0)),

                                      onPressed: snapshot.data!.usuarioActivo!=""?null:()async{

                                        snapshot.data!.usuarioActivo = await storage.read(key: 'Usuario')??"";
                                        snapshot.data!.fechaAtencion = DateTime.now().toString().split(".")[0];


                                        Solicitud respuesta = await HacerseCargo(snapshot.data!);

                                        await storage.write(key: 'paginaActual', value: 'Respuesta');
                                        await storage.write(key: 'IdSolicitud', value: snapshot.data!.noSolicitud.toString());

                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) => RespuestaPage(idSoliciutd: snapshot.data!.noSolicitud),
                                          ),
                                              (route) => false,
                                        );



                                      },
                                    ),
                                  ),
                                ),


                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(left: 10,right: 10,top: 15),
                                  child: Text(snapshot.data!.usuarioActivo==""?"":"El usuario ${snapshot.data!.usuarioActivo} se esta haciendo cargo",style: TextStyle(color: Color.fromRGBO(173, 173, 173, 1.0))),
                                ),


                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(left: 10,right: 10,top: 5),
                                  child: Text(snapshot.data!.fechaAtencion ==""?""
                                      :"Desde ${ConvertirFecha(snapshot.data!.fechaAtencion)}",style: TextStyle(color: Color.fromRGBO(173, 173, 173, 1.0))),
                                ),

                                SizedBox(height: 40,)



                              ],
                            );
                          }
                      )
                      
                      
                      
                      
                      
                      
                    ),


                  ],
                ),
              )
                    
                    
                    
                    






                  ],
                ),
              ),
            ),
          )

      ),
    );
  }
}
