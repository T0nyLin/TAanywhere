import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';

ThemeData lightTheme(BuildContext context) {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color.fromARGB(255, 165, 228, 234),
    primaryColor: Colors.black,
    textTheme: const TextTheme(
      labelLarge: lableTextStyle,
      labelMedium: lableTextStyle,
      labelSmall: lableTextStyle,
      bodyMedium: TextStyle(color: secondaryColor40LightTheme),
    ),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(
        color: Color.fromARGB(255, 48, 97, 104),
        shadows: <Shadow>[
          Shadow(
            color: Color.fromARGB(255, 39, 68, 72),
            blurRadius: 2.0,
          ),
        ],
      ),
      centerTitle: false,
      backgroundColor: Color.fromARGB(255, 128, 222, 234),
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
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
        foregroundColor: Colors.black,
        backgroundColor: const Color.fromARGB(255, 128, 222, 234),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    primaryTextTheme: const TextTheme(
      bodySmall: TextStyle(fontSize: 10, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 13, color: Colors.black),
      bodyLarge: TextStyle(
          fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontSize: 12))),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedIconTheme:
          IconThemeData(color: Color.fromARGB(255, 48, 97, 104), size: 35),
      unselectedIconTheme:
          IconThemeData(color: Color.fromARGB(255, 198, 248, 244), size: 25),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color.fromARGB(255, 188, 234, 238),
      titleTextStyle: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold,),
      contentTextStyle: TextStyle(fontSize: 13, color: Colors.black),
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
