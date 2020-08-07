import 'package:flutter/material.dart';
import 'package:tennistournamentadmin/utils/constants.dart';

class CategoriesChips extends StatelessWidget {
  CategoriesChips(this.selected, this.onTap, this.label);
  final bool selected;
  final Function onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: selected ? Constants.kAccentColor : Constants.kInputCardColor,
          borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
