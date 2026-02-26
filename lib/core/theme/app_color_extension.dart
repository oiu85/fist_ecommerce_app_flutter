import 'package:flutter/material.dart';

import '../constant/app_colors.dart';

/// Custom color extension for theme-specific colors that go beyond
/// [ColorScheme].
@immutable
class AppColorExtension extends ThemeExtension<AppColorExtension> {
  final Color accentHover;
  final Color accentActive;
  final Color surfacePanel;
  final Color surfacePanelHover;
  final Color strongBorder;
  final Color shimmer;
  // Status colors
  final Color success;
  final Color successBackground;
  final Color warning;
  final Color warningBackground;
  // Component colors
  final Color componentBackground;
  final Color borderColor;
  /// Star rating color for product cards, reviews.
  final Color starRating;
  /// Second primary (navy) for headers, titles, and small accents.
  final Color primaryNavy;
  /// Form background — neutral grey for add product, forms.
  final Color formBackground;
  /// Product details page background — warm off-white.
  final Color productDetailsBackground;
  /// Image overlay scrim for hero/gallery gradients.
  final Color imageOverlayScrim;

  const AppColorExtension({
    required this.accentHover,
    required this.accentActive,
    required this.surfacePanel,
    required this.surfacePanelHover,
    required this.strongBorder,
    required this.shimmer,
    required this.success,
    required this.successBackground,
    required this.warning,
    required this.warningBackground,
    required this.componentBackground,
    required this.borderColor,
    required this.starRating,
    required this.primaryNavy,
    required this.formBackground,
    required this.productDetailsBackground,
    required this.imageOverlayScrim,
  });

  //* Light: primary (green) accent only — secondary color removed
  static const AppColorExtension light = AppColorExtension(
    accentHover: AppColors.primaryColorHover,
    accentActive: AppColors.primaryColorActive,
    surfacePanel: AppColors.lightSurface,
    surfacePanelHover: AppColors.greyLightHover,
    strongBorder: AppColors.greyNormal,
    shimmer: AppColors.greyLight,
    success: AppColors.successGreen,
    successBackground: AppColors.successGreenLight,
    warning: AppColors.warningAmber,
    warningBackground: AppColors.warningAmberLight,
    componentBackground: AppColors.componentsBackground,
    borderColor: AppColors.borderColor,
    starRating: AppColors.starRatingYellow,
    primaryNavy: AppColors.primaryNavy,
    formBackground: AppColors.formBackground,
    productDetailsBackground: AppColors.productDetailsBackground,
    imageOverlayScrim: AppColors.imageOverlayScrim,
  );

  //* Dark: primary navy backgrounds, dark surfaces
  static const AppColorExtension dark = AppColorExtension(
    accentHover: AppColors.primaryColorHover,
    accentActive: AppColors.primaryColorActive,
    surfacePanel: AppColors.primaryNavyHover,
    surfacePanelHover: AppColors.greyDarkHover,
    strongBorder: AppColors.greyDark,
    shimmer: AppColors.greyDark,
    success: AppColors.successGreen,
    successBackground: AppColors.successGreenLight,
    warning: AppColors.warningAmber,
    warningBackground: AppColors.warningAmberLight,
    componentBackground: AppColors.greyDark,
    borderColor: AppColors.borderColorDark,
    starRating: AppColors.starRatingYellow,
    primaryNavy: AppColors.white,
    formBackground: AppColors.formBackgroundDark,
    productDetailsBackground: AppColors.productDetailsBackgroundDark,
    imageOverlayScrim: AppColors.imageOverlayScrim,
  );

  @override
  AppColorExtension copyWith({
    Color? accentHover,
    Color? accentActive,
    Color? surfacePanel,
    Color? surfacePanelHover,
    Color? strongBorder,
    Color? shimmer,
    Color? success,
    Color? successBackground,
    Color? warning,
    Color? warningBackground,
    Color? componentBackground,
    Color? borderColor,
    Color? starRating,
    Color? primaryNavy,
    Color? formBackground,
    Color? productDetailsBackground,
    Color? imageOverlayScrim,
  }) {
    return AppColorExtension(
      accentHover: accentHover ?? this.accentHover,
      accentActive: accentActive ?? this.accentActive,
      surfacePanel: surfacePanel ?? this.surfacePanel,
      surfacePanelHover: surfacePanelHover ?? this.surfacePanelHover,
      strongBorder: strongBorder ?? this.strongBorder,
      shimmer: shimmer ?? this.shimmer,
      success: success ?? this.success,
      successBackground: successBackground ?? this.successBackground,
      warning: warning ?? this.warning,
      warningBackground: warningBackground ?? this.warningBackground,
      componentBackground: componentBackground ?? this.componentBackground,
      borderColor: borderColor ?? this.borderColor,
      starRating: starRating ?? this.starRating,
      primaryNavy: primaryNavy ?? this.primaryNavy,
      formBackground: formBackground ?? this.formBackground,
      productDetailsBackground:
          productDetailsBackground ?? this.productDetailsBackground,
      imageOverlayScrim: imageOverlayScrim ?? this.imageOverlayScrim,
    );
  }

  @override
  AppColorExtension lerp(ThemeExtension<AppColorExtension>? other, double t) {
    if (other is! AppColorExtension) return this;
    return AppColorExtension(
      accentHover: Color.lerp(accentHover, other.accentHover, t)!,
      accentActive: Color.lerp(accentActive, other.accentActive, t)!,
      surfacePanel: Color.lerp(surfacePanel, other.surfacePanel, t)!,
      surfacePanelHover: Color.lerp(surfacePanelHover, other.surfacePanelHover, t)!,
      strongBorder: Color.lerp(strongBorder, other.strongBorder, t)!,
      shimmer: Color.lerp(shimmer, other.shimmer, t)!,
      success: Color.lerp(success, other.success, t)!,
      successBackground: Color.lerp(successBackground, other.successBackground, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningBackground: Color.lerp(warningBackground, other.warningBackground, t)!,
      componentBackground: Color.lerp(componentBackground, other.componentBackground, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      starRating: Color.lerp(starRating, other.starRating, t)!,
      primaryNavy: Color.lerp(primaryNavy, other.primaryNavy, t)!,
      formBackground: Color.lerp(formBackground, other.formBackground, t)!,
      productDetailsBackground: Color.lerp(
        productDetailsBackground,
        other.productDetailsBackground,
        t,
      )!,
      imageOverlayScrim: Color.lerp(
        imageOverlayScrim,
        other.imageOverlayScrim,
        t,
      )!,
    );
  }
}
