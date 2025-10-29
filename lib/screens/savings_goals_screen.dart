import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../providers/auth_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/ui_components.dart';

class SavingsGoalsScreen extends StatefulWidget {
  const SavingsGoalsScreen({super.key});

  @override
  State<SavingsGoalsScreen> createState() => _SavingsGoalsScreenState();
}

class _SavingsGoalsScreenState extends State<SavingsGoalsScreen> {
  final List<SavingsGoal> _goals = [
    SavingsGoal(
      id: '1',
      name: 'Emergency Fund',
      targetAmount: 10000,
      currentAmount: 6500,
      deadline: DateTime.now().add(const Duration(days: 180)),
      icon: LucideIcons.shield,
      color: AppColors.primary,
    ),
    SavingsGoal(
      id: '2',
      name: 'Vacation',
      targetAmount: 5000,
      currentAmount: 2300,
      deadline: DateTime.now().add(const Duration(days: 120)),
      icon: LucideIcons.plane,
      color: AppColors.success,
    ),
    SavingsGoal(
      id: '3',
      name: 'New Car',
      targetAmount: 25000,
      currentAmount: 8500,
      deadline: DateTime.now().add(const Duration(days: 365)),
      icon: LucideIcons.car,
      color: AppColors.info,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Goals'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            onPressed: () => _showAddGoalDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                final totalSaved = _goals.fold<double>(
                  0,
                  (sum, goal) => sum + goal.currentAmount,
                );
                final totalTarget = _goals.fold<double>(
                  0,
                  (sum, goal) => sum + goal.targetAmount,
                );
                final progress = totalTarget > 0 ? (totalSaved / totalTarget * 100) : 0;

                return AppCard(
                  gradient: AppColors.primaryGradient,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Savings',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.primaryForeground.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          NumberFormat.currency(symbol: '\$').format(totalSaved),
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.primaryForeground,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.primaryForeground.withOpacity(0.9),
                              ),
                            ),
                            Text(
                              '${progress.toStringAsFixed(1)}%',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.primaryForeground,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress / 100,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Goals List
            Text(
              'Active Goals',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._goals.map((goal) => _buildGoalCard(context, goal)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, SavingsGoal goal) {
    final progress = goal.targetAmount > 0 ? (goal.currentAmount / goal.targetAmount * 100).clamp(0, 100) : 0;
    final daysRemaining = goal.deadline.difference(DateTime.now()).inDays;
    final remaining = goal.targetAmount - goal.currentAmount;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 16),
      onTap: () => _showGoalDetails(context, goal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: goal.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  goal.icon,
                  size: 24,
                  color: goal.color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${daysRemaining} days remaining',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                size: 20,
                color: AppColors.mutedForeground,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saved',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    NumberFormat.currency(symbol: '\$').format(goal.currentAmount),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Target',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    NumberFormat.currency(symbol: '\$').format(goal.targetAmount),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: AppColors.muted.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(goal.color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${progress.toStringAsFixed(1)}% complete',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.mutedForeground,
                ),
              ),
              Text(
                '\$${remaining.toStringAsFixed(0)} to go',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: goal.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showGoalDetails(BuildContext context, SavingsGoal goal) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: goal.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(goal.icon, size: 24, color: goal.color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Target: ${NumberFormat.currency(symbol: '\$').format(goal.targetAmount)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AppButton(
              isFullWidth: true,
              onPressed: () {
                Navigator.pop(context);
                _showAddToGoalDialog(context, goal);
              },
              child: const Text('Add Money to Goal'),
            ),
            const SizedBox(height: 12),
            AppButton(
              isFullWidth: true,
              variant: ButtonVariant.outline,
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add new goal feature coming soon!')),
    );
  }

  void _showAddToGoalDialog(BuildContext context, SavingsGoal goal) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Add money to ${goal.name} feature coming soon!')),
    );
  }
}

class SavingsGoal {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;
  final IconData icon;
  final Color color;

  SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    required this.icon,
    required this.color,
  });
}

