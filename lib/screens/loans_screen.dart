import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../providers/banking_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/ui_components.dart';
class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key});

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  String _selectedFilter = 'All';

  final List<String> _filterOptions = ['All', 'Active', 'Paid', 'Defaulted'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loans'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          AppButton(
            variant: ButtonVariant.outline,
            size: ButtonSize.small,
            onPressed: () {
              // TODO: Apply for new loan
            },
            child: const Text('Apply'),
          ),
        ],
      ),
      body: Consumer<BankingProvider>(
        builder: (context, bankingProvider, child) {
          final loans = bankingProvider.loans;
          final filteredLoans = _getFilteredLoans(loans);

          return Column(
            children: [
              // Summary Cards
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Total Loans',
                        value: NumberFormat.currency(symbol: 'Rs').format(bankingProvider.totalLoanBalance),
                        icon: LucideIcons.home,
                        iconColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        title: 'Active Loans',
                        value: loans.where((loan) => loan.isActive).length.toString(),
                        icon: LucideIcons.activity,
                        iconColor: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),

              // Filter Section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filterOptions.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(
                          label: Text(filter),
                          onPressed: () {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          backgroundColor: isSelected
                              ? AppColors.primary
                              : AppColors.card,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.primaryForeground
                                : AppColors.foreground,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Loans List
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Loan Details',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${filteredLoans.length} loans found',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      filteredLoans.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(48.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      LucideIcons.home,
                                      size: 64,
                                      color: AppColors.mutedForeground.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No loans found',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: AppColors.mutedForeground,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Your loans will appear here',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.mutedForeground,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Column(
                              children: filteredLoans.asMap().entries.map((entry) {
                                final loan = entry.value;
                                final isLast = entry.key == filteredLoans.length - 1;
                                return _buildLoanCard(context, loan, isLast);
                              }).toList(),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<dynamic> _getFilteredLoans(List<dynamic> loans) {
    switch (_selectedFilter) {
      case 'Active':
        return loans.where((loan) => loan.isActive).toList();
      case 'Paid':
        return loans.where((loan) => loan.isPaid).toList();
      case 'Defaulted':
        return loans.where((loan) => loan.isDefaulted).toList();
      default:
        return loans;
    }
  }

  BadgeVariant _getBadgeVariant(String status) {
    switch (status) {
      case 'active':
        return BadgeVariant.default_;
      case 'paid':
        return BadgeVariant.secondary;
      case 'defaulted':
        return BadgeVariant.destructive;
      default:
        return BadgeVariant.default_;
    }
  }

  Widget _buildLoanCard(BuildContext context, dynamic loan, bool isLast) {
    IconData getLoanIcon() {
      switch (loan.type) {
        case 'home':
          return LucideIcons.home;
        case 'car':
          return LucideIcons.car;
        case 'personal':
          return LucideIcons.user;
        case 'business':
          return LucideIcons.briefcase;
        default:
          return LucideIcons.fileText;
      }
    }

    Color getIconColor() {
      switch (loan.status) {
        case 'active':
          return AppColors.primary;
        case 'paid':
          return AppColors.success;
        case 'defaulted':
          return AppColors.destructive;
        default:
          return AppColors.mutedForeground;
      }
    }

    String getFormattedType() {
      return loan.type.split('_').map((word) {
        return word[0].toUpperCase() + word.substring(1);
      }).join(' ');
    }

    final monthsRemaining = loan.termMonths - 
        (DateTime.now().difference(loan.startDate).inDays / 30).floor();

    return AppCard(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      padding: const EdgeInsets.all(16),
      onTap: () {
        // TODO: Navigate to loan details
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: getIconColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  getLoanIcon(),
                  size: 20,
                  color: getIconColor(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            getFormattedType(),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        AppBadge(
                          variant: _getBadgeVariant(loan.status),
                          size: BadgeSize.small,
                          child: Text(
                            loan.status.toUpperCase(),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${loan.termMonths} months • ${loan.interestRate.toStringAsFixed(2)}% interest',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loan Amount',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      NumberFormat.currency(symbol: 'Rs').format(loan.amount),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Payment',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      NumberFormat.currency(symbol: 'Rs').format(loan.monthlyPayment),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Remaining Balance',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    Text(
                      '${loan.progressPercentage.toStringAsFixed(1)}% paid',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  NumberFormat.currency(symbol: 'Rs').format(loan.remainingBalance),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: loan.progressPercentage / 100,
                    backgroundColor: AppColors.muted.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      loan.isActive ? AppColors.primary : AppColors.success,
                    ),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Started: ${DateFormat('MMM yyyy').format(loan.startDate)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      monthsRemaining > 0 
                          ? '$monthsRemaining months remaining'
                          : 'Completed',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: monthsRemaining > 0 
                            ? AppColors.warning 
                            : AppColors.success,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
