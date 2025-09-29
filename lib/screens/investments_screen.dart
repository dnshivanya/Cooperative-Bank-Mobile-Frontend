import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../providers/banking_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/ui_components.dart';
import '../widgets/data_table.dart';

class InvestmentsScreen extends StatefulWidget {
  const InvestmentsScreen({super.key});

  @override
  State<InvestmentsScreen> createState() => _InvestmentsScreenState();
}

class _InvestmentsScreenState extends State<InvestmentsScreen> {
  String _selectedFilter = 'All';

  final List<String> _filterOptions = ['All', 'Stocks', 'Mutual Funds', 'Bonds', 'ETF'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Investments'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          AppButton(
            variant: ButtonVariant.outline,
            size: ButtonSize.small,
            onPressed: () {
              // TODO: Add new investment
            },
            child: const Text('Invest'),
          ),
        ],
      ),
      body: Consumer<BankingProvider>(
        builder: (context, bankingProvider, child) {
          final investments = bankingProvider.investments;
          final filteredInvestments = _getFilteredInvestments(investments);

          return Column(
            children: [
              // Summary Cards
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Total Value',
                        value: NumberFormat.currency(symbol: '\$').format(bankingProvider.totalInvestmentValue),
                        icon: LucideIcons.trendingUp,
                        iconColor: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        title: 'Active Investments',
                        value: investments.where((inv) => inv.isActive).length.toString(),
                        icon: LucideIcons.activity,
                        iconColor: AppColors.primary,
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

              // Investments Table
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TableCard(
                    title: 'Investment Portfolio',
                    subtitle: '${filteredInvestments.length} investments found',
                    child: filteredInvestments.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.trendingUp,
                                  size: 64,
                                  color: AppColors.mutedForeground.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No investments found',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Your investments will appear here',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : DataTable(
                            columns: const [
                              DataColumn(label: Text('Symbol')),
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Shares')),
                              DataColumn(label: Text('Current Price')),
                              DataColumn(label: Text('Total Value')),
                              DataColumn(label: Text('Gain/Loss')),
                              DataColumn(label: Text('Status')),
                            ],
                            rows: filteredInvestments.map((investment) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      investment.symbol,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          investment.name,
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          investment.type.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.mutedForeground,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    Text(investment.shares.toString()),
                                  ),
                                  DataCell(
                                    Text(
                                      NumberFormat.currency(symbol: '\$').format(investment.currentPrice),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      NumberFormat.currency(symbol: '\$').format(investment.totalValue),
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  DataCell(
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          NumberFormat.currency(symbol: investment.isGain ? '+' : '').format(investment.gainLoss),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: investment.isGain ? AppColors.success : AppColors.destructive,
                                          ),
                                        ),
                                        Text(
                                          '${investment.gainLossPercentage.toStringAsFixed(2)}%',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: investment.isGain ? AppColors.success : AppColors.destructive,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    AppBadge(
                                      variant: investment.isActive ? BadgeVariant.default_ : BadgeVariant.secondary,
                                      child: Text(investment.status.toUpperCase()),
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

  List<dynamic> _getFilteredInvestments(List<dynamic> investments) {
    switch (_selectedFilter) {
      case 'Stocks':
        return investments.where((inv) => inv.type == 'stocks').toList();
      case 'Mutual Funds':
        return investments.where((inv) => inv.type == 'mutual_funds').toList();
      case 'Bonds':
        return investments.where((inv) => inv.type == 'bonds').toList();
      case 'ETF':
        return investments.where((inv) => inv.type == 'etf').toList();
      default:
        return investments;
    }
  }
}
