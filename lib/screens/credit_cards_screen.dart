import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../providers/banking_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/ui_components.dart';
import '../widgets/data_table.dart';

class CreditCardsScreen extends StatefulWidget {
  const CreditCardsScreen({super.key});

  @override
  State<CreditCardsScreen> createState() => _CreditCardsScreenState();
}

class _CreditCardsScreenState extends State<CreditCardsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Credit Cards'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          AppButton(
            variant: ButtonVariant.outline,
            size: ButtonSize.small,
            onPressed: () {
              // TODO: Apply for new credit card
            },
            child: const Text('Apply'),
          ),
        ],
      ),
      body: Consumer<BankingProvider>(
        builder: (context, bankingProvider, child) {
          final creditCards = bankingProvider.creditCards;

          return Column(
            children: [
              // Summary Cards
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Total Balance',
                        value: NumberFormat.currency(symbol: '\$').format(bankingProvider.totalCreditCardBalance),
                        icon: LucideIcons.creditCard,
                        iconColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        title: 'Active Cards',
                        value: creditCards.where((card) => card.isActive).length.toString(),
                        icon: LucideIcons.activity,
                        iconColor: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),

              // Credit Cards Table
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TableCard(
                    title: 'Credit Card Details',
                    subtitle: '${creditCards.length} cards found',
                    child: creditCards.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.creditCard,
                                  size: 64,
                                  color: AppColors.mutedForeground.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No credit cards found',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Your credit cards will appear here',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : DataTable(
                            columns: const [
                              DataColumn(label: Text('Card Number')),
                              DataColumn(label: Text('Cardholder')),
                              DataColumn(label: Text('Credit Limit')),
                              DataColumn(label: Text('Available Credit')),
                              DataColumn(label: Text('Current Balance')),
                              DataColumn(label: Text('Utilization')),
                              DataColumn(label: Text('Due Date')),
                              DataColumn(label: Text('Status')),
                            ],
                            rows: creditCards.map((card) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Row(
                                      children: [
                                        Icon(
                                          card.type == 'visa' ? LucideIcons.creditCard : LucideIcons.creditCard,
                                          size: 16,
                                          color: AppColors.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          card.cardNumber,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    Text(card.cardHolderName),
                                  ),
                                  DataCell(
                                    Text(
                                      NumberFormat.currency(symbol: '\$').format(card.creditLimit),
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      NumberFormat.currency(symbol: '\$').format(card.availableCredit),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      NumberFormat.currency(symbol: '\$').format(card.currentBalance),
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  DataCell(
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${card.utilizationPercentage.toStringAsFixed(1)}%',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: card.utilizationPercentage > 80
                                                ? AppColors.destructive
                                                : card.utilizationPercentage > 60
                                                    ? AppColors.warning
                                                    : AppColors.success,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        LinearProgressIndicator(
                                          value: card.utilizationPercentage / 100,
                                          backgroundColor: AppColors.muted,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            card.utilizationPercentage > 80
                                                ? AppColors.destructive
                                                : card.utilizationPercentage > 60
                                                    ? AppColors.warning
                                                    : AppColors.success,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          DateFormat('MMM dd').format(card.dueDate),
                                        ),
                                        Text(
                                          '${card.dueDate.difference(DateTime.now()).inDays} days',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: card.dueDate.difference(DateTime.now()).inDays <= 7
                                                ? AppColors.destructive
                                                : AppColors.mutedForeground,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    AppBadge(
                                      variant: _getBadgeVariant(card.status),
                                      child: Text(card.status.toUpperCase()),
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

  BadgeVariant _getBadgeVariant(String status) {
    switch (status) {
      case 'active':
        return BadgeVariant.default_;
      case 'blocked':
        return BadgeVariant.destructive;
      case 'expired':
        return BadgeVariant.secondary;
      default:
        return BadgeVariant.default_;
    }
  }
}
