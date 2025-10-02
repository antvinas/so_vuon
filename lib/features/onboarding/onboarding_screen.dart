import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:so_vuon/features/onboarding/onboarding_vm.dart';
import 'package:so_vuon/l10n/app_localizations.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _completeOnboarding() {
    ref.read(onboardingViewModelProvider.notifier).completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onboardingVM = ref.watch(onboardingViewModelProvider);

    final List<Widget> onboardingPages = [
      _buildInfoPage(
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDescription1,
        imagePath: "assets/images/logo.png",
      ),
      _buildInfoPage(
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDescription2,
        imagePath: "assets/images/logo.png",
      ),
      _buildInfoPage(
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDescription3,
        imagePath: "assets/images/logo.png",
      ),
      _buildGoalSelectionPage(l10n, onboardingVM.selectedGoal),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: onboardingPages,
              ),
            ),
            _buildPageIndicator(onboardingPages.length),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _completeOnboarding,
                    child: Text(l10n.skip),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == onboardingPages.length - 1) {
                        _completeOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      }
                    },
                    child: Text(_currentPage == onboardingPages.length - 1
                        ? l10n.start
                        : l10n.next),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int pageCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: _currentPage == index ? 12.0 : 8.0,
          height: _currentPage == index ? 12.0 : 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
        );
      }),
    );
  }

  Widget _buildInfoPage({
    required String title,
    required String description,
    required String imagePath,
  }) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 200),
          const SizedBox(height: 48),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSelectionPage(AppLocalizations l10n, String? selectedGoal) {
    final goals = {
      'systematic': l10n.onboardingGoal1,
      'specific': l10n.onboardingGoal2,
      'fun': l10n.onboardingGoal3,
    };

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.onboardingGoalTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            children: goals.entries.map((entry) {
              return ChoiceChip(
                label: Text(entry.value),
                selected: selectedGoal == entry.key,
                onSelected: (bool selected) {
                  if (selected) {
                    ref.read(onboardingViewModelProvider.notifier).selectGoal(entry.key);
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
