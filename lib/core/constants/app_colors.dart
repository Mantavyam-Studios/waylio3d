import 'package:flutter/material.dart';

/// Material Design 3 Color Palette - Neutral Theme
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2C3E50); // Charcoal Gray
  static const Color primaryLight = Color(0xFF34495E);
  static const Color primaryDark = Color(0xFF1A252F);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF3498DB); // Soft Blue
  static const Color secondaryLight = Color(0xFF5DADE2);
  static const Color secondaryDark = Color(0xFF2874A6);
  
  // Accent Colors
  static const Color accent = Color(0xFFF39C12); // Warm Amber
  static const Color accentLight = Color(0xFFF5B041);
  static const Color accentDark = Color(0xFFD68910);
  
  // Background Colors
  static const Color background = Color(0xFFECF0F1); // Light Gray
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color surfaceVariant = Color(0xFFF8F9FA);
  
  // Status Colors
  static const Color error = Color(0xFFE74C3C); // Soft Red
  static const Color success = Color(0xFF27AE60); // Soft Green
  static const Color warning = Color(0xFFF39C12); // Warm Amber
  static const Color info = Color(0xFF3498DB); // Soft Blue
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textDisabled = Color(0xFFBDC3C7);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);
  
  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFF0F0F0);
  static const Color borderDark = Color(0xFFBDBDBD);
  
  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowDark = Color(0x33000000);
  
  // AR Navigation Colors
  static const Color arPath = Color(0xFF3498DB);
  static const Color arWaypoint = Color(0xFFF39C12);
  static const Color arDestination = Color(0xFF27AE60);
  
  // Category Colors
  static const Color categoryClassroom = Color(0xFF3498DB);
  static const Color categoryLaboratory = Color(0xFF9B59B6);
  static const Color categoryOffice = Color(0xFFE67E22);
  static const Color categoryFacility = Color(0xFF16A085);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

