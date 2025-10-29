import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../constants/app_colors.dart';
import '../widgets/transaction_item.dart';
import '../widgets/ui_components.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _filterOptions = ['All', 'Transfer', 'Deposit', 'Withdrawal', 'Payment'];

  // Mock transaction data
  final List<Map<String, dynamic>> _transactions = [
    {
      'type': 'transfer',
      'amount': -250.0,
      'description': 'Transfer to John Doe',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'status': 'completed',
    },
    {
      'type': 'deposit',
      'amount': 1000.0,
      'description': 'Salary Deposit',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'completed',
    },
    {
      'type': 'withdrawal',
      'amount': -50.0,
      'description': 'ATM Withdrawal',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'status': 'completed',
    },
    {
      'type': 'payment',
      'amount': -75.0,
      'description': 'Electricity Bill Payment',
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      'status': 'completed',
    },
    {
      'type': 'transfer',
      'amount': -100.0,
      'description': 'Transfer to Jane Smith',
      'timestamp': DateTime.now().subtract(const Duration(days: 5)),
      'status': 'completed',
    },
    {
      'type': 'deposit',
      'amount': 500.0,
      'description': 'Cash Deposit',
      'timestamp': DateTime.now().subtract(const Duration(days: 7)),
      'status': 'completed',
    },
    {
      'type': 'withdrawal',
      'amount': -200.0,
      'description': 'ATM Withdrawal',
      'timestamp': DateTime.now().subtract(const Duration(days: 10)),
      'status': 'completed',
    },
    {
      'type': 'payment',
      'amount': -150.0,
      'description': 'Internet Bill Payment',
      'timestamp': DateTime.now().subtract(const Duration(days: 12)),
      'status': 'completed',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredTransactions {
    var filtered = _transactions;

    // Apply type filter
    if (_selectedFilter != 'All') {
      filtered = filtered.where((transaction) {
        return transaction['type'] == _selectedFilter.toLowerCase();
      }).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((transaction) {
        final description = transaction['description'].toString().toLowerCase();
        final amount = transaction['amount'].toString();
        return description.contains(_searchQuery.toLowerCase()) ||
            amount.contains(_searchQuery);
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Transaction History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppInput(
              controller: _searchController,
              hintText: 'Search transactions...',
              prefixIcon: Icon(
                LucideIcons.search,
                size: 20,
                color: AppColors.mutedForeground,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        LucideIcons.x,
                        size: 20,
                        color: AppColors.mutedForeground,
                      ),
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                          _searchController.clear();
                        });
                      },
                    )
                  : null,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
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

          // Summary Info
          if (_filteredTransactions.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_filteredTransactions.length} transaction${_filteredTransactions.length != 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.mutedForeground,
                    ),
                  ),
                  if (_searchQuery.isNotEmpty || _selectedFilter != 'All')
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = 'All';
                          _searchQuery = '';
                          _searchController.clear();
                        });
                      },
                      icon: const Icon(LucideIcons.x, size: 16),
                      label: const Text('Clear filters'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                    ),
                ],
              ),
            ),

          // Transactions List
          Expanded(
            child: _filteredTransactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.search,
                          size: 64,
                          color: AppColors.mutedForeground.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No transactions found',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.mutedForeground,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'Try a different search term'
                              : 'Your transactions will appear here',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _filteredTransactions[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TransactionItem(
                          type: transaction['type'],
                          amount: transaction['amount'],
                          description: transaction['description'],
                          timestamp: transaction['timestamp'],
                          status: transaction['status'],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
