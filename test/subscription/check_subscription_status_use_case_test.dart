import 'package:flutter_test/flutter_test.dart';
import 'package:paywall/features/subscription/domain/entities/subscription_plan.dart';
import 'package:paywall/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:paywall/features/subscription/domain/usecases/check_subscription_status_use_case.dart';

class _FakeSubscriptionRepository implements SubscriptionRepository {
  _FakeSubscriptionRepository({required this.subscribed});

  final bool subscribed;

  @override
  Future<void> clear() async {}

  @override
  Future<bool> isSubscribed() async => subscribed;

  @override
  Future<void> saveSubscribed(SubscriptionPlan plan) async {}
}

void main() {
  test('returns true when repository reports subscribed', () async {
    final repository = _FakeSubscriptionRepository(subscribed: true);
    final useCase = CheckSubscriptionStatusUseCase(repository);

    final result = await useCase();

    expect(result, isTrue);
  });
}
