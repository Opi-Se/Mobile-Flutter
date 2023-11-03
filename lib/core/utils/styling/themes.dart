import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppThemes {
  static const String light = 'light';
  static const String dark = 'dark';

  ///Todo: change primary color

  static ThemeData lightMode = ThemeData(
    useMaterial3: true,
    primaryColor: const Color(0xff5D9CEC),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.black,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xffDFECDB),
    dialogBackgroundColor: const Color(0xffDFECDB),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Color(0xffDFECDB),
        statusBarIconBrightness: Brightness.dark,
      ),
      elevation: 0,
      backgroundColor: const Color(0xffDFECDB),
      titleSpacing: 20.w,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 35.sp,
        color: Colors.white,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
    ),
  );

  static ThemeData darkMode = ThemeData(
    useMaterial3: true,
    primaryColor: const Color(0xff5D9CEC),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.white,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xff181725),
    dialogBackgroundColor: const Color(0xff181725),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Color(0xff181725),
        statusBarIconBrightness: Brightness.light,
      ),
      elevation: 0,
      titleSpacing: 20.w,
      backgroundColor: const Color(0xff181725),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 35.sp,
        color: Colors.black,
      ),
    ),
  );
}
