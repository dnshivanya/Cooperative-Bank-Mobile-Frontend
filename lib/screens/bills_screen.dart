import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../providers/banking_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/ui_components.dart';
import '../widgets/data_table.dart';

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
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

              // Bills Table
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TableCard(
                    title: 'Bills & Payments',
                    subtitle: '${filteredBills.length} bills found',
                    actions: [
                      AppButton(
                        variant: ButtonVariant.outline,
                        size: ButtonSize.small,
                        onPressed: () {
                          // TODO: Add new bill
                        },
                        child: const Text('Add Bill'),
                      ),
                    ],
                    child: filteredBills.isEmpty
                        ? Center(
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
                          )
                        : AppDataTable(
                            columns: const [
                              DataColumn(label: Text('Bill')),
                              DataColumn(label: Text('Amount')),
                              DataColumn(label: Text('Due Date')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows: filteredBills.map((bill) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          bill.name,
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          bill.category.toUpperCase(),
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
                                      NumberFormat.currency(symbol: '\$').format(bill.amount),
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  DataCell(
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          DateFormat('MMM dd, yyyy').format(bill.dueDate),
                                        ),
                                        if (bill.daysUntilDue >= 0)
                                          Text(
                                            '${bill.daysUntilDue} days left',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: bill.daysUntilDue <= 3
                                                  ? AppColors.destructive
                                                  : AppColors.mutedForeground,
                                            ),
                                          )
                                        else
                                          Text(
                                            '${bill.daysUntilDue.abs()} days overdue',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.destructive,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    AppBadge(
                                      variant: _getBadgeVariant(bill.status),
                                      child: Text(bill.status.toUpperCase()),
                                    ),
                                  ),
                                  DataCell(
                                    bill.isPending
                                        ? AppButton(
                                            variant: ButtonVariant.outline,
                                            size: ButtonSize.small,
                                            onPressed: () => _payBill(bill.id),
                                            child: const Text('Pay'),
                                          )
                                        : const SizedBox.shrink(),
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
}
