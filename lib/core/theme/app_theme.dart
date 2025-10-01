import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:so_vuon/core/theme/colors.dart';

// 앱의 라이트/다크 테마를 정의합니다.
class AppTheme {
  // --- 라이트 테마 ---
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: SoVuonColors.neutral10, // 기본 배경색
    primaryColor: SoVuonColors.primary,
    colorScheme: const ColorScheme.light(
      primary: SoVuonColors.primary,
      secondary: SoVuonColors.accent,
      error: SoVuonColors.error,
      surface: SoVuonColors.neutral0,
      onPrimary: SoVuonColors.neutral0,
      onSecondary: SoVuonColors.neutral100,
      onSurface: SoVuonColors.neutral80,
      onError: SoVuonColors.neutral0,
    ),

    // 텍스트 테마 (Google Fonts 사용)
    textTheme: GoogleFonts.ibmPlexSansKrTextTheme(
      const TextTheme(
        displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.bold, color: SoVuonColors.neutral80),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: SoVuonColors.neutral80),
        bodyLarge: TextStyle(fontSize: 16, color: SoVuonColors.neutral80),
        bodyMedium: TextStyle(fontSize: 14, color: SoVuonColors.neutral60),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: SoVuonColors.primary),
      ),
    ),

    // 앱바 테마
    appBarTheme: AppBarTheme(
      backgroundColor: SoVuonColors.neutral10,
      foregroundColor: SoVuonColors.neutral80,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.ibmPlexSansKr(
        fontSize: 18, 
        fontWeight: FontWeight.w600, 
        color: SoVuonColors.neutral80
      ),
    ),

    // 버튼 테마
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: SoVuonColors.primary,
        foregroundColor: SoVuonColors.neutral0,
        textStyle: GoogleFonts.ibmPlexSansKr(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
  );

  // --- 다크 테마 (추후 상세 구현) ---
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: SoVuonColors.neutral100,
    primaryColor: SoVuonColors.primaryLight,
    colorScheme: const ColorScheme.dark(
      primary: SoVuonColors.primaryLight,
      secondary: SoVuonColors.accent,
      error: SoVuonColors.warningRed,
      surface: SoVuonColors.neutral80,
      onPrimary: SoVuonColors.neutral100,
      onSecondary: SoVuonColors.neutral100,
      onSurface: SoVuonColors.neutral10,
      onError: SoVuonColors.neutral0,
    ),

    // 텍스트 테마 (Google Fonts 사용)
    textTheme: GoogleFonts.ibmPlexSansKrTextTheme(
       const TextTheme(
        displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.bold, color: SoVuonColors.neutral10),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: SoVuonColors.neutral10),
        bodyLarge: TextStyle(fontSize: 16, color: SoVuonColors.neutral10),
        bodyMedium: TextStyle(fontSize: 14, color: SoVuonColors.neutral40),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: SoVuonColors.primaryLight),
      ),
    ),
  );
}
