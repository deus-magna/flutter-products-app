


import 'package:flutter/material.dart';

bool isANumber( String s) {

  if (s.isEmpty) return false;
  final n = num.tryParse(s);
  return ( n == null) ? false : true;

}

void showAlert(BuildContext context, String message) {

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Información incorrecta'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: ()=> Navigator.of(context).pop(), 
            child: Text('Ok',
            ),
          )
        ],
      );
    }
    );
}