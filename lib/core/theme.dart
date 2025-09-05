import 'package:flutter/material.dart';
import 'constants.dart';

/// Tema personalizado do sistema PDV
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(AppColors.primaryColorValue),
        brightness: Brightness.light,
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 2,
        scrolledUnderElevation: 4,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: AppConstants.smallPadding,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppConstants.borderRadius),
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(
            color: Color(AppColors.primaryColorValue),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: Color(AppColors.errorColorValue)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(
            color: Color(AppColors.errorColorValue),
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: AppConstants.defaultPadding,
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(AppColors.textPrimaryValue),
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(AppColors.textPrimaryValue),
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(AppColors.textPrimaryValue),
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(AppColors.textPrimaryValue),
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(AppColors.textPrimaryValue),
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(AppColors.textPrimaryValue),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Color(AppColors.textPrimaryValue),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(AppColors.textPrimaryValue),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: Color(AppColors.textSecondaryValue),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(AppColors.textPrimaryValue),
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(AppColors.textPrimaryValue),
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Color(AppColors.textSecondaryValue),
        ),
      ),

      // SnackBar Theme
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(AppColors.textPrimaryValue),
        ),
        contentTextStyle: const TextStyle(
          fontSize: 16,
          color: Color(AppColors.textPrimaryValue),
        ),
      ),
    );
  }

  // Cores específicas para cada tela
  static const Map<String, Color> screenColors = {
    'products': Color(AppColors.productsScreenColorValue),
    'cart': Color(AppColors.cartScreenColorValue),
    'payment': Color(AppColors.paymentScreenColorValue),
    'addProduct': Color(AppColors.addProductScreenColorValue),
  };

  // Cores de status
  static const Map<String, Color> statusColors = {
    'success': Color(AppColors.successColorValue),
    'error': Color(AppColors.errorColorValue),
    'warning': Color(AppColors.warningColorValue),
    'price': Color(AppColors.priceColorValue),
    'badge': Color(AppColors.badgeColorValue),
  };
}

/// Extensões para facilitar o uso das cores
extension AppColorsExtension on Color {
  static Color get primary => const Color(AppColors.primaryColorValue);
  static Color get secondary => const Color(AppColors.secondaryColorValue);
  static Color get accent => const Color(AppColors.accentColorValue);
  static Color get error => const Color(AppColors.errorColorValue);
  static Color get success => const Color(AppColors.successColorValue);
  static Color get warning => const Color(AppColors.warningColorValue);
  static Color get price => const Color(AppColors.priceColorValue);
  static Color get badge => const Color(AppColors.badgeColorValue);
  static Color get disabled => const Color(AppColors.disabledColorValue);
}
