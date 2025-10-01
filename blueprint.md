# Sổ Vườn 🌱 Blueprint

**돈을 심고, 미래를 키우다** | *Plant your money. Grow your future.*

베트남과 한국 사용자를 위한 게임화된 가계부 앱

## 1. 프로젝트 개요

Sổ Vườn은 가계부 기능과 정원 가꾸기 게임을 결합한 하이브리드 앱입니다. 사용자가 지출을 기록할 때마다 정원에 씨앗을 심고 식물을 키우며, 재무 관리를 즐거운 습관으로 만들 수 있도록 돕습니다.

---

## 2. 스타일, 디자인 및 기능 (초기 설정)

### 주요 기능

- 🌱 **5초 지출 입력**: 간단하고 빠른 지출 기록
- 🌳 **정원 가꾸기**: 기록할 때마다 성장하는 나만의 정원
- 📊 **통계 & 예산 관리**: 지출 분석과 예산 관리
- 🎯 **스트릭 시스템**: 연속 기록으로 동기부여
- 🛍️ **테마 & 아이템**: 정원을 꾸밀 수 있는 다양한 콘텐츠

### 기술 스택

- **Frontend**: Flutter 3.16+
- **Backend**: Firebase (Firestore, Auth, Functions, Storage, FCM)
- **State Management**: Riverpod
- **UI Components**: Material 3, Custom Widgets
- **Animation**: Lottie
- **Charts**: fl_chart
- **Monetization**: RevenueCat (구독 관리)

### 프로젝트 구조

```
apps/so-vuon/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── theme/          # 색상, 타이포, 테마
│   │   ├── widgets/        # 공통 위젯
│   │   ├── utils/          # 유틸리티 함수
│   │   └── providers.dart  # Riverpod Providers
│   ├── data/
│   │   ├── models/         # Freezed 데이터 모델
│   │   ├── sources/        # Firebase, API 클라이언트
│   │   └── repos/          # Repository 패턴
│   ├── features/
│   │   ├── onboarding/     # 온보딩
│   │   ├── home/           # 홈 화면
│   │   ├── entry/          # 지출 입력
│   │   ├── garden/         # 정원
│   │   ├── stats/          # 통계
│   │   ├── store/          # 스토어
│   │   └── settings/       # 설정
│   └── l10n/              # 다국어 지원
├── assets/
└── firebase/
```

---

## 3. 현재 작업 계획

**목표**: 제공된 "Sổ Vườn" 설정 가이드에 맞춰 프로젝트를 구성하고 실행 가능한 상태로 만듭니다.

**진행 단계**:

1.  ✅ **Blueprint.md 생성**: 프로젝트의 목표와 계획을 문서화합니다.
2.  **프로젝트 구조 확인 및 조정**: 가이드에 명시된 `lib` 폴더 구조와 현재 구조를 비교하고, 필요하다면 파일을 이동하여 가이드와 일치시킵니다.
3.  **코드 생성 실행**: `build_runner`를 실행하여 `freezed` 모델 등 필요한 파일들을 생성합니다.
4.  **Firebase 설정 확인**: `flutterfire configure`를 통해 생성되는 `firebase_options.dart` 파일이 올바르게 설정되었는지 확인하고, 없다면 생성합니다.
5.  **오류 분석 및 수정**: 전체 코드를 분석하여 발생할 수 있는 오류를 미리 확인하고 수정합니다.
