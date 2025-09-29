import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../widgets/transaction_item.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _selectedFilter = 'All';

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

  List<Map<String, dynamic>> get _filteredTransactions {
    if (_selectedFilter == 'All') {
      return _transactions;
    }
    return _transactions.where((transaction) {
      return transaction['type'] == _selectedFilter.toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        title: const Text('Transaction History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.lightCard,
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
                      selectedColor: AppColors.primaryBlue.withOpacity(0.2),
                      checkmarkColor: AppColors.primaryBlue,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
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
                          Icons.receipt_long,
                          size: 64,
                          color: AppColors.textSecondary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No transactions found',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your transactions will appear here',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
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
