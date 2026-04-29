import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/home/presentation/home_screen.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/subscription/application/launch/launch_cubit.dart';
import 'features/subscription/data/datasources/subscription_local_data_source.dart';
import 'features/subscription/data/repositories/subscription_repository_impl.dart';
import 'features/subscription/domain/usecases/check_subscription_status_use_case.dart';
import 'features/subscription/domain/usecases/purchase_subscription_use_case.dart';

class PaywallApp extends StatefulWidget {
  const PaywallApp({super.key});

  @override
  State<PaywallApp> createState() => _PaywallAppState();
}

class _PaywallAppState extends State<PaywallApp> {
  late final SubscriptionRepositoryImpl _subscriptionRepository;
  late final CheckSubscriptionStatusUseCase _checkSubscriptionStatusUseCase;
  late final PurchaseSubscriptionUseCase _purchaseSubscriptionUseCase;

  @override
  void initState() {
    super.initState();
    final localDataSource = SubscriptionLocalDataSource();
    _subscriptionRepository = SubscriptionRepositoryImpl(localDataSource);
    _checkSubscriptionStatusUseCase = CheckSubscriptionStatusUseCase(
      _subscriptionRepository,
    );
    _purchaseSubscriptionUseCase = PurchaseSubscriptionUseCase(
      _subscriptionRepository,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CheckSubscriptionStatusUseCase>.value(
          value: _checkSubscriptionStatusUseCase,
        ),
        RepositoryProvider<PurchaseSubscriptionUseCase>.value(
          value: _purchaseSubscriptionUseCase,
        ),
      ],
      child: MaterialApp(
        title: 'Paywall Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: BlocProvider(
          create: (context) =>
              LaunchCubit(checkSubscriptionStatusUseCase: context.read())
                ..initialize(),
          child: const _LaunchGate(),
        ),
      ),
    );
  }
}

class _LaunchGate extends StatelessWidget {
  const _LaunchGate();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LaunchCubit, LaunchState>(
      builder: (context, state) {
        switch (state.status) {
          case LaunchStatus.loading:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case LaunchStatus.subscribed:
            return const HomeScreen();
          case LaunchStatus.unsubscribed:
            return const OnboardingScreen();
          case LaunchStatus.failure:
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    state.message ?? 'Could not load subscription status.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}
