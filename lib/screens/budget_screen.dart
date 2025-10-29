import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../providers/auth_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/ui_components.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  String _selectedPeriod = 'This Month';
  final List<BudgetCategory> _categories = [
    BudgetCategory(
      id: '1',
      name: 'Food & Dining',
      icon: LucideIcons.utensilsCrossed,
      budget: 500,
      spent: 320,
      color: AppColors.primary,
    ),
    BudgetCategory(
      id: '2',
      name: 'Shopping',
      icon: LucideIcons.shoppingBag,
      budget: 300,
      spent: 185,
      color: AppColors.success,
    ),
    BudgetCategory(
      id: '3',
      name: 'Transportation',
      icon: LucideIcons.car,
      budget: 200,
      spent: 150,
      color: AppColors.info,
    ),
    BudgetCategory(
      id: '4',
      name: 'Entertainment',
      icon: LucideIcons.film,
      budget: 150,
      spent: 220,
      color: AppColors.warning,
    ),
    BudgetCategory(
      id: '5',
      name: 'Bills & Utilities',
      icon: LucideIcons.fileText,
      budget: 400,
      spent: 380,
      color: AppColors.destructive,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final totalBudget = _categories.fold<double>(
      0,
      (sum, cat) => sum + cat.budget,
    );
    final totalSpent = _categories.fold<double>(
      0,
      (sum, cat) => sum + cat.spent,
    );
    final remaining = totalBudget - totalSpent;
    final percentage = totalBudget > 0 ? (totalSpent / totalBudget * 100) : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'This Week', child: Text('This Week')),
              const PopupMenuItem(value: 'This Month', child: Text('This Month')),
              const PopupMenuItem(value: 'This Year', child: Text('This Year')),
            ],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedPeriod,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(LucideIcons.chevronDown, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            AppCard(
              gradient: AppColors.primaryGradient,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Budget Overview',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.primaryForeground.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Spent',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.primaryForeground.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              NumberFormat.currency(symbol: 'Rs').format(totalSpent),
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.primaryForeground,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Budget',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.primaryForeground.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              NumberFormat.currency(symbol: 'Rs').format(totalBudget),
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.primaryForeground,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Remaining',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryForeground.withOpacity(0.9),
                          ),
                        ),
                        Text(
                          NumberFormat.currency(symbol: 'Rs').format(remaining),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: remaining >= 0
                                ? AppColors.success
                                : AppColors.destructive,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          percentage > 100
                              ? AppColors.destructive
                              : percentage > 80
                                  ? AppColors.warning
                                  : Colors.white,
                        ),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${percentage.toStringAsFixed(1)}% used',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primaryForeground.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Categories
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit categories coming soon!')),
                    );
                  },
                  child: const Text('Edit'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._categories.map((category) => _buildCategoryCard(context, category)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, BudgetCategory category) {
    final progress = category.budget > 0
        ? (category.spent / category.budget * 100).clamp(0, 200)
        : 0;
    final isOverBudget = category.spent > category.budget;
    final remaining = category.budget - category.spent;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  category.icon,
                  size: 20,
                  color: category.color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isOverBudget
                          ? 'Over budget by Rs${(-remaining).toStringAsFixed(0)}'
                          : 'Rs${remaining.toStringAsFixed(0)} remaining',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isOverBudget
                            ? AppColors.destructive
                            : AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Rs${category.spent.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isOverBudget
                          ? AppColors.destructive
                          : AppColors.foreground,
                    ),
                  ),
                  Text(
                    'of Rs${category.budget.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (progress / 100).clamp(0, 1),
              backgroundColor: category.color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverBudget ? AppColors.destructive : category.color,
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class BudgetCategory {
  final String id;
  final String name;
  final IconData icon;
  final double budget;
  final double spent;
  final Color color;

  BudgetCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.budget,
    required this.spent,
    required this.color,
  });
}

