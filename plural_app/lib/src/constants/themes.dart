import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/text_themes.dart';

class AppThemes {

  static Color successColor = Color(0xff43BD47);
  static Color positiveColor = Color(0xff77BB7A);

  // Snackbar
  static Color snackbarSuccessBackgroundColor = Colors.green[400]!;
  static Color snackbarSuccessCloseIconColor = Colors.black;
  static Color snackbarSuccessIconColor = Colors.green[900]!;
  static Color snackbarSuccessTextColor = Colors.black;

  static Color snackbarErrorBackgroundColor = Color(0xffB94B58);
  static Color snackbarErrorCloseIconColor = Colors.black;
  static Color snackbarErrorIconColor = Colors.black;
  static Color snackbarErrorTextColor = Colors.black;

  // ColorScheme
  static ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff6572C5),
    primaryContainer: Color(0xff495394),
    onPrimary: Color(0xffD8D8D8),
    onPrimaryContainer: Colors.white,
    onPrimaryFixed: Colors.grey,
    secondary: Color(0xff232531),
    secondaryFixed: Color(0xff292B38),
    onSecondary: Color(0xffC7C7C7),
    tertiary: Color(0xff596697),
    onTertiary: Color(0xffA0A0A0),
    tertiaryFixed: Color(0xff080808),
    error: Color(0xffB94B58),
    onError: Color(0xffC7C7C7),
    surface: Color(0xff1C2229),
    onSurface: Color(0xffD8D8D8),
    surfaceBright: Color(0xff2E324A),
    surfaceDim: Color.fromARGB(255, 13, 16, 20)
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
    shadowColor: Colors.black.withValues(alpha: AppOpacities.point6),
    tabBarTheme: TabBarThemeData(
      labelColor: colorScheme.onPrimary,
      indicatorColor: colorScheme.onPrimary,
      indicatorSize: TabBarIndicatorSize.tab
    ),
    textTheme: appTextTheme,
  );
}