import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  ConfirmDialog(this.message);
  final String message;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Icon(
        Icons.warning,
        color: Colors.red,
        size: 50,
      ),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Confirmar",
            style: TextStyle(
              color: Colors.green,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        FlatButton(
          child: Text(
            "Cancelar",
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}
