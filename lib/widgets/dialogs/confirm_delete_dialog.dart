/* ConfirmDeleteDialog is an Alert Dialog with a warning icon header, with a
 * message and with confirm and cancel buttons, that returns True if it has been
 * confirmed and false if canceled.
 *
 * Positional parameters:
 * - message: The message to display.
 * Named parameters:
 * - iconColor: The color of the warning icon. Default = Red.
 * - confirmColor: The color of the confirm button. Default = Red.
 * - confirmText: The text of the confirm button. Default = "Delete".
 * - cancelColor: The color of the cancel button. Default = Grey.
 * - cancelText: The text of the cancel button. Default = "Cancel".
 * - borderRadius: The border radius of the Dialog. Default = 10.
 *
 * Default use case:
     showDialog(
      context: context,
      builder: (_) => ConfirmDeleteDialog(
        "Confirm delete Message.",
      ),
    ).then((confirm) {
      if (confirm != null && confirm) deleteFunction();
    });
 */

import 'package:flutter/material.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  ConfirmDeleteDialog(
    this.message, {
    this.iconColor = Colors.red,
    this.confirmColor = Colors.red,
    this.cancelColor = Colors.grey,
    this.confirmText = "Delete",
    this.cancelText = "Cancel",
    this.borderRadius = 10,
  });

  final String message;
  final Color confirmColor;
  final Color cancelColor;
  final Color iconColor;
  final String confirmText;
  final String cancelText;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      title: Icon(
        Icons.warning,
        color: iconColor,
        size: 50,
      ),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text(
            confirmText,
            style: TextStyle(
              color: confirmColor,
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
            cancelText,
            style: TextStyle(
              color: cancelColor,
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
