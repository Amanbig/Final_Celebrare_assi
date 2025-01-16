import 'package:flutter/material.dart';
import '../core/app_export.dart';
import 'package:google_fonts/google_fonts.dart';

extension TextStyleExtensions on TextStyle {
  TextStyle get poppins {
    return GoogleFonts.poppins(
      textStyle: this,
    );
  }

  TextStyle get roboto {
    return GoogleFonts.roboto(
      textStyle: this,
    );
  }
}

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.
class CustomTextStyles {
  // Body text style
  static TextStyle get bodyLarge18 => theme.textTheme.bodyLarge!.copyWith(
        fontSize: 18.fSize,
      );
  static TextStyle get bodyLargeGray50003 =>
      theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray50003,
      );
  static TextStyle get bodyLargeGray60001 =>
      theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray60001,
      );
  static TextStyle get bodyLargeGray700 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray700,
      );
  static TextStyle get bodyLargeLight => theme.textTheme.bodyLarge!.copyWith(
        fontWeight: FontWeight.w300,
      );
  static TextStyle get bodyLargePoppinsGray50001 =>
      theme.textTheme.bodyLarge!.poppins.copyWith(
        color: appTheme.gray50001,
      );
  static TextStyle get bodyLargePoppinsOnPrimary =>
      theme.textTheme.bodyLarge!.poppins.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 17.fSize,
      );
  static TextStyle get bodyLargePrimary => theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 18.fSize,
      );
  static TextStyle get bodyMediumGray50004 =>
      theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray50004,
      );
  static TextStyle get bodyMediumGray600 =>
      theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray600.withValues(
          alpha: 0.72,
        ),
        fontSize: 15.fSize,
      );
  static TextStyle get bodyMediumOnPrimary =>
      theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 15.fSize,
      );
  static TextStyle get bodyMediumPrimary =>
      theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.primary,
      );
  static TextStyle get bodyMediumRobotoBluegray400 =>
      theme.textTheme.bodyMedium!.roboto.copyWith(
        color: appTheme.blueGray400,
        fontSize: 15.fSize,
      );
  static TextStyle get bodyMediumRobotoPrimary =>
      theme.textTheme.bodyMedium!.roboto.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 15.fSize,
      );
  static TextStyle get bodySmallGray50001 =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray50001,
        fontSize: 11.fSize,
      );
  static TextStyle get bodySmallGray50001_1 =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray50001,
      );
  static TextStyle get bodySmallGray50002 =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray50002,
      );
// Title text style
  static TextStyle get titleLargePrimary =>
      theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 22.fSize,
      );
}

