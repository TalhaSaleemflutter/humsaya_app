import 'dart:math';

import 'package:flutter/material.dart';

const primary = Color(0xFF149F4C);
const black = Color.fromRGBO(0, 0, 0, 1);
const black1 = Color(0xFF1C1C1E);
const black2 = Colors.black45;
const cardColor = Color(0xff171616);
const iconColor = Color.fromRGBO(114, 118, 119, 1);

//purple & pink
const purple = Color(0xff423246);
const purple1 = Color(0xff9F1EBF);
const pink = Color(0xffE737B6);

//yellow
const yellow = Color(0xffE89B3F);
const yellow1 = Color(0xffEEDA26);

const orange = Color(0xffDC6F20);
const brown = Color(0xffA77120);
const transparent = Colors.transparent;
const lightYellow = Color(0xffFFF9EF);
const lightRed = Color(0xffFEF0F0);

//whites
const white = Color(0xffFBFAFA);
const white1 = Color.fromARGB(255, 247, 245, 245);

//blues
const blue = Color(0xff10ADCF);
const blue1 = Color.fromRGBO(228, 244, 253, 1);
const blue2 = Color(0xff1949CA);
const indigo = Color(0xff280E91);
const blue4 = Color.fromRGBO(8, 25, 41, 2);

//greys
const grey0 = Color(0xffF5F6F7);
const grey1 = Color.fromARGB(255, 209, 211, 211);
const grey2 = Color(0xff727677);
const grey3 = Color(0xff414D55);
const grey4 = Color(0xff404345);
const grey5 = Color(0xff262626);
const grey7 = Color(0xffEDEEF0);
//greens
const green1 = Color(0xff12B799);
const green2 = Color(0xff116F7B);
const green3 = Color(0xff135C7B);
const green4 = Color(0xff26B84F);

// Teal shades
const teal = Color(0xff009688);
const tealLight = Color(0xff80CBC4);
const tealDark = Color(0xff004D40);

// Cyan shades
const cyan = Color(0xff00BCD4);
const cyanLight = Color(0xffB2EBF2);
const cyanDark = Color(0xff00838F);

// Additional purples
const deepPurple = Color(0xff673AB7);
const lavender = Color(0xffE1BEE7);

// Additional yellows
const amber = Color(0xffFFC107);
const amberDark = Color(0xffFFA000);

// Reds
const darkRed = Color(0xff8B0000);
const crimson = Color(0xffDC143C);

// Blues
const skyBlue = Color(0xff87CEEB);
const midnightBlue = Color(0xff191970);

// Warm tones
const warmPeach = Color(0xffFFDAB9);
const coral = Color(0xffFF7F50);

// Neutrals
const softGrey = Color(0xffD3D3D3);
const slateGrey = Color(0xff708090);

// Vibrant
const magenta = Color(0xffFF00FF);
const neonGreen = Color(0xff39FF14);

// Earthy tones
const olive = Color(0xff808000);
const khaki = Color(0xffF0E68C);

String colorToHex(Color color) {
  return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}

Color hexToColor(String hex) {
  final buffer = StringBuffer();
  if (hex.isEmpty) {
    return primary; // Default color, can be any color you prefer
  }
  if (hex.length == 6 || hex.length == 7) buffer.write('FF');
  buffer.write(hex.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

String generateRandomHexColor(BuildContext context) {
  // Define a fixed set of solid colors that are visually appealing.
  List<String> solidColors = [
    '#FF0000', // Red
    '#0000FF', // Blue
    '#800080', // Purple
    '#FFA500', // Orange
    '#000000', // Black
  ];

  // Pick a random color from the predefined list.
  Random random = Random();
  String selectedColor = solidColors[random.nextInt(solidColors.length)];

  return selectedColor;
}
