import '../../domain/entities/subscription_plan.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/subscription_local_data_source.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  SubscriptionRepositoryImpl(this._localDataSource);

  final SubscriptionLocalDataSource _localDataSource;

  @override
  Future<bool> isSubscribed() {
    return _localDataSource.isSubscribed();
  }

  @override
  Future<void> saveSubscribed(SubscriptionPlan plan) {
    return _localDataSource.saveSubscribed(plan: plan.name);
  }

  @override
  Future<void> clear() {
    return _localDataSource.clear();
  }
}
