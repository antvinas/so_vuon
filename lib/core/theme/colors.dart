import 'package:flutter/material.dart';

// Sổ Vườn 앱에서 사용할 색상 팔레트를 정의합니다.
class SoVuonColors {
  // Primary Colors
  static const Color primary = Color(0xFF4A7C59);       // 주 색상 (짙은 녹색)
  static const Color primaryLight = Color(0xFF78AB86);   // 밝은 주 색상
  static const Color primaryDark = Color(0xFF2B4F39);    // 어두운 주 색상

  // Accent & Special Colors
  static const Color accent = Color(0xFFF2C94C);         // 강조 색상 (노란색)
  static const Color gardenGreen = Color(0xFF6fbf73);    // 정원/성장 관련 색상 (밝은 녹색)
  static const Color warningRed = Color(0xFFEB5757);      // 경고/삭제 색상 (빨간색)

  // Neutral (Grayscale) Colors - 중립 회색조
  static const Color neutral100 = Color(0xFF000000);   // 가장 어두운 색 (纯黑)
  static const Color neutral80 = Color(0xFF333333);    // 본문 텍스트 등에 사용
  static const Color neutral60 = Color(0xFF828282);    // 부가 정보, 아이콘 등에 사용
  static const Color neutral40 = Color(0xFFBDBDBD);    // 비활성, 구분선 등에 사용
  static const Color neutral20 = Color(0xFFE0E0E0);    // 배경보다 약간 어두운 색
  static const Color neutral10 = Color(0xFFF5F5F5);    // 기본 배경색
  static const Color neutral0 = Color(0xFFFFFFFF);     // 가장 밝은 색 (纯白)

  // Semantic Colors - 의미 색상
  static const Color success = Color(0xFF27AE60);
  static const Color info = Color(0xFF2F80ED);
  static const Color error = Color(0xFFEB5757);
  
}
