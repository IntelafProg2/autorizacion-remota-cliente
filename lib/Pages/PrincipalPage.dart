
import 'package:autorizaciones_remota/Models/SolicitudesModel.dart';
import 'package:autorizaciones_remota/Pages/DetallePage.dart';
import 'package:autorizaciones_remota/Pages/LoginPage.dart';
import 'package:autorizaciones_remota/Providers/LoginProvider.dart';
import 'package:autorizaciones_remota/Providers/ui_solicitudes_provider.dart';
import 'package:autorizaciones_remota/Utils/ConversorFecha.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

class PrincipalPage extends StatefulWidget {
  const PrincipalPage({Key? key}) : super(key: key);

  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> with SingleTickerProviderStateMixin{
  final storage = new FlutterSecureStorage();
  String nombreUsuario="";
  late TabController tabController;

  final PageController controllerPageView = PageController(initialPage: 0);

  cargarDatosUsuario()async{
    nombreUsuario = await storage.read(key: 'Usuario')??"";

  }



  @override
  void initState() {
    cargarDatosUsuario();
    tabController = TabController(length: 2,vsync: this,initialIndex: 0);
    initializeDateFormatting();



    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      final ordenesService = Provider.of<UiSolicitudesProvider>(context,listen: false);
      ordenesService.cargarResueltas();
      ordenesService.cargarSinResolver();
    });

    super.initState();

  }




  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final solicitudesProvider = Provider.of<UiSolicitudesProvider>(context);

    Future<Null> refreshList() async{
      solicitudesProvider.cargarSinResolver();
      solicitudesProvider.cargarResueltas();
    }

    String diaLetras    = DateFormat('EEEE', 'es').format(DateTime.now());
    String diaNumeros   = DateFormat('d', 'es').format(DateTime.now());
    String mes          = DateFormat('MMMM', 'es').format(DateTime.now());
    String anio         = DateFormat('y', 'es').format(DateTime.now());




    return Scaffold(

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
                        padding: EdgeInsets.only(left: 35.0,top: 15.0,right: 35.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            FutureBuilder(
                                future: NombreUsuario(),
                                builder: (context,AsyncSnapshot snapshot){
                                  if(ConnectionState.active != null && !snapshot.hasData){
                                    return Container(
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator(color: Color.fromRGBO(240, 118, 29, 1.0),)
                                            ]
                                        )
                                    );
                                  }

                                  if(ConnectionState.done != null && snapshot.hasError) return Center(child: Text("Error, algo salio mal"));

                                  return Text("Hola, ${snapshot.data}",style: TextStyle(fontFamily: 'Text-Bold',fontSize: 24,color: Colors.white,letterSpacing: -1.5));
                                }
                            ),

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
                      SizedBox(height: 25),
                      OrientationBuilder(builder: (BuildContext context,orientation){
                        return Container(
                          //height: Orientation.portrait==orientation?MediaQuery.of(context).size.height*0.9:MediaQuery.of(context).size.height*2.0,
                          width: double.infinity,
                          padding: EdgeInsets.only(top: 30),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(250, 250, 250, 1.0),
                              borderRadius: BorderRadius.only(topRight: Radius.circular(60))
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 22),
                                child: StatefulBuilder(
                                  builder: (BuildContext context, StateSetter myState){
                                    return TabBar(
                                        controller: tabController,
                                        indicatorColor: Color.fromRGBO(19, 180, 188, 1.0),
                                        onTap: (int index){
                                          myState(() {

                                          });
                                        },

                                        tabs: [
                                          Container(
                                            padding: EdgeInsets.only(bottom: 15),
                                            child: Text("Sin resolver",style: TextStyle(color: Colors.black,fontFamily: 'Text-Semibold',fontSize: 12,letterSpacing: -0.5)),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(bottom: 15),
                                            child: Text("Resueltas",style: TextStyle(color: Colors.black,fontFamily: 'Text-Semibold',fontSize: 12)),
                                          ),
                                        ]
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 20,),

                              Container(
                                height: MediaQuery.of(context).size.height*0.6,
                                width: double.infinity,
                                child: TabBarView(
                                  controller: tabController,
                                  children: [

                                    solicitudesProvider.listadoSinResolver.length>=1
                                    ?Container(
                                      width: double.infinity,
                                      height: MediaQuery.of(context).size.height*0.65,
                                      child: RefreshIndicator(
                                        onRefresh: refreshList,
                                        backgroundColor: Color.fromRGBO(240, 118, 29, 1),
                                        color: Colors.white,
                                        child: ListView.builder(
                                          itemCount: solicitudesProvider.listadoSinResolver.length,
                                          itemBuilder: (BuildContext context,index){

                                            if(index==solicitudesProvider.listadoSinResolver.length-1){
                                              return Column(
                                                children: [
                                                  CardsPendientes(solicitud: solicitudesProvider.listadoSinResolver[index]),
                                                  SizedBox(height: 20.0)
                                                ],
                                              );

                                            }else{
                                              return CardsPendientes(solicitud: solicitudesProvider.listadoSinResolver[index]);
                                            }


                                          },
                                        ),
                                      ),
                                    ):
                                    Container(
                                      width: double.infinity,
                                      height: MediaQuery.of(context).size.height*0.65,
                                      alignment: Alignment.center,
                                      child: RefreshIndicator(
                                        onRefresh: refreshList,
                                        backgroundColor: Color.fromRGBO(240, 118, 29, 1),
                                        color: Colors.white,
                                        child: ListView.builder(

                                          itemCount: 1,
                                          itemBuilder: (BuildContext context,index){


                                            return Container(
                                                width: double.infinity,
                                                height: MediaQuery.of(context).size.height*0.60,
                                                alignment: Alignment.center,
                                                child: Text("No hay ningún caso por resolver.",style: TextStyle(fontFamily: 'Text-Regular',letterSpacing: -1,color: Color.fromRGBO(202, 202, 204, 1.0)))
                                            );

                                          },
                                        ),
                                      ),
                                    ),




                                    solicitudesProvider.listadoResueltos.length>=1
                                        ?Container(
                                      width: double.infinity,
                                      height: MediaQuery.of(context).size.height*0.65,
                                      child: RefreshIndicator(
                                        onRefresh: refreshList,
                                        backgroundColor: Color.fromRGBO(240, 118, 29, 1),
                                        color: Colors.white,
                                        child: ListView.builder(
                                          itemCount: solicitudesProvider.listadoResueltos.length,
                                          itemBuilder: (BuildContext context,index){

                                            if(index==solicitudesProvider.listadoResueltos.length-1){
                                              return Column(
                                                children: [
                                                  CardsPendientes(solicitud: solicitudesProvider.listadoResueltos[index]),
                                                  SizedBox(height: 20.0)
                                                ],
                                              );

                                            }else{
                                              return CardsPendientes(solicitud: solicitudesProvider.listadoResueltos[index]);
                                            }


                                          },
                                        ),
                                      ),
                                    ):
                                    Container(
                                        width: double.infinity,
                                        height: MediaQuery.of(context).size.height*0.6,
                                        child: Center(
                                          child: Text("No hay ningún caso por resolver.",style: TextStyle(fontFamily: 'Text-Regular',letterSpacing: -1,color: Color.fromRGBO(202, 202, 204, 1.0))),
                                        )
                                    ),


                                  ],
                                ),
                              )














                            ],
                          ),
                        );
                      }),


                    ],
                  ),
                )




              ],
            ),
          ),
        ),
      ),

    );
  }
}


