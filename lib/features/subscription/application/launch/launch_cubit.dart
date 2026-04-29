import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/check_subscription_status_use_case.dart';

enum LaunchStatus { loading, subscribed, unsubscribed, failure }

class LaunchState extends Equatable {
  const LaunchState({required this.status, this.message});

  final LaunchStatus status;
  final String? message;

  factory LaunchState.initial() {
    return const LaunchState(status: LaunchStatus.loading);
  }

  LaunchState copyWith({LaunchStatus? status, String? message}) {
    return LaunchState(status: status ?? this.status, message: message);
  }

  @override
  List<Object?> get props => [status, message];
}

class LaunchCubit extends Cubit<LaunchState> {
  LaunchCubit({
    required CheckSubscriptionStatusUseCase checkSubscriptionStatusUseCase,
  }) : _checkSubscriptionStatusUseCase = checkSubscriptionStatusUseCase,
       super(LaunchState.initial());

  final CheckSubscriptionStatusUseCase _checkSubscriptionStatusUseCase;

  Future<void> initialize() async {
    emit(state.copyWith(status: LaunchStatus.loading, message: null));
    try {
      final subscribed = await _checkSubscriptionStatusUseCase();
      emit(
        state.copyWith(
          status: subscribed
              ? LaunchStatus.subscribed
              : LaunchStatus.unsubscribed,
          message: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: LaunchStatus.failure,
          message: 'Что-то пошло не так. Пожалуйста, перезапустите приложение.',
        ),
      );
    }
  }
}
