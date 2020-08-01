import 'package:flutter/material.dart';

class Constants {
  static const TextStyle kPlayerNameStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  static TextStyle kTitleStyle = TextStyle(
    color: kMainColor,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static TextStyle kSubtitleStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static TextStyle SMALL_TITLE_STYLE = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: Colors.grey[600],
  );

  static const TextStyle BUTTON_STYLE = TextStyle(
    color: Colors.white,
    fontSize: 14,
  );

  static const TextStyle MATCH_INFO_STYLE = TextStyle(
    fontSize: 13,
    color: Colors.grey,
  );

  static final Color kbackgroundColor = Color.fromRGBO(238, 238, 238, 1);
  static const Color kMainColor = Color(0xFF002865);
  static const Color kAccentColor = Color(0xFF00AFF0);
  static const Color kInputCardColor = Color.fromRGBO(229, 229, 229, 0.38);


  static const kCardBorderRadius = 15.0;

  static const double kDrawMatchHeight = 75;
}
