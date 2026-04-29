import '../entities/subscription_plan.dart';

abstract class SubscriptionRepository {
  Future<bool> isSubscribed();
  Future<void> saveSubscribed(SubscriptionPlan plan);
  Future<void> clear();
}
