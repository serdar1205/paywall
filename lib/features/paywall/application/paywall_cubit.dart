import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../subscription/domain/entities/subscription_plan.dart';
import '../../subscription/domain/usecases/purchase_subscription_use_case.dart';

enum PaywallStatus { idle, loading, success, failure }

class PaywallState extends Equatable {
  const PaywallState({
    required this.status,
    required this.selectedPlan,
    this.message,
  });

  final PaywallStatus status;
  final SubscriptionPlan selectedPlan;
  final String? message;

  factory PaywallState.initial() {
    return const PaywallState(
      status: PaywallStatus.idle,
      selectedPlan: SubscriptionPlan.monthly,
    );
  }

  PaywallState copyWith({
    PaywallStatus? status,
    SubscriptionPlan? selectedPlan,
    String? message,
  }) {
    return PaywallState(
      status: status ?? this.status,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, selectedPlan, message];
}

class PaywallCubit extends Cubit<PaywallState> {
  PaywallCubit({
    required PurchaseSubscriptionUseCase purchaseSubscriptionUseCase,
  }) : _purchaseSubscriptionUseCase = purchaseSubscriptionUseCase,
       super(PaywallState.initial());

  final PurchaseSubscriptionUseCase _purchaseSubscriptionUseCase;

  void selectPlan(SubscriptionPlan plan) {
    emit(
      state.copyWith(
        selectedPlan: plan,
        status: PaywallStatus.idle,
        message: null,
      ),
    );
  }

  Future<void> purchase() async {
    emit(state.copyWith(status: PaywallStatus.loading, message: null));
    try {
      await _purchaseSubscriptionUseCase(state.selectedPlan);
      emit(state.copyWith(status: PaywallStatus.success, message: null));
    } catch (_) {
      emit(
        state.copyWith(
          status: PaywallStatus.failure,
          message: 'Покупка не удалась. Пожалуйста, попробуйте еще раз.',
        ),
      );
    }
  }
}