class CardsPendientes extends StatefulWidget {
  Solicitud solicitud;
  CardsPendientes({Key? key,required this.solicitud}) : super(key: key);

  @override
  _CardsPendientesState createState() => _CardsPendientesState();
}

class _CardsPendientesState extends State<CardsPendientes> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        InkWell(
          onTap: (){

          },
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 300,minHeight: 50),
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
              //padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
              decoration: BoxDecoration(
                color: widget.solicitud.resolucion==0?Color.fromRGBO(229, 229, 229, 1.0):(widget.solicitud.resolucion==1?Color.fromRGBO(52, 199, 89, 1.0):Color.fromRGBO(255, 59, 48, 1.0)),
                borderRadius: BorderRadius.circular(5),
                //border: Border.all(color: Colors.white)
              ),
              child: Container(

                margin: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Stack(
                  children: [
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Text("LA SUCURSAL ${widget.solicitud.nombreCortoSucursal}, SOLICITA:",style: TextStyle(fontFamily: 'Text-Bold',color: Color.fromRGBO(240, 118, 29, 1.0),fontSize: 12.0)),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${widget.solicitud.observacionSolicitante}", maxLines: 1,style: TextStyle(fontSize: 11,color: Colors.black,fontFamily: 'Text-Regular')),
                          Text("Fecha de la petición - ${ConvertirFecha(widget.solicitud.fechaPeticion)}",style: TextStyle(fontSize: 11,fontFamily: 'Text-Regular')),
                          SizedBox(height: 10)
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios,size: 15,color: Color.fromRGBO(200, 200, 200, 1.0)),
                      onTap: ()async{

                        print(widget.solicitud.toJson());

                        final storage = new FlutterSecureStorage();
                        await storage.write(key: 'paginaActual', value: 'Detalle');

                        Navigator.push(context,PageRouteBuilder(
                          pageBuilder: (context,animation1,animation2)=>PrincipalPage(),
                          transitionsBuilder: (BuildContext context,animation,_,__){
                            return FadeTransition(opacity: animation,child: DetallePage(idSolicitud: widget.solicitud.noSolicitud,));
                          },
                          //transitionDuration: Duration.zero
                        )
                        );
                      },
                    ),
                    //SizedBox(height: 8)

                    Positioned(
                      child: Text("ID "+widget.solicitud.noSolicitud.toString(),
                          style: TextStyle(fontSize: 10,color: Color.fromRGBO(170, 170, 170, 1.0),fontFamily: "Text-Semibold")),
                      right: 5,
                      bottom: 5,
                    ),

                  ],
                ),
              ),

            ),
          ),
        ),
      ],
    );
  }
}





