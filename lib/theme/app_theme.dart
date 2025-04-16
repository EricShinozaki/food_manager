import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class AppColors {
  // These can be used for any custom colors not covered by the theme
  static const Color nutritionItemBackground = Color(0xFFF5F5F5);
  static const Color deleteIcon = Color(0xFFE53935);
  static const Color formBackground = Color(0xFFFFFFFF);
  static const Color buttonBackground = Colors.lightBlue;
  static const buttonText = Colors.black;
}

class AppTheme {
  // Constants for consistent styling
  static const double defaultBorderRadius = 20.0;
  static const EdgeInsets defaultFormMargin = EdgeInsets.symmetric(horizontal: 20, vertical: 5);
  static const EdgeInsets largerFormMargin = EdgeInsets.symmetric(horizontal: 20, vertical: 15);

  // Custom FlexColorScheme setup
  static ThemeData getLightTheme() {
    return FlexThemeData.light(
      scheme: FlexScheme.hippieBlue,
      useMaterial3: true,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 9,
      subThemesData: const FlexSubThemesData(
        // Form elements
        inputDecoratorRadius: defaultBorderRadius,
        inputDecoratorBorderWidth: 1.0,

        // Buttons
        elevatedButtonRadius: defaultBorderRadius,
        textButtonRadius: defaultBorderRadius,
        filledButtonRadius: defaultBorderRadius,

        // Cards and containers
        cardRadius: defaultBorderRadius,
        dialogRadius: defaultBorderRadius,

        // Others
        chipRadius: 8.0,
        tooltipRadius: 4.0,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
    );
  }

  static ThemeData getDarkTheme() {
    return FlexThemeData.dark(
      scheme: FlexScheme.ebonyClay,
      useMaterial3: true,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 9,
      subThemesData: const FlexSubThemesData(
        // Form elements
        inputDecoratorRadius: defaultBorderRadius,
        inputDecoratorBorderWidth: 1.0,

        // Buttons
        elevatedButtonRadius: defaultBorderRadius,
        textButtonRadius: defaultBorderRadius,
        filledButtonRadius: defaultBorderRadius,

        // Cards and containers
        cardRadius: defaultBorderRadius,
        dialogRadius: defaultBorderRadius,

        // Others
        chipRadius: 8.0,
        tooltipRadius: 4.0,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
    );
  }

  // Pre-defined button styles
  static ButtonStyle filledTonalButtonStyle(BuildContext context) {
    return FilledButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
    );
  }

  // Pre-defined input decoration
  static InputDecoration inputDecoration(String label) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      labelText: label,
    );
  }
}