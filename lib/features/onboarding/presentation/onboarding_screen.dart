import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/widgets/primary_button.dart';
import '../../paywall/presentation/paywall_screen.dart';
import '../application/onboarding_cubit.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == OnboardingStatus.success) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(builder: (_) => const PaywallScreen()),
          );
          return;
        }
        if (state.status == OnboardingStatus.loading) {
          _pageController.animateToPage(
            state.currentPage,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: context
                        .read<OnboardingCubit>()
                        .onPageChanged,
                    children: const [
                      _OnboardingPage(
                        title: 'Добро пожаловать',
                        description:
                            'Откройте премиум-контент с простой подпиской.',
                        icon: Icons.rocket_launch_outlined,
                      ),
                      _OnboardingPage(
                        title: 'Оставайтесь продуктивными',
                        description:
                            'Разблокируйте все функции и сохраняйте прогресс с премиум-доступом.',
                        icon: Icons.workspace_premium_outlined,
                      ),
                    ],
                  ),
                ),
                BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (context, state) {
                    return PrimaryButton(
                      label: 'Продолжить',
                      onPressed: context.read<OnboardingCubit>().continueFlow,
                      isLoading: false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 88, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 20),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
