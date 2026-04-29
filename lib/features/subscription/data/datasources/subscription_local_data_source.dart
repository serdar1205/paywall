import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionLocalDataSource {
  static const String subscribedKey = 'is_subscribed';
  static const String selectedPlanKey = 'selected_plan';

  Future<bool> isSubscribed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(subscribedKey) ?? false;
  }

  Future<void> saveSubscribed({required String plan}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(subscribedKey, true);
    await prefs.setString(selectedPlanKey, plan);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(subscribedKey);
    await prefs.remove(selectedPlanKey);
  }
}
