import 'package:flutter/material.dart';
import '../core/app_export.dart';
import 'package:google_fonts/google_fonts.dart';

String _appTheme = "lightCode";
LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.

// ignore_for_file: must_be_immutable
class ThemeHelper {
  // A map of custom color themes supported by the app
  final Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors()
  };

// A map of color schemes supported by the app
  final Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme
  };

  /// Changes the app theme to [_newTheme].
  void changeTheme(String _newTheme) {
    _appTheme = _newTheme;
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          side: BorderSide(
            color: appTheme.blueGray10003,
            width: 1.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.h),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: appTheme.gray400,
      ),
    );
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyLarge: GoogleFonts.roboto(
          textStyle: TextStyle(
            color: appTheme.blueGray400,
            fontSize: 16.fSize,
            fontWeight: FontWeight.w400,
          ),
        ),
        bodyMedium: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: appTheme.gray50001,
            fontSize: 14.fSize,
            fontWeight: FontWeight.w400,
          ),
        ),
        bodySmall: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: appTheme.gray50004,
            fontSize: 12.fSize,
            fontWeight: FontWeight.w400,
          ),
        ),
        titleLarge: GoogleFonts.roboto(
          textStyle: TextStyle(
            color: appTheme.gray600,
            fontSize: 20.fSize,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light(
    primary: Color(0XFF6D50CE),
    onPrimary: Color(0XFFFFFFFF),
    onPrimaryContainer: Color(0X19FF0000),
  );
}

/// Class containing custom colors for a lightCode theme.
class LightCodeColors {
  // Black
  Color get black9001c => Color(0X1C000000);
// BlueGray
  Color get blueGray100 => Color(0XFFD3D3D3);
  Color get blueGray10001 => Color(0XFFD1D1D1);
  Color get blueGray10002 => Color(0XFFD6D6D6);
  Color get blueGray10003 => Color(0XFFD5D5D5);
  Color get blueGray10004 => Color(0XFFD2D2D2);
  Color get blueGray400 => Color(0XFF868686);
// Gray
  Color get gray100 => Color(0XFFF5F5F5);
  Color get gray200 => Color(0XFFE7E7E7);
  Color get gray400 => Color(0XFFCACACA);
  Color get gray40001 => Color(0XFFB3B3B3);
  Color get gray50 => Color(0XFFF9F9F9);
  Color get gray500 => Color(0XFF979797);
  Color get gray50001 => Color(0XFF999999);
  Color get gray50002 => Color(0XFFA8A8A8);
  Color get gray50003 => Color(0XFF939393);
  Color get gray50004 => Color(0XFF929292);
  Color get gray50005 => Color(0XFF969696);
  Color get gray5001 => Color(0XFFF8F8F8);
  Color get gray600 => Color(0XFF717171);
  Color get gray60001 => Color(0XFF757575);
  Color get gray700 => Color(0XFF666666);
// Red
  Color get red900 => Color(0XFF9C0000);
}

