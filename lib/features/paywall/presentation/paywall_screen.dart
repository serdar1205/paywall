import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/widgets/primary_button.dart';
import '../../home/presentation/home_screen.dart';
import '../../subscription/domain/entities/subscription_plan.dart';
import '../../subscription/domain/usecases/purchase_subscription_use_case.dart';
import '../application/paywall_cubit.dart';
import 'widgets/plan_card.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaywallCubit(
        purchaseSubscriptionUseCase: context
            .read<PurchaseSubscriptionUseCase>(),
      ),
      child: const _PaywallView(),
    );
  }
}

class _PaywallView extends StatelessWidget {
  const _PaywallView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaywallCubit, PaywallState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == PaywallStatus.success) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
            (route) => false,
          );
          return;
        }
        if (state.status == PaywallStatus.failure && state.message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message!)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Upgrade to Premium')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get unlimited access',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose a plan and continue to unlock all premium features.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                BlocBuilder<PaywallCubit, PaywallState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        PlanCard(
                          plan: SubscriptionPlan.monthly,
                          isSelected:
                              state.selectedPlan == SubscriptionPlan.monthly,
                          onTap: () {
                            context.read<PaywallCubit>().selectPlan(
                              SubscriptionPlan.monthly,
                            );
                          },
                        ),
                        PlanCard(
                          plan: SubscriptionPlan.yearly,
                          isSelected:
                              state.selectedPlan == SubscriptionPlan.yearly,
                          onTap: () {
                            context.read<PaywallCubit>().selectPlan(
                              SubscriptionPlan.yearly,
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
                const Spacer(),
                BlocBuilder<PaywallCubit, PaywallState>(
                  builder: (context, state) {
                    return PrimaryButton(
                      label: 'Continue',
                      isLoading: state.status == PaywallStatus.loading,
                      onPressed: state.status == PaywallStatus.loading
                          ? null
                          : context.read<PaywallCubit>().purchase,
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
