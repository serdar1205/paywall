import 'package:flutter/material.dart';

import '../../../subscription/domain/entities/subscription_plan.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({
    required this.plan,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final SubscriptionPlan plan;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isYearly = plan == SubscriptionPlan.yearly;
    final title = isYearly ? 'Yearly' : 'Monthly';
    final subtitle = isYearly ? '\$39.99/year (save 33%)' : '\$4.99/month';

    return Card(
      elevation: isSelected ? 2 : 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).dividerColor,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: isSelected ? const Icon(Icons.check_circle) : null,
      ),
    );
  }
}
