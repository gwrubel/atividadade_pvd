import 'package:flutter/material.dart';
import 'constants.dart';

/// Helper para responsividade e escalonamento de texto
class ResponsiveHelper {
  /// Obtém o fator de escala baseado no tamanho da tela
  static double getTextScaleFactor(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < AppConstants.verySmallScreenBreakpoint) {
      return 0.8; // Telas muito pequenas
    } else if (screenWidth < AppConstants.smallScreenBreakpoint) {
      return 0.9; // Telas pequenas
    } else if (screenWidth < AppConstants.mobileBreakpoint) {
      return 1.0; // Mobile
    } else if (screenWidth < AppConstants.tabletBreakpoint) {
      return 1.1; // Tablet
    } else {
      return 1.2; // Desktop
    }
  }

  /// Obtém o tamanho da fonte responsivo
  static double getResponsiveFontSize(
    BuildContext context,
    double baseFontSize,
  ) {
    return baseFontSize * getTextScaleFactor(context);
  }

  /// Verifica se é uma tela muito pequena
  static bool isVerySmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width <
        AppConstants.verySmallScreenBreakpoint;
  }

  /// Verifica se é uma tela pequena
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width <
        AppConstants.smallScreenBreakpoint;
  }

  /// Verifica se é uma tela mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppConstants.mobileBreakpoint;
  }

  /// Verifica se é uma tela tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppConstants.mobileBreakpoint &&
        width < AppConstants.tabletBreakpoint;
  }

  /// Verifica se é uma tela desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppConstants.desktopBreakpoint;
  }

  /// Obtém o número de colunas para grid baseado no tamanho da tela
  static int getGridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= AppConstants.desktopBreakpoint) {
      return 4; // Desktop grande
    } else if (width >= AppConstants.tabletBreakpoint) {
      return 3; // Desktop/Tablet grande
    } else if (width >= AppConstants.mobileBreakpoint) {
      return 2; // Tablet/Desktop pequeno
    } else {
      return 1; // Mobile
    }
  }

  /// Obtém o padding responsivo
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < AppConstants.smallScreenBreakpoint) {
      return const EdgeInsets.all(AppConstants.smallPadding);
    } else if (width < AppConstants.mobileBreakpoint) {
      return const EdgeInsets.all(AppConstants.defaultPadding);
    } else {
      return const EdgeInsets.all(AppConstants.largePadding);
    }
  }

  /// Obtém o tamanho da imagem responsivo
  static double getResponsiveImageSize(
    BuildContext context, {
    double? small,
    double? medium,
    double? large,
  }) {
    final width = MediaQuery.of(context).size.width;

    if (width < AppConstants.smallScreenBreakpoint) {
      return small ?? 50.0;
    } else if (width < AppConstants.mobileBreakpoint) {
      return medium ?? 80.0;
    } else {
      return large ?? 100.0;
    }
  }

  /// Obtém o tamanho do ícone responsivo
  static double getResponsiveIconSize(
    BuildContext context, {
    double? small,
    double? medium,
    double? large,
  }) {
    final width = MediaQuery.of(context).size.width;

    if (width < AppConstants.smallScreenBreakpoint) {
      return small ?? 16.0;
    } else if (width < AppConstants.mobileBreakpoint) {
      return medium ?? 24.0;
    } else {
      return large ?? 32.0;
    }
  }

  /// Obtém o estilo de texto responsivo
  static TextStyle getResponsiveTextStyle(
    BuildContext context,
    TextStyle baseStyle,
  ) {
    final scaleFactor = getTextScaleFactor(context);
    return baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 14) * scaleFactor,
    );
  }

  /// Obtém o espaçamento responsivo
  static double getResponsiveSpacing(
    BuildContext context, {
    double? small,
    double? medium,
    double? large,
  }) {
    final width = MediaQuery.of(context).size.width;

    if (width < AppConstants.smallScreenBreakpoint) {
      return small ?? AppConstants.smallPadding;
    } else if (width < AppConstants.mobileBreakpoint) {
      return medium ?? AppConstants.defaultPadding;
    } else {
      return large ?? AppConstants.largePadding;
    }
  }
}
