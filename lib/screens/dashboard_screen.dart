import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/transaction.dart';

import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/banking_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/ui_components.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Cooperative Banking'),
        actions: [
          Consumer<BankingProvider>(
            builder: (context, bankingProvider, child) {
              final unreadCount = bankingProvider.unreadNotificationsCount;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.bell),
                    onPressed: () {
                      context.go('/notifications');
                    },
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppColors.destructive,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          unreadCount.toString(),
                          style: const TextStyle(
                            color: AppColors.destructiveForeground,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? LucideIcons.sun : LucideIcons.moon,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = authProvider.user!;
          final formattedBalance = NumberFormat.currency(
            symbol: '\$',
            decimalDigits: 2,
          ).format(user.balance);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    // Welcome Section with Modern Gradient Card
                    AppCard(
                      gradient: AppColors.primaryGradient,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Welcome back,',
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          color: AppColors.primaryForeground.withOpacity(0.9),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        user.displayName,
                                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          color: AppColors.primaryForeground,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    LucideIcons.user,
                                    size: 24,
                                    color: AppColors.primaryForeground,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Account Balance',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.primaryForeground.withOpacity(0.9),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formattedBalance,
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: AppColors.primaryForeground,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                // Quick Stats
                Row(
                  children: [
                    Expanded(
                      child: Consumer<BankingProvider>(
                        builder: (context, bankingProvider, child) {
                          return StatCard(
                            title: 'Investments',
                            value: NumberFormat.currency(symbol: '\$').format(bankingProvider.totalInvestmentValue),
                            icon: LucideIcons.trendingUp,
                            iconColor: AppColors.success,
                            onTap: () => context.go('/investments'),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Consumer<BankingProvider>(
                        builder: (context, bankingProvider, child) {
                          return StatCard(
                            title: 'Loans',
                            value: NumberFormat.currency(symbol: '\$').format(bankingProvider.totalLoanBalance),
                            icon: LucideIcons.home,
                            iconColor: AppColors.warning,
                            onTap: () => context.go('/loans'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Consumer<BankingProvider>(
                        builder: (context, bankingProvider, child) {
                          return StatCard(
                            title: 'Credit Cards',
                            value: NumberFormat.currency(symbol: '\$').format(bankingProvider.totalCreditCardBalance),
                            icon: LucideIcons.creditCard,
                            iconColor: AppColors.info,
                            onTap: () => context.go('/credit-cards'),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Consumer<BankingProvider>(
                        builder: (context, bankingProvider, child) {
                          return StatCard(
                            title: 'Pending Bills',
                            value: NumberFormat.currency(symbol: '\$').format(bankingProvider.totalBillsAmount),
                            icon: LucideIcons.fileText,
                            iconColor: AppColors.destructive,
                            onTap: () => context.go('/bills'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Quick Actions with Modern Design
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.foreground,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _showAllActions(context);
                      },
                      child: Text(
                        'More',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 0.80,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _buildQuickActionCard(
                      context,
                      icon: LucideIcons.send,
                      label: 'Transfer',
                      subtitle: 'Send money',
                      color: AppColors.primary,
                      onTap: () => context.go('/transfer'),
                    ),
                    _buildQuickActionCard(
                      context,
                      icon: LucideIcons.download,
                      label: 'Deposit',
                      subtitle: 'Add funds',
                      color: AppColors.success,
                      onTap: () => _showDepositDialog(context),
                    ),
                    _buildQuickActionCard(
                      context,
                      icon: LucideIcons.upload,
                      label: 'Withdraw',
                      subtitle: 'Cash out',
                      color: AppColors.info,
                      onTap: () => _showWithdrawDialog(context),
                    ),
                    _buildQuickActionCard(
                      context,
                      icon: LucideIcons.hand,
                      label: 'Request',
                      subtitle: 'Ask money',
                      color: AppColors.warning,
                      onTap: () => _showRequestDialog(context),
                    ),
                    _buildQuickActionCard(
                      context,
                      icon: LucideIcons.qrCode,
                      label: 'Scan QR',
                      subtitle: 'Quick pay',
                      color: AppColors.primary,
                      onTap: () => _showQRScanner(context),
                    ),
                    _buildQuickActionCard(
                      context,
                      icon: LucideIcons.target,
                      label: 'Goals',
                      subtitle: 'Savings',
                      color: AppColors.success,
                      onTap: () => context.go('/savings-goals'),
                    ),
                    _buildQuickActionCard(
                      context,
                      icon: LucideIcons.barChart,
                      label: 'Budget',
                      subtitle: 'Track spend',
                      color: AppColors.info,
                      onTap: () => context.go('/budget'),
                    ),
                    _buildQuickActionCard(
                      context,
                      icon: LucideIcons.history,
                      label: 'History',
                      subtitle: 'Transactions',
                      color: AppColors.mutedForeground,
                      onTap: () => context.go('/transactions'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Recent Transactions List
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent Transactions',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.foreground,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your latest banking activity',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => context.go('/transactions'),
                      child: Text(
                        'View All',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Consumer<BankingProvider>(
                  builder: (context, bankingProvider, child) {
                    final recentTransactions = bankingProvider.recentTransactions;
                    
                    if (recentTransactions.isEmpty) {
                      return AppCard(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  LucideIcons.receipt,
                                  size: 48,
                                  color: AppColors.mutedForeground.withOpacity(0.5),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No transactions yet',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: recentTransactions.asMap().entries.map((entry) {
                        final index = entry.key;
                        final transaction = entry.value;
                        return _buildTransactionCard(context, transaction, index == recentTransactions.length - 1);
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  index: 0,
                  icon: LucideIcons.home,
                  label: 'Home',
                  isSelected: _selectedIndex == 0,
                ),
                _buildNavItem(
                  context,
                  index: 1,
                  icon: LucideIcons.history,
                  label: 'Transactions',
                  isSelected: _selectedIndex == 1,
                ),
                _buildNavItem(
                  context,
                  index: 2,
                  icon: LucideIcons.user,
                  label: 'Profile',
                  isSelected: _selectedIndex == 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AppCard(
      isGlassmorphic: true,
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 22,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2),
          Flexible(
            child: Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.mutedForeground,
                fontSize: 9,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showAllActions(BuildContext context) {
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
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.mutedForeground.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'All Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildActionItem(context, LucideIcons.receipt, 'Pay Bills', () {
                  Navigator.pop(context);
                  context.go('/bills');
                }),
                _buildActionItem(context, LucideIcons.home, 'Loans', () {
                  Navigator.pop(context);
                  context.go('/loans');
                }),
                _buildActionItem(context, LucideIcons.trendingUp, 'Invest', () {
                  Navigator.pop(context);
                  context.go('/investments');
                }),
                _buildActionItem(context, LucideIcons.creditCard, 'Cards', () {
                  Navigator.pop(context);
                  context.go('/credit-cards');
                }),
                _buildActionItem(context, LucideIcons.fileText, 'Statements', () {
                  Navigator.pop(context);
                  _showStatements(context);
                }),
                _buildActionItem(context, LucideIcons.repeat, 'Recurring', () {
                  Navigator.pop(context);
                  _showRecurringPayments(context);
                }),
                _buildActionItem(context, LucideIcons.users, 'Contacts', () {
                  Navigator.pop(context);
                  _showContacts(context);
                }),
                _buildActionItem(context, LucideIcons.shield, 'Security', () {
                  Navigator.pop(context);
                  context.go('/profile');
                }),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context, Transaction transaction, bool isLast) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final amountColor = transaction.amount >= 0 ? AppColors.success : AppColors.destructive;
    final amountPrefix = transaction.amount >= 0 ? '+' : '';
    
    IconData getTransactionIcon() {
      switch (transaction.type) {
        case 'transfer':
          return LucideIcons.send;
        case 'deposit':
          return LucideIcons.download;
        case 'withdrawal':
          return LucideIcons.upload;
        case 'payment':
          return LucideIcons.fileText;
        default:
          return LucideIcons.receipt;
      }
    }

    Color getIconColor() {
      switch (transaction.type) {
        case 'transfer':
          return AppColors.info;
        case 'deposit':
          return AppColors.success;
        case 'withdrawal':
          return AppColors.warning;
        case 'payment':
          return AppColors.destructive;
        default:
          return AppColors.mutedForeground;
      }
    }

    String getFormattedDate() {
      final now = DateTime.now();
      final difference = now.difference(transaction.timestamp);
      
      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          return 'Just now';
        }
        return '${difference.inHours}h ago';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return DateFormat('MMM d').format(transaction.timestamp);
      }
    }

    return AppCard(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: getIconColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              getTransactionIcon(),
              size: 20,
              color: getIconColor(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description ?? 'Transaction',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      getFormattedDate(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    if (transaction.reference != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '•',
                        style: TextStyle(color: AppColors.mutedForeground),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        transaction.reference!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.mutedForeground,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$amountPrefix\$${transaction.amount.abs().toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: amountColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (transaction.fee != null && transaction.fee! > 0) ...[
                const SizedBox(height: 2),
                Text(
                  'Fee: \$${transaction.fee!.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.mutedForeground,
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showDepositDialog(BuildContext context) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Deposit Money',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AppInput(
              controller: amountController,
              label: 'Amount',
              hintText: 'Enter amount',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: Icon(LucideIcons.dollarSign, size: 20),
            ),
            const SizedBox(height: 16),
            AppInput(
              controller: descriptionController,
              label: 'Description (Optional)',
              hintText: 'e.g., Cash deposit, Bank transfer',
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            Consumer<BankingProvider>(
              builder: (context, bankingProvider, child) {
                return Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return AppButton(
                      isFullWidth: true,
                      isLoading: bankingProvider.isLoading,
                      onPressed: () async {
                        final amount = double.tryParse(amountController.text);
                        if (amount == null || amount <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a valid amount'),
                              backgroundColor: AppColors.destructive,
                            ),
                          );
                          return;
                        }

                        await bankingProvider.addDeposit(
                          amount: amount,
                          description: descriptionController.text.isEmpty
                              ? 'Deposit'
                              : descriptionController.text,
                          accountNumber: authProvider.user?.accountNumber ?? '',
                        );

                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Deposited \$${amount.toStringAsFixed(2)} successfully!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        }
                      },
                      child: const Text('Deposit Money'),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Withdraw Money',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.info.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available Balance',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.mutedForeground,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            NumberFormat.currency(symbol: '\$').format(authProvider.user?.balance ?? 0),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.info,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            AppInput(
              controller: amountController,
              label: 'Amount',
              hintText: 'Enter amount',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: Icon(LucideIcons.dollarSign, size: 20),
            ),
            const SizedBox(height: 16),
            AppInput(
              controller: descriptionController,
              label: 'Description (Optional)',
              hintText: 'e.g., ATM withdrawal, Cash',
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            Consumer<BankingProvider>(
              builder: (context, bankingProvider, child) {
                return Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return AppButton(
                      isFullWidth: true,
                      isLoading: bankingProvider.isLoading,
                      onPressed: () async {
                        final amount = double.tryParse(amountController.text);
                        if (amount == null || amount <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a valid amount'),
                              backgroundColor: AppColors.destructive,
                            ),
                          );
                          return;
                        }

                        if (amount > (authProvider.user?.balance ?? 0)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Insufficient balance'),
                              backgroundColor: AppColors.destructive,
                            ),
                          );
                          return;
                        }

                        await bankingProvider.addWithdrawal(
                          amount: amount,
                          description: descriptionController.text.isEmpty
                              ? 'Withdrawal'
                              : descriptionController.text,
                          accountNumber: authProvider.user?.accountNumber ?? '',
                        );

                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Withdrew \$${amount.toStringAsFixed(2)} successfully!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        }
                      },
                      child: const Text('Withdraw Money'),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showRequestDialog(BuildContext context) {
    final amountController = TextEditingController();
    final recipientController = TextEditingController();
    final descriptionController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Request Money',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AppInput(
              controller: recipientController,
              label: 'Recipient Account Number',
              hintText: 'Enter account number',
              keyboardType: TextInputType.number,
              prefixIcon: Icon(LucideIcons.user, size: 20),
            ),
            const SizedBox(height: 16),
            AppInput(
              controller: amountController,
              label: 'Amount',
              hintText: 'Enter amount',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: Icon(LucideIcons.dollarSign, size: 20),
            ),
            const SizedBox(height: 16),
            AppInput(
              controller: descriptionController,
              label: 'Description (Optional)',
              hintText: 'e.g., Payment for services',
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            Consumer<BankingProvider>(
              builder: (context, bankingProvider, child) {
                return AppButton(
                  isFullWidth: true,
                  isLoading: bankingProvider.isLoading,
                  onPressed: () async {
                    final amount = double.tryParse(amountController.text);
                    if (amount == null || amount <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid amount'),
                          backgroundColor: AppColors.destructive,
                        ),
                      );
                      return;
                    }

                    if (recipientController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter recipient account number'),
                          backgroundColor: AppColors.destructive,
                        ),
                      );
                      return;
                    }

                    await bankingProvider.createMoneyRequest(
                      amount: amount,
                      description: descriptionController.text.isEmpty
                          ? 'Money request'
                          : descriptionController.text,
                      recipientAccount: recipientController.text,
                    );

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Money request sent for \$${amount.toStringAsFixed(2)}!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  },
                  child: const Text('Send Request'),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showQRScanner(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan QR Code'),
        content: const Text('QR code scanner coming soon! Scan QR codes to make quick payments.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showStatements(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Statements feature coming soon!')),
    );
  }

  void _showRecurringPayments(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recurring payments feature coming soon!')),
    );
  }

  void _showContacts(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contacts feature coming soon!')),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        switch (index) {
          case 0:
            // Already on dashboard
            break;
          case 1:
            context.go('/transactions');
            break;
          case 2:
            context.go('/profile');
            break;
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                icon,
                size: 16,
                color: isSelected ? AppColors.primaryForeground : AppColors.mutedForeground,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isSelected ? AppColors.primary : AppColors.mutedForeground,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}