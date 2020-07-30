import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/preferences/preferencias_usuario.dart';
import 'package:formvalidation/src/screens/home_screen.dart';
import 'package:formvalidation/src/screens/login_screen.dart';
import 'package:formvalidation/src/screens/product_screen.dart';
import 'package:formvalidation/src/screens/register_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final prefs = new PreferenciasUsuario();
    print( prefs.token);

    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginScreen(),
          'registro': (BuildContext context) => RegisterScreen(),
          'home': (BuildContext context) => HomeScreen(),
          'product': (BuildContext context) => ProductScreen()
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple
        ),
      ),
    );
  }
}
