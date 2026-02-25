import 'package:flutter/material.dart';

/// App color constants - Should ONLY be used in theme definitions
/// Widgets should use Theme.of(context).colorScheme instead
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  //* ==================== Common Colors ====================
  
  // Basic colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  //* ==================== Light Theme Colors ====================
  
  // Light Error
  static const Color lightError = Color(0xFFB00020);
  static const Color lightOnError = Color(0xFFFFFFFF);
  
  // Light Surface
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBackground = Color(0xFFFCF1EA); // orangeLight
  
  // Light Shadow & Scrim
  static const Color lightShadow = Color(0x44000000); // 27% opacity black
  static const Color lightScrim = Color(0x66000000); // 40% opacity black

  //* ==================== Dark Theme Colors ====================
  
  // Dark Error
  static const Color darkError = Color(0xFFEF5350);
  static const Color darkOnError = Color(0xFFFFFFFF);
  
  // Dark Surface & Background
  static const Color darkSurfacePanel = Color(0xFF1C1B1F);
  static const Color darkBackground = Color(0xFF050505);
  
  // Dark Shadow & Scrim
  static const Color darkShadow = Color(0x88000000); // 53% opacity black
  static const Color darkScrim = Color(0x99000000); // 60% opacity black

  //* ==================== Orange Colors ====================
  
  // Orange Light
  static const Color orangeLight = Color(0xFFFCF1EA); // rgb(252, 241, 234)
  static const Color orangeLightHover = Color(0xFFFAE39F); // rgb(250, 233, 223)
  static const Color orangeLightActive = Color(0xFFF5D2BD); // rgb(245, 210, 189)

  // Orange Normal
  static const Color orangeNormal = Color(0xFFE06F1B); // rgb(224, 111, 43)
  static const Color orangeNormalHover = Color(0xFFCA6427); // rgb(202, 100, 39)
  static const Color orangeNormalActive = Color(0xFFB35922); // rgb(179, 89, 34)

  // Orange Dark
  static const Color orangeDark = Color(0xFFAB5320); // rgb(168, 83, 32)
  static const Color orangeDarkHover = Color(0xFF86431A); // rgb(134, 67, 26)
  static const Color orangeDarkActive = Color(0xFF653213); // rgb(101, 50, 19)

  // Orange Darker
  static const Color orangeDarker = Color(0xFF4E270F); // rgb(78, 39, 15)

  //* ==================== Grey Colors ====================
  
  // Grey Light
  static const Color greyLight = Color(0xFFEBE8EB); // rgb(235, 235, 235)
  static const Color greyLightHover = Color(0xFFE1E1E1); // rgb(225, 225, 225)
  static const Color greyLightActive = Color(0xFFC0C0C0); // rgb(192, 192, 192)

  // Grey Normal
  static const Color greyNormal = Color(0xFF353535); // rgb(53, 53, 53)
  static const Color greyNormalHover = Color(0xFF303030); // rgb(48, 48, 48)
  static const Color greyNormalActive = Color(0xFF2A2A2A); // rgb(42, 42, 42)

  // Grey Dark
  static const Color greyDark = Color(0xFF282828); // rgb(40, 40, 40)
  static const Color greyDarkHover = Color(0xFF202020); // rgb(32, 32, 32)
  static const Color greyDarkActive = Color(0xFF181818); // rgb(24, 24, 24)

  // Grey Darker
  static const Color greyDarker = Color(0xFF131313); // rgb(19, 19, 19)

  //* ==================== Special Colors ====================
  
  // Components Background
  static const Color componentsBackground = Color(0xFFF9F2ED); // rgb(249, 242, 237)
  
  // Border Color
  static const Color borderColor = Color(0xFFEDD6C8); // rgb(237, 214, 200)

  //* ==================== Status Colors ====================
  
  // Success (green) - for completed/success states
  static const Color successGreen = Color(0xFF26D368); // rgb(38, 211, 104)
  static const Color successGreenLight = Color(0xFFE8F8EE); // rgb(232, 248, 238)
  
  // Warning (yellow/amber) - for end booking/warning states
  static const Color warningAmber = Color(0xFFB3A41D); // rgb(179, 164, 29)
  static const Color warningAmberLight = Color(0xFFFDF8E8); // rgb(253, 248, 232)
}
