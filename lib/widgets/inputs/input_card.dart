import 'package:flutter/material.dart';
import 'package:tennistournamentadmin/utils/constants.dart';

class InputCard extends StatelessWidget {
  InputCard(this.controller, this.hint, {this.obscure = false});
  final TextEditingController controller;
  final bool obscure;
  final String hint;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 50,
      width: size.width * 0.8,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Constants.kInputCardColor,
        borderRadius:
        BorderRadius.circular(Constants.kCardBorderRadius),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
      ),
    );
  }
}