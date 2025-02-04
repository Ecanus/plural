import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/text_themes.dart';

class AppThemes {

  static Color successColor = Color(0xff43BD47);
  static Color transparentColor = Colors.transparent;

  static ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff6572C5),
    onPrimary: Color(0xffD8D8D8),
    secondary: Color(0xff232531),
    secondaryFixed: Color.fromARGB(255, 41, 43, 56),
    onSecondary: Color(0xffC7C7C7),
    tertiary: Color(0xff596697),
    onTertiary: Color.fromARGB(255, 160, 160, 160),
    tertiaryFixed: Color(0xff080808),
    error: Color(0xffB94B58),
    onError: Color(0xffC7C7C7),
    surface: Color(0xff1C2229),
    onSurface: Color(0xffD8D8D8),
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
    //elevatedButtonTheme: elevatedButtonTheme,
    //focusColor: null,
    //highlightColor: Color(0xff333D7B),
    //hoverColor: null,
    //iconButtonTheme: IconButtonThemeData(),
    //iconTheme: IconThemeData(),
    //indicatorColor: null,
    //primaryTextTheme: TextTheme(),
    //scaffoldBackgroundColor: null,
    //scrollbarTheme: ScrollbarThemeData(),
    //shadowColor: Colors.black,
    tabBarTheme: TabBarTheme(
      labelColor: colorScheme.onPrimary,
      indicatorColor: colorScheme.onPrimary,
      indicatorSize: TabBarIndicatorSize.tab
    ),
    textTheme: appTextTheme,
  );
}