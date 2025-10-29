import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../providers/banking_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/ui_components.dart';
class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  String _selectedFilter = 'All';

  final List<String> _filterOptions = ['All', 'Pending', 'Overdue', 'Paid'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bills & Payments'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: Consumer<BankingProvider>(
        builder: (context, bankingProvider, child) {
          final bills = bankingProvider.bills;
          final filteredBills = _getFilteredBills(bills);

          return Column(
            children: [
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

              // Bills List
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
                                'Bills & Payments',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${filteredBills.length} bills found',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                          AppButton(
                            variant: ButtonVariant.outline,
                            size: ButtonSize.small,
                            onPressed: () {
                              // TODO: Add new bill
                            },
                            child: const Text('Add Bill'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      filteredBills.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(48.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      LucideIcons.fileText,
                                      size: 64,
                                      color: AppColors.mutedForeground.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No bills found',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: AppColors.mutedForeground,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Your bills will appear here',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.mutedForeground,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Column(
                              children: filteredBills.asMap().entries.map((entry) {
                                final bill = entry.value;
                                final isLast = entry.key == filteredBills.length - 1;
                                return _buildBillCard(context, bill, isLast);
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

  List<dynamic> _getFilteredBills(List<dynamic> bills) {
    switch (_selectedFilter) {
      case 'Pending':
        return bills.where((bill) => bill.isPending).toList();
      case 'Overdue':
        return bills.where((bill) => bill.isOverdue).toList();
      case 'Paid':
        return bills.where((bill) => bill.isPaid).toList();
      default:
        return bills;
    }
  }

  BadgeVariant _getBadgeVariant(String status) {
    switch (status) {
      case 'pending':
        return BadgeVariant.default_;
      case 'overdue':
        return BadgeVariant.destructive;
      case 'paid':
        return BadgeVariant.secondary;
      default:
        return BadgeVariant.default_;
    }
  }

  Future<void> _payBill(String billId) async {
    final bankingProvider = Provider.of<BankingProvider>(context, listen: false);
    
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Payment'),
        content: const Text('Are you sure you want to pay this bill?'),
        actions: [
          AppButton(
            variant: ButtonVariant.outline,
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          AppButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Pay'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await bankingProvider.payBill(billId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bill paid successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  Widget _buildBillCard(BuildContext context, dynamic bill, bool isLast) {
    IconData getBillIcon() {
      switch (bill.category) {
        case 'electricity':
          return LucideIcons.zap;
        case 'water':
          return LucideIcons.droplet;
        case 'internet':
          return LucideIcons.wifi;
        case 'phone':
          return LucideIcons.phone;
        case 'insurance':
          return LucideIcons.shield;
        default:
          return LucideIcons.fileText;
      }
    }

    Color getBillColor() {
      if (bill.isOverdue) {
        return AppColors.destructive;
      } else if (bill.daysUntilDue <= 3) {
        return AppColors.warning;
      } else if (bill.isPaid) {
        return AppColors.success;
      }
      return AppColors.primary;
    }

    String getFormattedCategory() {
      return bill.category.split('_').map((word) {
        return word[0].toUpperCase() + word.substring(1);
      }).join(' ');
    }

    return AppCard(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: getBillColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  getBillIcon(),
                  size: 20,
                  color: getBillColor(),
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
                            bill.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        AppBadge(
                          variant: _getBadgeVariant(bill.status),
                          size: BadgeSize.small,
                          child: Text(
                            bill.status.toUpperCase(),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      getFormattedCategory(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    if (bill.accountNumber != null)
                      Text(
                        'Account: ${bill.accountNumber}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.mutedForeground.withOpacity(0.7),
                          fontSize: 11,
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
                      'Amount',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      NumberFormat.currency(symbol: 'Rs').format(bill.amount),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: getBillColor(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Due Date',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM dd').format(bill.dueDate),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (bill.daysUntilDue >= 0)
                      Text(
                        '${bill.daysUntilDue} days left',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: bill.daysUntilDue <= 3
                              ? AppColors.destructive
                              : AppColors.mutedForeground,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    else
                      Text(
                        '${bill.daysUntilDue.abs()} days overdue',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.destructive,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (bill.description != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.muted.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.info,
                    size: 14,
                    color: AppColors.mutedForeground,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      bill.description!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (bill.isPending) ...[
            const SizedBox(height: 16),
            AppButton(
              isFullWidth: true,
              onPressed: () => _payBill(bill.id),
              child: const Text('Pay Bill'),
            ),
          ],
        ],
      ),
    );
  }
}
