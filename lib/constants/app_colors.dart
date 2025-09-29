import 'package:flutter/material.dart';

class AppColors {
  // Brand colors as per user preference
  static const Color primaryBlue = Color(0xFF0F172A);
  static const Color primaryGreen = Color(0xFF059669);
  static const Color primaryYellow = Color(0xFFF59E0B);
  
  // Neutral colors (shadcn style)
  static const Color background = Color(0xFFFFFFFF);
  static const Color foreground = Color(0xFF0F172A);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardForeground = Color(0xFF0F172A);
  static const Color popover = Color(0xFFFFFFFF);
  static const Color popoverForeground = Color(0xFF0F172A);
  static const Color primary = Color(0xFF0F172A);
  static const Color primaryForeground = Color(0xFFF8FAFC);
  static const Color secondary = Color(0xFFF1F5F9);
  static const Color secondaryForeground = Color(0xFF0F172A);
  static const Color muted = Color(0xFFF1F5F9);
  static const Color mutedForeground = Color(0xFF64748B);
  static const Color accent = Color(0xFFF1F5F9);
  static const Color accentForeground = Color(0xFF0F172A);
  static const Color destructive = Color(0xFFEF4444);
  static const Color destructiveForeground = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE2E8F0);
  static const Color input = Color(0xFFE2E8F0);
  static const Color ring = Color(0xFF0F172A);
  
  // Dark theme colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkForeground = Color(0xFFF8FAFC);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkCardForeground = Color(0xFFF8FAFC);
  static const Color darkPopover = Color(0xFF1E293B);
  static const Color darkPopoverForeground = Color(0xFFF8FAFC);
  static const Color darkPrimary = Color(0xFFF8FAFC);
  static const Color darkPrimaryForeground = Color(0xFF0F172A);
  static const Color darkSecondary = Color(0xFF334155);
  static const Color darkSecondaryForeground = Color(0xFFF8FAFC);
  static const Color darkMuted = Color(0xFF334155);
  static const Color darkMutedForeground = Color(0xFF94A3B8);
  static const Color darkAccent = Color(0xFF334155);
  static const Color darkAccentForeground = Color(0xFFF8FAFC);
  static const Color darkDestructive = Color(0xFFEF4444);
  static const Color darkDestructiveForeground = Color(0xFFF8FAFC);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkInput = Color(0xFF334155);
  static const Color darkRing = Color(0xFF94A3B8);
  
  // Status colors
  static const Color success = Color(0xFF059669);
  static const Color successForeground = Color(0xFFFFFFFF);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningForeground = Color(0xFF0F172A);
  static const Color error = Color(0xFFEF4444);
  static const Color errorForeground = Color(0xFFFFFFFF);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoForeground = Color(0xFFFFFFFF);
  
  // Banking specific colors
  static const Color credit = Color(0xFF059669);
  static const Color debit = Color(0xFFEF4444);
  static const Color pending = Color(0xFFF59E0B);
  
  // Legacy color mappings for compatibility
  static const Color textLight = primaryForeground;
  static const Color textPrimary = foreground;
  static const Color textSecondary = mutedForeground;
  static const Color lightBackground = background;
  static const Color lightCard = card;
  static const Color lightSurface = card;
  
  // Gradient colors
  static const List<Color> primaryGradient = [primaryBlue, primaryGreen];
  static const List<Color> successGradient = [Color(0xFF059669), Color(0xFF10B981)];
  static const List<Color> warningGradient = [Color(0xFFF59E0B), Color(0xFFFBBF24)];
  static const List<Color> errorGradient = [Color(0xFFEF4444), Color(0xFFF87171)];
}