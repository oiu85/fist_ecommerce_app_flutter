import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/fonts.gen.dart';
import '../constant/app_colors.dart';
import 'app_color_extension.dart';

//* Light theme for the app

ThemeData appTheme(BuildContext context) {
  //* Default font is Sora
  const fontFamily = FontFamily.sora;

  return ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    brightness: Brightness.light,
    
    //* Color Scheme (Light) — primary: dark green 2D5F4C; navy 111827 for text/surfaces; no distinct secondary
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.primaryColorLight,
      onPrimaryContainer: AppColors.primaryNavy,
      //* Secondary slot set to primary (green) — secondary color removed per design
      secondary: AppColors.primaryColor,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.primaryColorLight,
      onSecondaryContainer: AppColors.primaryNavy,
      tertiary: AppColors.primaryColorActive,
      surface: AppColors.lightSurface,
      background: AppColors.lightBackground,
      onSurface: AppColors.primaryNavy,
      onBackground: AppColors.primaryNavy,
      error: AppColors.lightError,
      onError: AppColors.lightOnError,
      surfaceVariant: AppColors.greyLight,
      outline: AppColors.greyNormal,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    
    //* Custom Color Extension (Light)
    extensions: const [
      AppColorExtension.light,
    ],
    
    //* Text Theme (Light) — navy (primaryNavy) for main text
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold, fontFamily: fontFamily, color: AppColors.primaryNavy),
      displayMedium: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600, fontFamily: fontFamily, color: AppColors.primaryNavy),
      displaySmall: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500, fontFamily: fontFamily, color: AppColors.primaryNavy),
      headlineMedium: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600, fontFamily: fontFamily, color: AppColors.primaryNavy),
      headlineSmall: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500, fontFamily: fontFamily, color: AppColors.primaryNavy),
      titleLarge: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, fontFamily: fontFamily, color: AppColors.primaryNavy),
      titleMedium: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, fontFamily: fontFamily, color: AppColors.primaryNavy),
      titleSmall: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, fontFamily: fontFamily, color: AppColors.primaryNavy),
      bodyLarge: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, fontFamily: fontFamily, color: AppColors.primaryNavy),
      bodyMedium: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, fontFamily: fontFamily, color: AppColors.primaryNavy),
      bodySmall: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300, fontFamily: fontFamily, color: AppColors.greyNormal),
      labelLarge: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, fontFamily: fontFamily, color: AppColors.primaryNavy),
      labelSmall: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400, fontFamily: fontFamily, color: AppColors.greyNormal),
    ).apply(fontSizeFactor: 1),
    
    //* Button Theme (Light)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
        textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, fontFamily: fontFamily),
        elevation: 0,
      ),
    ),
    
    //* AppBar Theme (Light) — navy for headers
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.primaryNavy,
      surfaceTintColor: AppColors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryNavy,
      ),
    ),
    
    //* Card Theme (Light)
    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      shadowColor: AppColors.lightShadow,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
    ),
    
    //* Input Decoration Theme (Light)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.greyLight,
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11.r),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 1.w),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11.r),
        borderSide: BorderSide(color: AppColors.lightError, width: 1.w),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11.r),
        borderSide: BorderSide(color: AppColors.lightError, width: 1.w),
      ),
      hintStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamily,
        color: AppColors.greyNormal,
      ),
      labelStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamily,
        color: AppColors.primaryNavy,
      ),
    ),
  );
}

//* Dark theme — primary navy (#111827) as main background per design.
ThemeData appAltTheme(BuildContext context) {
  const fontFamily = FontFamily.sora;
  //* Dark mode: primary navy as surface/background
  const darkSurface = AppColors.primaryNavy;
  const darkBackground = AppColors.primaryNavy;

  return ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryColor,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.primaryColorActive,
      onPrimaryContainer: AppColors.white,
      secondary: AppColors.primaryColor,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.primaryColorActive,
      onSecondaryContainer: AppColors.white,
      tertiary: AppColors.primaryColorActive,
      surface: darkSurface,
      onSurface: AppColors.white,
      onSurfaceVariant: AppColors.greyLight,
      surfaceContainerHighest: AppColors.primaryNavyHover,
      surfaceContainerHigh: Color(0xFF1A2332),
      surfaceContainer: Color(0xFF151D29),
      error: AppColors.darkError,
      onError: AppColors.darkOnError,
      outline: AppColors.greyDark,
    ),
    scaffoldBackgroundColor: darkBackground,
    extensions: const [AppColorExtension.dark],
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
        color: AppColors.white,
      ),
      displayMedium: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
        color: AppColors.white,
      ),
      displaySmall: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamily,
        color: AppColors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
        color: AppColors.white,
      ),
      headlineSmall: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamily,
        color: AppColors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
        color: AppColors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
        color: AppColors.white,
      ),
      titleSmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamily,
        color: AppColors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamily,
        color: AppColors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamily,
        color: AppColors.white,
      ),
      bodySmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w300,
        fontFamily: fontFamily,
        color: AppColors.greyLight,
      ),
      labelLarge: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
        color: AppColors.white,
      ),
      labelSmall: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamily,
        color: AppColors.greyLight,
      ),
    ).apply(fontSizeFactor: 1),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
        textStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
        elevation: 0,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: AppColors.white,
      surfaceTintColor: AppColors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.primaryNavyHover,
      shadowColor: AppColors.darkShadow,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.greyDark,
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11.r),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 1.w),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11.r),
        borderSide: BorderSide(color: AppColors.darkError, width: 1.w),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11.r),
        borderSide: BorderSide(color: AppColors.darkError, width: 1.w),
      ),
      hintStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamily,
        color: AppColors.greyLight,
      ),
      labelStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamily,
        color: AppColors.white,
      ),
    ),
  );
}
