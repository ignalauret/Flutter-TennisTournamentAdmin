import 'package:flutter/material.dart';
import 'package:tennistournamentadmin/utils/constants.dart';

class ActionButton extends StatelessWidget {
  ActionButton(this.label, this.onClick);
  final String label;
  final Function onClick;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 60,
      width: size.width * 0.6,
      child: FlatButton(
        onPressed: onClick,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
        ),
        color: Constants.kAccentColor,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
