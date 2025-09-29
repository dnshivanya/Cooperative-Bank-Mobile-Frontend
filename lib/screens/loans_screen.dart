import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../providers/banking_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/ui_components.dart';
import '../widgets/data_table.dart';

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
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
                        value: NumberFormat.currency(symbol: '\$').format(bankingProvider.totalLoanBalance),
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
                padding: const EdgeInsets.all(16),
                color: AppColors.card,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filterOptions.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          selectedColor: AppColors.primary.withOpacity(0.2),
                          checkmarkColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.primary : AppColors.mutedForeground,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Loans Table
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TableCard(
                    title: 'Loan Details',
                    subtitle: '${filteredLoans.length} loans found',
                    child: filteredLoans.isEmpty
                        ? Center(
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
                          )
                        : DataTable(
                            columns: const [
                              DataColumn(label: Text('Loan Type')),
                              DataColumn(label: Text('Amount')),
                              DataColumn(label: Text('Monthly Payment')),
                              DataColumn(label: Text('Remaining Balance')),
                              DataColumn(label: Text('Progress')),
                              DataColumn(label: Text('Status')),
                            ],
                            rows: filteredLoans.map((loan) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          loan.type.toUpperCase(),
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          '${loan.termMonths} months',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.mutedForeground,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      NumberFormat.currency(symbol: '\$').format(loan.amount),
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      NumberFormat.currency(symbol: '\$').format(loan.monthlyPayment),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      NumberFormat.currency(symbol: '\$').format(loan.remainingBalance),
                                    ),
                                  ),
                                  DataCell(
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${loan.progressPercentage.toStringAsFixed(1)}%',
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 4),
                                        LinearProgressIndicator(
                                          value: loan.progressPercentage / 100,
                                          backgroundColor: AppColors.muted,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            loan.isActive ? AppColors.primary : AppColors.success,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    AppBadge(
                                      variant: _getBadgeVariant(loan.status),
                                      child: Text(loan.status.toUpperCase()),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
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
}
