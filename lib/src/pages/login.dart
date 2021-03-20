import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hive/hive.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_flutter/src/pages/conocenos.dart';
import 'package:ui_flutter/src/pages/inicio.dart';
import 'package:ui_flutter/src/services/local_notification.dart';
import 'package:ui_flutter/src/services/services_bitacora.dart';
import 'package:ui_flutter/src/services/services_empresa.dart';
import 'package:ui_flutter/src/services/services_login.dart';
import 'package:ui_flutter/src/services/services_sedes.dart';
import 'package:ui_flutter/src/services/services_usuario.dart';
import 'package:ui_flutter/src/services/socket.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

class PageLogin extends StatefulWidget {
  PageLogin({Key key}) : super(key: key);

  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  final _formKey = GlobalKey<FormState>();
  var emailTextController = TextEditingController();
  var passwordTextController = TextEditingController();
  String errorLogin = null;
  Login login;
  LocalNotification localNotification;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    localNotification = new LocalNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height / 1.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: new AssetImage("assets/fondo_login.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Container(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.3,
                height: MediaQuery.of(context).size.height / 1.3,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20.0),
                  // border: Border.all(color: Colors.white, width: 5.0),
                  color: Colors.black12.withOpacity(0.1),
                ),

                // Formulario------
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Logo-------
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          width: 200,
                          height: 200,
                          child: ClipRRect(
                            child: Image(
                              image: AssetImage('assets/icons/descarga32.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        WidgetsGenericos.formItemsDesign(
                          Icons.email_sharp,
                          TextFormField(
                            controller: emailTextController,
                            autofocus: false,
                            decoration: new InputDecoration(
                              labelText: 'Correo Electronico',
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Por favor ingrese un Email ';
                              }
                              return null;
                            },
                          ),
                        ),
                        WidgetsGenericos.formItemsDesign(
                          Icons.email_sharp,
                          TextFormField(
                            autofocus: false,
                            controller: passwordTextController,
                            decoration: new InputDecoration(
                              labelText: 'Contraseña',
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Por favor ingrese un password ';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          child: errorLogin != null
                              ? Container(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Center(
                                    child: Text(
                                      errorLogin,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                )
                              : Text(''),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: SizedBox(
                            width: double.infinity,
                            child: GFButton(
                              type: GFButtonType.solid,
                              shape: GFButtonShape.pills,
                              color: Theme.of(context).accentColor,
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  WidgetsGenericos.showLoaderDialog(
                                    context,
                                    true,
                                    'Cargando...',
                                    null,
                                    Colors.white,
                                  );
                                  login = await ServicioLogin().signin(
                                    emailTextController.text,
                                    passwordTextController.text,
                                  );

                                  if (login.token != null) {
                                    Navigator.pop(context);
                                    setState(() {
                                      errorLogin = null;
                                    });
                                    Usuario usuario = Usuario.fromJson(
                                      JwtDecoder.decode(login.token),
                                    );

                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setInt('us_cdgo', usuario.us_cdgo);
                                    prefs.setString(
                                        'us_nombres', usuario.us_nombres);
                                    prefs.setString(
                                        'us_alias', usuario.us_alias);
                                    prefs.setInt(
                                        'us_perfil', usuario.us_perfil);
                                    prefs.setInt(
                                        'us_sd_cdgo', usuario.us_sd_cdgo);
                                    print(usuario.us_sd_cdgo);
                                    prefs.setString('token', login.token);
                                    // -------------------------------------------------------
                                    List viejasede = Hive.box('sedesdb')
                                        .get('data', defaultValue: []);
                                    List nuevasede =
                                        await ServicioSede().cargarSedes(true);
                                    if (viejasede.length >= nuevasede.length) {
                                      print('viejasede');
                                      prefs.setInt('cambio_sede', 0);
                                    } else {
                                      int dif =
                                          nuevasede.length - viejasede.length;
                                      print(dif);
                                      prefs.setInt('cambio_sede', dif);
                                      print('nuevasede');
                                    }
                                    ServicioEmpresa().getEmpresa(true);
                                    ServicioBitacoras().getBitacora(true);

                                    SocketIO socket =
                                        await socketRes().conexion();

// ----------socket--sedes-----------------------
                                    socket.on('sedesres', (data) {
                                      if (data['tipo'] == "registro")
                                        localNotification.scheduleNotification(
                                            'Se ha registrado una nueva sede ',
                                            data['sede']);

                                      ServicioSede().cargarSedes(true);
                                    });
// -----------socket--bitacoras-----------------
                                    socket.on('bitacorasres', (data) {
                                      if (data['tipo'] == "registro")
                                        localNotification.scheduleNotification(
                                            'Se ha registrado una nueva bitacora ',
                                            data['lugar']);

                                      ServicioBitacoras().getBitacora(true);
                                    });

                                    socket.on('empresasres', (_) {
                                      print('empresas cambio');
                                      ServicioEmpresa().getEmpresa(true);
                                    });

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            InicioPage(),
                                      ),
                                    );
                                  } else if (login.message != null) {
                                    Navigator.pop(context);
                                    print(login.message);
                                    setState(() {
                                      errorLogin = login.message;
                                    });
                                  }
                                }
                              },
                              child: Text(
                                'Iniciar Sesión',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: GFButton(
                              type: GFButtonType.outline,
                              shape: GFButtonShape.pills,
                              color: Theme.of(context).accentColor,
                              onPressed: () {},
                              child: Text(
                                'Registrarse',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: GFButton(
                              type: GFButtonType.outline,
                              shape: GFButtonShape.pills,
                              color: Theme.of(context).accentColor,
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PageConocenos(),
                                  ),
                                );
                              },
                              child: Text(
                                'Conocenos',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // ----------------
              ),
            ),
          ),
        ),
      ),
    );
  }
}
