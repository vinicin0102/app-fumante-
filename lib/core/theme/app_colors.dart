import 'package:flutter/material.dart';

/// Paleta de cores do QuitNow Pro
/// Inspirada em natureza, saúde e bem-estar
class AppColors {
  AppColors._();

  // ==================== CORES PRINCIPAIS ====================
  
  /// Verde principal - representa saúde e renovação
  static const Color primary = Color(0xFF2DD4BF); // Teal-400
  static const Color primaryDark = Color(0xFF14B8A6); // Teal-500
  static const Color primaryLight = Color(0xFF5EEAD4); // Teal-300
  
  /// Roxo secundário - representa calma e equilíbrio
  static const Color secondary = Color(0xFF8B5CF6); // Violet-500
  static const Color secondaryDark = Color(0xFF7C3AED); // Violet-600
  static const Color secondaryLight = Color(0xFFA78BFA); // Violet-400
  
  /// Laranja accent - energia positiva
  static const Color accent = Color(0xFFF97316); // Orange-500
  static const Color accentDark = Color(0xFFEA580C); // Orange-600
  static const Color accentLight = Color(0xFFFB923C); // Orange-400

  // ==================== CORES DE STATUS ====================
  
  /// Sucesso - conquistas alcançadas
  static const Color success = Color(0xFF22C55E); // Green-500
  static const Color successLight = Color(0xFF4ADE80); // Green-400
  static const Color successBg = Color(0xFFDCFCE7); // Green-100
  
  /// Warning - atenção necessária
  static const Color warning = Color(0xFFEAB308); // Yellow-500
  static const Color warningLight = Color(0xFFFACC15); // Yellow-400
  static const Color warningBg = Color(0xFFFEF9C3); // Yellow-100
  
  /// Erro/Alerta - recaídas, crises
  static const Color error = Color(0xFFEF4444); // Red-500
  static const Color errorDark = Color(0xFFDC2626); // Red-600
  static const Color errorLight = Color(0xFFF87171); // Red-400
  static const Color errorBg = Color(0xFFFEE2E2); // Red-100
  
  /// Info - informações neutras
  static const Color info = Color(0xFF3B82F6); // Blue-500
  static const Color infoLight = Color(0xFF60A5FA); // Blue-400
  static const Color infoBg = Color(0xFFDBEAFE); // Blue-100

  // ==================== CORES DE FUNDO (LIGHT) ====================
  
  static const Color backgroundLight = Color(0xFFF8FAFC); // Slate-50
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  
  // ==================== CORES DE FUNDO (DARK) ====================
  
  static const Color backgroundDark = Color(0xFF0F172A); // Slate-900
  static const Color surfaceDark = Color(0xFF1E293B); // Slate-800
  static const Color cardDark = Color(0xFF334155); // Slate-700

  // ==================== CORES DE TEXTO (LIGHT) ====================
  
  static const Color textPrimaryLight = Color(0xFF1E293B); // Slate-800
  static const Color textSecondaryLight = Color(0xFF64748B); // Slate-500
  static const Color textTertiaryLight = Color(0xFF94A3B8); // Slate-400
  static const Color dividerLight = Color(0xFFE2E8F0); // Slate-200

  // ==================== CORES DE TEXTO (DARK) ====================
  
  static const Color textPrimaryDark = Color(0xFFF1F5F9); // Slate-100
  static const Color textSecondaryDark = Color(0xFF94A3B8); // Slate-400
  static const Color textTertiaryDark = Color(0xFF64748B); // Slate-500
  static const Color dividerDark = Color(0xFF334155); // Slate-700

  // ==================== GRADIENTES ====================
  
  /// Gradiente principal do app
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF0D9488)], // Teal-400 to Teal-600
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Gradiente para cards de destaque
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, Color(0xFFDC2626)], // Orange to Red
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Gradiente para conquistas
  static const LinearGradient achievementGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFA500)], // Gold gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Gradiente secundário
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, Color(0xFF6D28D9)], // Violet gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Gradiente para modo escuro
  static const LinearGradient darkGradient = LinearGradient(
    colors: [backgroundDark, surfaceDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ==================== CORES DE PROGRESSO ====================
  
  /// Cores para indicador de streak/progresso
  static Color getStreakColor(int days) {
    if (days < 1) return error;
    if (days < 3) return errorLight;
    if (days < 7) return warning;
    if (days < 14) return warningLight;
    if (days < 30) return success;
    if (days < 90) return successLight;
    return primary;
  }
  
  /// Cores para nível de vontade/craving
  static Color getCravingColor(int level) {
    if (level <= 2) return success;
    if (level <= 4) return successLight;
    if (level <= 6) return warning;
    if (level <= 8) return errorLight;
    return error;
  }
  
  /// Cores para humor
  static Color getMoodColor(int mood) {
    switch (mood) {
      case 1:
        return error;
      case 2:
        return errorLight;
      case 3:
        return warning;
      case 4:
        return successLight;
      case 5:
        return success;
      default:
        return textSecondaryLight;
    }
  }

  // ==================== CORES DE CATEGORIA ====================
  
  /// Cores para tipos de exercício TCC
  static const Color breathingExercise = Color(0xFF06B6D4); // Cyan-500
  static const Color cognitiveExercise = Color(0xFF8B5CF6); // Violet-500
  static const Color behavioralExercise = Color(0xFFF97316); // Orange-500
  static const Color relaxationExercise = Color(0xFF10B981); // Emerald-500
  
  /// Cores para gatilhos
  static const Color triggerCoffee = Color(0xFF92400E); // Amber-800
  static const Color triggerStress = Color(0xFFDC2626); // Red-600
  static const Color triggerSocial = Color(0xFF2563EB); // Blue-600
  static const Color triggerBoredom = Color(0xFF6B7280); // Gray-500
  static const Color triggerMeal = Color(0xFF16A34A); // Green-600
  static const Color triggerAlcohol = Color(0xFF9333EA); // Purple-600
}
