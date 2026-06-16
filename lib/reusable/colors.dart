import 'package:flutter/material.dart';

///primary color
const Color primaryColor = Color(0xffFFBF1A);
const Color primaryLightColor = Color(0xffffe07c);

///secondary color
const Color secondaryColor = Colors.black;

const Color transparent = Colors.transparent;
const Color white = Colors.white;

const Color blue = Colors.blue;
const Color black = Colors.black;
const Color indigo = Colors.indigo;
const Color orange = Colors.orange;
const Color green = Colors.green;
const Color amber = Colors.amber;
const Color cyan = Colors.cyan;
const Color blueGrey = Colors.blueGrey;
const Color red = Colors.red;
const Color accountStatementHeaderBg = Color(0xffe0e6e6);
const Color grey = Colors.grey;
const Color layBtn = Color(0xfffaa9ba);
const Color darkGreen = Color(0XFF0E3D49);
const Color pinkButtonClr = Color(0xFFFF6182);
const Color borderColor = Color(0xFF7E97A7);
const Color headerTextColor = Color(0xFF243A48);
const Color backBtn = Color(0xff72bbef);
const Color oddsBackBtn = Color(0xff4fa6f2);
const Color oddsLayBtn = Color(0xffef8a9c);

///black
const Color lightBlack = Color(0xff1E1F25);
const Color plColor = Color(0xFFF3DFB0);
const Color bgColor = Color(0xFFEEEEEE);
const Color yellowTextColor = Color(0xFFFFB600);
const Color tileOrFontColor = Color(0xFF274151);
const Color primaryCardColor = Color(0xFFDDDCD7);
const Color secondaryCardColor = Color(0xFFE4E4E4);
const Color textColor = Color(0xFF3D5464);
const Color hover = Color(0xffffda7c);
const Color selected = Color(0xffffdc7a);
const Color loginText = Color(0xFFF5A623);
const Color divider = Color(0xffB1B1B1);
const Color account = Color(0xff243a48);
const Color accountBlnc = Color(0xff2789ce);
const Color accountBlncLight = Color(0xff5aa7e0);
const Color selectedmanu = Color.fromARGB(232, 124, 171, 209);
const Color about = Color(0xff7e97a7);
const Color roleColor = Color(0xffa762b5);
const Color nameColor = Color(0xff1e1e1e);
const Color accountStatemntHeaderBg = Color(0xffe0e6e6);
const Color headerRowColor = Color(0xFFCED5DA);
const Color selectedTabColor = Color(0xFF395E78);
const Color lightBlueShade = Color(0xFFE0E6E6);
const Color fancy = Color(0xFF076875);
const Color fancyOpac = Color(0xFF0a92a5);
const Color highlightTileHover = Color(0xFFEFF2F2);

///grey
const Color lightGrey = Color(0XFF6d7078);
const Color mediumGrey = Color(0xff4E4E4E);
const Color darkGrey = Color(0xff3E404E);
const Color littleLightGrey = Color(0xffE0E0E0);
//

//red
const Color lightRed = Color(0xffff4C43);
const Color darkRed = Color(0xffD9130E);
const Color lightGreen = Color(0xff00BF61);
const Color lightBlue = Color(0xff0082AB);
Color lbo2 = applyOpacity(Colors.lightBlue, 0.2);
Color primaryColorwithOpacity = const Color(0xFF125C92).withValues(alpha: 0.30);

///used in cms
const Color white70 = Colors.white70;
const Color white24 = Colors.white24;
const Color cmsHeader = Color(0xFF6B7280);
const Color cmsCardBorder = Color(0xFFF9FAFB);

///color with opac
Color applyOpacity(Color color, double opacity) {
  return color.withAlpha((opacity * 255).toInt());
}

const LinearGradient dividerClr = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [Color.fromRGBO(255, 255, 255, 0.0), Colors.white, Color.fromRGBO(255, 255, 255, 0.0)],
);

///primary gradient
const LinearGradient primaryGradient = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFFE07C), Color(0xFFDDA100)]);

///primary gradient
const LinearGradient disabledGradient = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [white, white]);

const LinearGradient loginBtnGradient = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: <Color>[Color(0xFF474747), Color(0xFF070707)]);
const LinearGradient loginBtnGradientOp = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: <Color>[Color(0xFF070707), Color(0xFF474747)]);

const LinearGradient lightBlueGradient = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: <Color>[accountBlncLight, accountBlnc]);

const LinearGradient selectedHeaderColor = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color.fromARGB(255, 158, 178, 192), selectedTabColor]);
const LinearGradient unselectedHeaderColor = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [headerRowColor, headerRowColor]);
const LinearGradient headerGradient = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF383838), Color(0xFF010101)]);
const LinearGradient manuGradient = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [accountBlnc, accountBlncLight]);
const LinearGradient marqueeGradient = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF2a3a43), Color(0xFF1c282d)]);
const LinearGradient secondaryGradientRevert = LinearGradient(begin: Alignment.centerRight, end: Alignment.centerLeft, colors: <Color>[Color(0xff1D1D1D), Color(0xff3F4150)]);

const LinearGradient blackGradient = LinearGradient(colors: <Color>[Color(0xff1E1F25), Color(0xff1E1F25)]);
const LinearGradient redGradient = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: <Color>[Color(0xffF9B099), Color(0xffF52949)]);
const LinearGradient lightVioletGradient = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: <Color>[Color(0xff4F4C80), Color(0xff2F4066)]);

const LinearGradient lightGreenGradient = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: <Color>[Color(0xff5ED6A9), Color(0xff29A660)]);
