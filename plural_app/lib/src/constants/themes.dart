import 'package:flutter/material.dart';

class AppThemes {

  static Color successColor = Color(0xff43BD47);
  static Color transparentColor = Colors.transparent;

  static ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff7482DD),
    onPrimary: Color(0xffC7C7C7),
    secondary: Color(0xff232531),
    onSecondary: Color(0xffC7C7C7),
    error: Color(0xffB94B58),
    onError: Color(0xffC7C7C7),
    surface: Color(0xff1D232B),
    onSurface: Color(0xff939393),
  );

  static ThemeData standard = ThemeData(
    useMaterial3: true,
    //appBarTheme: AppBarTheme(),
    //bottomAppBarTheme: BottomAppBarTheme(),
    //cardColor: null,
    //cardTheme: CardTheme(),
    //checkboxTheme: CheckboxThemeData(),
    colorScheme: colorScheme,
    //dialogBackgroundColor: null,
    //disabledColor: null,
    //datePickerTheme: DatePickerThemeData(),
    //elevatedButtonTheme: ElevatedButtonThemeData(
    //  style: ButtonStyle(
     //   backgroundColor: null,
    //  )
    //),
    //focusColor: null,
    //highlightColor: Color(0xff333D7B),
    //hoverColor: null,
    //iconButtonTheme: IconButtonThemeData(),
    //iconTheme: IconThemeData(),
    //indicatorColor: null,
    //primaryTextTheme: TextTheme(),
    //scaffoldBackgroundColor: null,
    //scrollbarTheme: ScrollbarThemeData(),
    shadowColor: Colors.black,
    tabBarTheme: TabBarTheme(
      labelColor: colorScheme.onPrimary,
      indicatorColor: colorScheme.onPrimary,
      indicatorSize: TabBarIndicatorSize.tab
    ),
    //textTheme: TextTheme(),
  );
}