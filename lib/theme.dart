import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';

ThemeData lightTheme(BuildContext context) {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Color.fromARGB(255, 171, 239, 232),
    primaryColor: Colors.black,
    textTheme: const TextTheme(
      labelLarge: lableTextStyle,
      labelMedium: lableTextStyle,
      labelSmall: lableTextStyle,
      bodyMedium: TextStyle(color: secondaryColor40LightTheme),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      backgroundColor: Color.fromARGB(255, 128, 222, 234),
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      toolbarTextStyle: TextStyle(color: textColorLightTheme),
    ),
    // inputDecorationTheme: const InputDecorationTheme(
    //   contentPadding: EdgeInsets.symmetric(horizontal: defaultPadding),
    //   fillColor: secondaryColor5LightTheme,
    //   filled: true,
    //   border: lightThemeOutlineInputBorder,
    //   enabledBorder: lightThemeOutlineInputBorder,
    //   focusedBorder: lightThemeOutlineInputBorder,
    //   disabledBorder: lightThemeOutlineInputBorder,
    // ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.shifting,
      selectedItemColor: Color.fromARGB(255, 6, 88, 105),
      showSelectedLabels: false,
    ),
    canvasColor: const Color.fromARGB(255, 128, 222, 234),
    iconTheme: const IconThemeData(color: textColorLightTheme),
    dividerColor: secondaryColor5LightTheme,
  );
}

const OutlineInputBorder lightThemeOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(10)),
  borderSide: BorderSide.none,
);

const lableTextStyle = TextStyle(color: secondaryColor20LightTheme);
