
import 'package:flutter/material.dart';
import 'package:project/core/routing/app_router.dart';
import 'package:project/data/models/onbording_item.dart';
import 'package:project/features/onboarding/widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<OnboardingItem> _pages = [
    OnboardingItem(
      image: 'assets/images/splash1.jpg',
      title: 'Choose your place...',
      subtitle: 'and let comfort begin with a single tap',
    ),
    OnboardingItem(
      image: 'assets/images/splash2.jpg',
      title: 'Reserve instantly',
      subtitle: 'manage your bookings anytime & anywhere',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: _pages.length,
        onPageChanged: (i) => setState(() => _currentIndex = i),
        itemBuilder: (_, index) {
          final isLastPage = index == _pages.length - 1;
          return OnboardingPageWidget(
            item: _pages[index],
            pageCount: _pages.length,
            currentIndex: _currentIndex,
            buttonText: isLastPage ? 'Get Started' : 'Next',
            onPressed: () {
              if (isLastPage) {
                Navigator.pushReplacementNamed(context, AppRouter.signIn);
              } else {
                _controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          );
        },
      ),
    );
  }
}
