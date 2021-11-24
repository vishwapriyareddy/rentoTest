import 'package:flutter/material.dart';

Color _colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

Color primaryColor = _colorFromHex("#3c5784");
Color secondaryColor = _colorFromHex("FF2626");
Color color = Color(0xFF3c5784);
