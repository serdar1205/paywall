import '../repositories/subscription_repository.dart';

class CheckSubscriptionStatusUseCase {
  CheckSubscriptionStatusUseCase(this._repository);

  final SubscriptionRepository _repository;

  Future<bool> call() {
    return _repository.isSubscribed();
  }
}
