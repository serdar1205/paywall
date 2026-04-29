import '../entities/subscription_plan.dart';
import '../repositories/subscription_repository.dart';

class PurchaseSubscriptionUseCase {
  PurchaseSubscriptionUseCase(this._repository);

  final SubscriptionRepository _repository;

  Future<void> call(SubscriptionPlan plan) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    await _repository.saveSubscribed(plan);
  }
}
