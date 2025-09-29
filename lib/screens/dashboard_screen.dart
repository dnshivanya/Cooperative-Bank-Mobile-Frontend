import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/banking_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/ui_components.dart';
import '../widgets/data_table.dart';

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
                      // TODO: Navigate to notifications
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
                // Welcome Section
                AppCard(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.primaryGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                        const SizedBox(height: 16),
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

                // Quick Actions
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    AppCard(
                      onTap: () => context.go('/transfer'),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.send,
                            size: 32,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Transfer',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppCard(
                      onTap: () => context.go('/transactions'),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.history,
                            size: 32,
                            color: AppColors.success,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Transactions',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppCard(
                      onTap: () => context.go('/bills'),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.fileText,
                            size: 32,
                            color: AppColors.warning,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pay Bills',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppCard(
                      onTap: () => context.go('/loans'),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.home,
                            size: 32,
                            color: AppColors.info,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Loans',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Recent Transactions Table
                TableCard(
                  title: 'Recent Transactions',
                  subtitle: 'Your latest banking activity',
                  actions: [
                    AppButton(
                      variant: ButtonVariant.outline,
                      size: ButtonSize.small,
                      onPressed: () => context.go('/transactions'),
                      child: const Text('View All'),
                    ),
                  ],
                  child: Consumer<BankingProvider>(
                    builder: (context, bankingProvider, child) {
                      // Mock recent transactions for table
                      final recentTransactions = [
                        {
                          'date': 'Today',
                          'description': 'Transfer to John Doe',
                          'amount': '-250.00',
                          'status': 'Completed',
                        },
                        {
                          'date': 'Yesterday',
                          'description': 'Salary Deposit',
                          'amount': '+1,000.00',
                          'status': 'Completed',
                        },
                        {
                          'date': '2 days ago',
                          'description': 'ATM Withdrawal',
                          'amount': '-50.00',
                          'status': 'Completed',
                        },
                      ];

                      return AppDataTable(
                        columns: const [
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Description')),
                          DataColumn(label: Text('Amount')),
                          DataColumn(label: Text('Status')),
                        ],
                        rows: recentTransactions.map((transaction) {
                          return DataRow(
                            cells: [
                              DataCell(Text(transaction['date']!)),
                              DataCell(Text(transaction['description']!)),
                              DataCell(
                                Text(
                                  transaction['amount']!,
                                  style: TextStyle(
                                    color: transaction['amount']!.startsWith('+')
                                        ? AppColors.success
                                        : AppColors.destructive,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataCell(
                                AppBadge(
                                  variant: BadgeVariant.default_,
                                  child: Text(transaction['status']!),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                        height: 200,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Logout Button
                Center(
                  child: AppButton(
                    variant: ButtonVariant.destructive,
                    onPressed: () async {
                      final authProvider = Provider.of<AuthProvider>(context, listen: false);
                      await authProvider.logout();
                      if (mounted) {
                        context.go('/login');
                      }
                    },
                    child: const Text('Logout'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
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
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.mutedForeground,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.history),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.user),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}