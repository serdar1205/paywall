import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum OnboardingStatus { idle, loading, success, failure }

class OnboardingState extends Equatable {
  const OnboardingState({
    required this.currentPage,
    required this.status,
    this.message,
  });

  final int currentPage;
  final OnboardingStatus status;
  final String? message;

  factory OnboardingState.initial() {
    return const OnboardingState(currentPage: 0, status: OnboardingStatus.idle);
  }

  OnboardingState copyWith({
    int? currentPage,
    OnboardingStatus? status,
    String? message,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      status: status ?? this.status,
      message: message,
    );
  }

  @override
  List<Object?> get props => [currentPage, status, message];
}

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingState.initial());

  static const int totalPages = 2;

  void onPageChanged(int index) {
    emit(state.copyWith(currentPage: index, status: OnboardingStatus.idle));
  }

  void continueFlow() {
    if (state.currentPage < totalPages - 1) {
      emit(
        state.copyWith(
          currentPage: state.currentPage + 1,
          status: OnboardingStatus.loading,
          message: null,
        ),
      );
      emit(state.copyWith(status: OnboardingStatus.idle, message: null));
      return;
    }
    emit(state.copyWith(status: OnboardingStatus.success, message: null));
  }
}
