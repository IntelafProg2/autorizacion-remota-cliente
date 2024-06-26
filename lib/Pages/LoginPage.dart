import 'dart:ui';

import 'package:autorizaciones_remota/Models/UsuarioModel.dart';
import 'package:autorizaciones_remota/Pages/PrincipalPage.dart';
import 'package:autorizaciones_remota/Providers/LoginProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

TextEditingController usuario = new TextEditingController();
TextEditingController clave = new TextEditingController();

bool _checkPassword = false;
bool _ocultarPassword = true;


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(240, 118, 29, 1.0),
        title: Text("Login"),
      ),*/
      body: SafeArea(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          child: ChangeNotifierProvider(create: (_) => LoginFormProvider(),child: FormularioLogin(),
          ),
        ),
      )

    );
  }
}


class FormularioLogin extends StatefulWidget {
  const FormularioLogin({Key? key}) : super(key: key);

  @override
  _FormularioLoginState createState() => _FormularioLoginState();
}

class _FormularioLoginState extends State<FormularioLogin> {

  final storage = new FlutterSecureStorage();


  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Form(
      key: loginForm.formKey,
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
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 20,right: 20,top: 5.0),
                    child: const Image(image: AssetImage('assets/img/logo_naranja.jpg'),width: 180,),
                  ),


                  Container(
                    padding: EdgeInsets.only(left: 35.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text("Autorizaciones",style: TextStyle(fontFamily: 'Text-Bold',fontSize: 36,color: Colors.white,letterSpacing: -2.5)),
                        Text("Remotas",style: TextStyle(fontFamily: 'Text-Bold',fontSize: 36,color: Colors.white,letterSpacing: -2.5)),
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  OrientationBuilder(builder: (BuildContext context,orientation){
                    return Container(
                      //height: Orientation.portrait==orientation?MediaQuery.of(context).size.height*0.9:MediaQuery.of(context).size.height*2.0,
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 50),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(60))
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                              padding: EdgeInsets.only(left: 35,right: 35),
                              child: Text("INICIAR SESIÓN",style: TextStyle(fontSize: 18,letterSpacing: -1, fontFamily: "Text-Heavy"),)
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 35,right: 35,top: 15),
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(250, 250, 250, 1),
                                    borderRadius: new BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 15, right: 15, top: 8,bottom: 8),
                                      child: TextFormField(
                                          keyboardType:  TextInputType.text,
                                          controller: usuario,
                                          cursorColor: Color.fromRGBO(240, 118, 29, 1.0),
                                          decoration: InputDecoration(
                                            labelStyle: TextStyle(fontFamily: 'Text-Regular'),
                                              border: InputBorder.none,
                                              hintText: 'Ingresa tu nombre de usuario',
                                              hintStyle: TextStyle(fontSize: 12,fontFamily: 'Text-Light'),
                                              prefixIcon: Icon(Icons.person_outline_sharp,color: Color.fromRGBO(214, 214, 215, 1),)
                                          ),
                                          onChanged: (value)=>loginForm.email=value,
                                          /*
                                          validator: (value){
                                            String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                            RegExp regExp  = new RegExp(pattern);
                                            return regExp.hasMatch(value?? '')?null:'No es un formato de Email';
                                          }*/
                                      )
                                  )
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 35,right: 35,top: 15),
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(250, 250, 250, 1),
                                    borderRadius: new BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 15, right: 15, top: 8,bottom: 8),
                                      child: TextFormField(
                                        obscureText: _ocultarPassword,
                                        controller: clave,
                                        cursorColor: Color.fromRGBO(240, 118, 29, 1.0),
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Ingresa tu clave',
                                            hintStyle: TextStyle(fontSize: 12,fontFamily: 'Text-Light'),
                                            prefixIcon: GestureDetector(
                                              onTap: (){

                                                setState((){
                                                  loginForm.verContrasenia = !loginForm.verContrasenia;
                                                  _checkPassword = !_checkPassword;
                                                  _ocultarPassword = !_ocultarPassword;

                                                });
                                              },
                                              child: (loginForm.verContrasenia == false)? Icon(Icons.lock_outline,color: Color.fromRGBO(214, 214, 215, 1)):Icon(Icons.lock_open,color: Color.fromRGBO(214, 214, 215, 1)),
                                            )
                                        ),
                                        onChanged: (value)=> loginForm.password=value,
                                        validator: (value){
                                          if(value !=null && value.length>=1) return null;
                                          return 'La contraseña tiene que ser de al menos 6 caracteres';
                                        },
                                      )
                                  )
                              )
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 35,right: 35,top: 35),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              child: MaterialButton(

                                height: 60,
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                minWidth: double.infinity,

                                color: Colors.black,
                                child: Text("INGRESAR", style: TextStyle(fontFamily:  'Text-Heavy', color: Colors.white,fontSize: 16,letterSpacing: -1.0)),

                                onPressed: loginForm.isLoading? null: ()async{

                                  loginForm.isLoading=true;
                                  FocusScope.of(context).unfocus();
                                  if(!loginForm.isValidForm())return;

                                  modalRespuesta("Cargando","Espere un momento...");

                                  String token = await storage.read(key: 'token')??"";
                                  UsuarioModel usuarioRespuesta = await Login(usuario.text, clave.text,token);





                                  if(usuarioRespuesta.email=="El usuario o la contraseña o no coinciden"){
                                    Navigator.of(context, rootNavigator: true).pop('dialog');

                                    modalRespuesta("Error","El usuario o la contraseña son incorrectos, revisa los datos y vuelve a intentar.");

                                  }else{
                                    /**/
                                    Future.delayed(Duration(milliseconds: 400),()async{


                                      await storage.write(key: 'Usuario', value: usuarioRespuesta.usuario);
                                      await storage.write(key: 'Clave', value: usuarioRespuesta.clave);
                                      await storage.write(key: 'Nombre', value: usuarioRespuesta.nombre);
                                      await storage.write(key: 'Factura_libre', value: usuarioRespuesta.facturaLibre);
                                      await storage.write(key: 'Clave_Operacion', value: usuarioRespuesta.claveOperacion);
                                      await storage.write(key: 'Fecha_Desde', value: usuarioRespuesta.fechaDesde);
                                      await storage.write(key: 'Dias', value: usuarioRespuesta.dias.toString());
                                      await storage.write(key: 'User_SQL', value: usuarioRespuesta.userSql);
                                      await storage.write(key: 'A_Quien_Reporta', value: usuarioRespuesta.aQuienReporta);
                                      await storage.write(key: 'Consigna', value: usuarioRespuesta.consigna);
                                      await storage.write(key: 'Presta_CNT', value: usuarioRespuesta.prestaCnt.toString());
                                      await storage.write(key: 'Sucursal', value: usuarioRespuesta.sucursal);
                                      await storage.write(key: 'Impresora_Despachos', value: usuarioRespuesta.impresoraDespachos);
                                      await storage.write(key: 'Impresora_Etiquetas', value: usuarioRespuesta.impresoraEtiquetas);
                                      await storage.write(key: 'Secuencia', value: usuarioRespuesta.secuencia.toString());
                                      await storage.write(key: 'Departamento', value: usuarioRespuesta.departamento);
                                      await storage.write(key: 'Email', value: usuarioRespuesta.email);
                                      await storage.write(key: 'Nivel', value: usuarioRespuesta.nivel.toString());
                                      await storage.write(key: 'Caja', value: usuarioRespuesta.caja);

                                      await storage.write(key: 'paginaActual', value: 'Principal');
                                      Navigator.of(context, rootNavigator: true).pop('dialog');







                                      Navigator.pushReplacement(context,
                                        PageRouteBuilder(
                                          pageBuilder: (context,animation1,animation2)=>LoginPage(),
                                          transitionsBuilder: (BuildContext context,animation,_,__){
                                            return FadeTransition(opacity: animation,child: PrincipalPage());
                                          },
                                        //transitionDuration: Duration.zero
                                        )
                                      );

                                    });


                                  }




                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          Center(
                            child: Text("Hola. Por favor ingresa a tu cuenta de usuario.",style: TextStyle(fontFamily:  'Text-Light',fontSize: 11)),
                          ),
                          SizedBox(
                            height: 60.0,
                          ),
                        ],
                      ),
                    );
                  }),


                ],
              ),
            ),



          ],
        ),
      ),
    );
  }

  modalRespuesta(String titulo, String mensaje){
    showDialog(context: context, builder: (_)=> new BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5) ),
        title: Center(child: Text(titulo,style: TextStyle(fontFamily: "Text-Bold",fontSize: 14,letterSpacing: -0.5))),

        content: Container(

          padding: EdgeInsets.symmetric(horizontal: 5),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 20,maxHeight: 40,maxWidth: 400),
            child: Column(
              children: [
                Text(mensaje,style: TextStyle(fontFamily: "Text-Regular",fontSize: 11,letterSpacing: -0.3))
              ],
            ),
          ),

        ),
      ),
    )
    );
  }

}
