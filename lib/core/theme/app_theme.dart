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
    
    //* Color Scheme (Light)
    colorScheme: const ColorScheme.light(
      primary: AppColors.orangeNormal,
      secondary: AppColors.greyNormal,
      tertiary: AppColors.orangeDark,
      surface: AppColors.lightSurface,
      background: AppColors.lightBackground,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.greyDark,
      onBackground: AppColors.greyDark,
      error: AppColors.lightError,
      onError: AppColors.lightOnError,
      surfaceVariant: AppColors.greyLight,
      outline: AppColors.greyNormal,
      primaryContainer: AppColors.orangeLightActive,
      onPrimaryContainer: AppColors.greyDark,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    
    //* Custom Color Extension (Light)
    extensions: const [
      AppColorExtension.light,
    ],
    
    //* Text Theme (Light)
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold, fontFamily: fontFamily, color: AppColors.greyDark),
      displayMedium: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600, fontFamily: fontFamily, color: AppColors.greyDark),
      displaySmall: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500, fontFamily: fontFamily, color: AppColors.greyDark),
      headlineMedium: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600, fontFamily: fontFamily, color: AppColors.greyDark),
      headlineSmall: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500, fontFamily: fontFamily, color: AppColors.greyDark),
      titleLarge: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, fontFamily: fontFamily, color: AppColors.greyDark),
      titleMedium: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, fontFamily: fontFamily, color: AppColors.greyDark),
      titleSmall: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, fontFamily: fontFamily, color: AppColors.greyDark),
      bodyLarge: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, fontFamily: fontFamily, color: AppColors.greyDark),
      bodyMedium: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, fontFamily: fontFamily, color: AppColors.greyDark),
      bodySmall: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300, fontFamily: fontFamily, color: AppColors.greyNormal),
      labelLarge: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, fontFamily: fontFamily, color: AppColors.greyDark),
      labelSmall: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400, fontFamily: fontFamily, color: AppColors.greyNormal),
    ).apply(fontSizeFactor: 1),
    
    //* Button Theme (Light)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.orangeNormal,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
        textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, fontFamily: fontFamily),
        elevation: 0,
      ),
    ),
    
    //* AppBar Theme (Light)
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.greyDark,
      surfaceTintColor: AppColors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.greyDark,
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
        borderSide: BorderSide(color: AppColors.orangeNormal, width: 1.w),
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
        color: AppColors.greyDark,
      ),
    ),
  );
}

ThemeData appAltTheme(BuildContext context) => appTheme(context);
