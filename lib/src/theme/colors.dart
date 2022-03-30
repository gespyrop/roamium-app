import 'package:flutter/material.dart';

const int _primaryColorValue = 0xFF068499;
const int _secondaryColorValue = 0xFF60B0BE;
const Color _primaryColor = Color(_primaryColorValue);
const Color _secondaryColor = Color(_secondaryColorValue);

const MaterialColor primaryColor = MaterialColor(
  _primaryColorValue,
  <int, Color>{
    50: _primaryColor,
    100: _primaryColor,
    200: _primaryColor,
    300: _primaryColor,
    400: _primaryColor,
    500: _primaryColor,
    600: _primaryColor,
    700: _primaryColor,
    800: _primaryColor,
    900: _primaryColor,
  },
);

const MaterialColor secondaryColor = MaterialColor(
  _secondaryColorValue,
  <int, Color>{
    50: _secondaryColor,
    100: _secondaryColor,
    200: _secondaryColor,
    300: _secondaryColor,
    400: _secondaryColor,
    500: _secondaryColor,
    600: _secondaryColor,
    700: _secondaryColor,
    800: _secondaryColor,
    900: _secondaryColor,
  },
);
