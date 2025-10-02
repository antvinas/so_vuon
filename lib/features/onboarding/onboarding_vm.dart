import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// 온보딩 상태를 나타내는 클래스
class OnboardingState {
  final bool isOnboardingCompleted;
  final String? selectedGoal;

  OnboardingState({required this.isOnboardingCompleted, this.selectedGoal});
}

class OnboardingViewModel extends StateNotifier<OnboardingState> {
  final Box _appSettingsBox;

  OnboardingViewModel(this._appSettingsBox)
      : super(OnboardingState(
          isOnboardingCompleted: _appSettingsBox.get('onboarding_completed', defaultValue: false),
          selectedGoal: _appSettingsBox.get('user_goal'),
        ));

  void selectGoal(String goal) {
    state = OnboardingState(
      isOnboardingCompleted: state.isOnboardingCompleted,
      selectedGoal: goal,
    );
  }

  Future<void> completeOnboarding() async {
    await _appSettingsBox.put('onboarding_completed', true);
    if (state.selectedGoal != null) {
      await _appSettingsBox.put('user_goal', state.selectedGoal);
    }
    state = OnboardingState(
      isOnboardingCompleted: true,
      selectedGoal: state.selectedGoal,
    );
  }

  bool get isOnboardingCompleted => state.isOnboardingCompleted;
}

// Hive Box를 제공하는 Provider
final appSettingsBoxProvider = Provider<Box>((ref) {
  return Hive.box('app_settings');
});

// OnboardingViewModel을 제공하는 StateNotifierProvider
final onboardingViewModelProvider = StateNotifierProvider<OnboardingViewModel, OnboardingState>((ref) {
  final box = ref.watch(appSettingsBoxProvider);
  return OnboardingViewModel(box);
});
