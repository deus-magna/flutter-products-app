import 'dart:convert';

import 'package:formvalidation/src/preferences/preferencias_usuario.dart';
import 'package:http/http.dart' as http;


class UserService {

  final String _firebaseToken = 'YOUR_FCM_TOKEN';
  final _prefs = PreferenciasUsuario();

  Future<Map<String, dynamic>> login( String email, String password) async {
    
    final authData = {
      'email' : email,
      'password' : password,
      'returnSecureToken' : true
    };

    final response = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
      body: json.encode( authData )
    );

    Map<String, dynamic> decode = json.decode(response.body);
    
    print(decode);

    if (decode.containsKey('idToken')) {
      _prefs.token = decode['idToken'];
      return {'ok' : true, 'token' : decode['idToken']};
    } else {
      return {'ok' : false, 'message': decode['error']['message']};

    }

  }

  Future<Map<String, dynamic>> newUser(String email, String password) async {

    final authData = {
      'email' : email,
      'password' : password,
      'returnSecureToken' : true
    };

    final response = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
      body: json.encode( authData )
    );

    Map<String, dynamic> decode = json.decode(response.body);
    
    print(decode);

    if (decode.containsKey('idToken')) {
      _prefs.token = decode['idToken'];
      return {'ok' : true, 'token' : decode['idToken']};
    } else {
      return {'ok' : false, 'message': decode['error']['message']};

    }

  }


}