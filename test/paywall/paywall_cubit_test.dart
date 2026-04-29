import 'package:flutter_test/flutter_test.dart';
import 'package:paywall/features/paywall/application/paywall_cubit.dart';
import 'package:paywall/features/subscription/domain/entities/subscription_plan.dart';
import 'package:paywall/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:paywall/features/subscription/domain/usecases/purchase_subscription_use_case.dart';

class _FakeSubscriptionRepository implements SubscriptionRepository {
  _FakeSubscriptionRepository({required this.shouldThrow});

  final bool shouldThrow;

  @override
  Future<void> clear() async {}

  @override
  Future<bool> isSubscribed() async => false;

  @override
  Future<void> saveSubscribed(SubscriptionPlan plan) async {
    if (shouldThrow) {
      throw Exception('Save failed');
    }
  }
}

void main() {
  test('emits loading then success when purchase completes', () async {
    final repository = _FakeSubscriptionRepository(shouldThrow: false);
    final useCase = PurchaseSubscriptionUseCase(repository);
    final cubit = PaywallCubit(purchaseSubscriptionUseCase: useCase);

    final statusExpectation = expectLater(
      cubit.stream.map((state) => state.status),
      emitsInOrder([PaywallStatus.loading, PaywallStatus.success]),
    );

    await cubit.purchase();
    await statusExpectation;
    await cubit.close();
  });
}
