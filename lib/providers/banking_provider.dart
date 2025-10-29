import 'package:flutter/material.dart';
import '../models/banking_models.dart';
import '../models/transaction.dart';

class BankingProvider extends ChangeNotifier {
  List<Loan> _loans = [];
  List<Investment> _investments = [];
  List<CreditCard> _creditCards = [];
  List<Bill> _bills = [];
  List<NotificationItem> _notifications = [];
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Loan> get loans => _loans;
  List<Investment> get investments => _investments;
  List<CreditCard> get creditCards => _creditCards;
  List<Bill> get bills => _bills;
  List<NotificationItem> get notifications => _notifications;
  List<Transaction> get transactions => _transactions;
  List<Transaction> get recentTransactions => _transactions.take(5).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Computed properties
  double get totalLoanBalance => _loans.where((loan) => loan.isActive).fold(0, (sum, loan) => sum + loan.remainingBalance);
  double get totalInvestmentValue => _investments.where((inv) => inv.isActive).fold(0, (sum, inv) => sum + inv.totalValue);
  double get totalCreditCardBalance => _creditCards.where((card) => card.isActive).fold(0, (sum, card) => sum + card.currentBalance);
  double get totalBillsAmount => _bills.where((bill) => bill.isPending).fold(0, (sum, bill) => sum + bill.amount);
  int get unreadNotificationsCount => _notifications.where((notif) => notif.isUnread).length;

  BankingProvider() {
    _loadMockData();
    _loadMockTransactions();
  }

  void _loadMockData() {
    _loans = [
      Loan(
        id: '1',
        type: 'home',
        amount: 300000,
        interestRate: 3.5,
        termMonths: 360,
        monthlyPayment: 1347.13,
        remainingBalance: 285000,
        startDate: DateTime.now().subtract(const Duration(days: 365)),
        endDate: DateTime.now().add(const Duration(days: 1095)),
        status: 'active',
        accountNumber: '1234567890',
      ),
      Loan(
        id: '2',
        type: 'car',
        amount: 25000,
        interestRate: 4.2,
        termMonths: 60,
        monthlyPayment: 463.12,
        remainingBalance: 18000,
        startDate: DateTime.now().subtract(const Duration(days: 180)),
        endDate: DateTime.now().add(const Duration(days: 1080)),
        status: 'active',
        accountNumber: '1234567890',
      ),
    ];

    _investments = [
      Investment(
        id: '1',
        type: 'stocks',
        name: 'Apple Inc.',
        symbol: 'AAPL',
        shares: 10,
        currentPrice: 175.50,
        purchasePrice: 150.00,
        totalValue: 1755.00,
        gainLoss: 255.00,
        gainLossPercentage: 17.0,
        purchaseDate: DateTime.now().subtract(const Duration(days: 90)),
        status: 'active',
      ),
      Investment(
        id: '2',
        type: 'mutual_funds',
        name: 'Vanguard S&P 500',
        symbol: 'VOO',
        shares: 50,
        currentPrice: 420.30,
        purchasePrice: 400.00,
        totalValue: 21015.00,
        gainLoss: 1015.00,
        gainLossPercentage: 5.08,
        purchaseDate: DateTime.now().subtract(const Duration(days: 180)),
        status: 'active',
      ),
    ];

    _creditCards = [
      CreditCard(
        id: '1',
        cardNumber: '4532****1234',
        cardHolderName: 'John Doe',
        expiryDate: DateTime.now().add(const Duration(days: 730)),
        cvv: '123',
        creditLimit: 10000,
        availableCredit: 7500,
        currentBalance: 2500,
        minimumPayment: 75,
        dueDate: DateTime.now().add(const Duration(days: 15)),
        status: 'active',
        type: 'visa',
      ),
    ];

    _bills = [
      Bill(
        id: '1',
        name: 'Electricity Bill',
        category: 'electricity',
        amount: 125.50,
        dueDate: DateTime.now().add(const Duration(days: 5)),
        status: 'pending',
        description: 'Monthly electricity bill',
        accountNumber: 'ELEC123456',
      ),
      Bill(
        id: '2',
        name: 'Internet Service',
        category: 'internet',
        amount: 79.99,
        dueDate: DateTime.now().add(const Duration(days: 12)),
        status: 'pending',
        description: 'Monthly internet service',
        accountNumber: 'INT789012',
      ),
      Bill(
        id: '3',
        name: 'Water Bill',
        category: 'water',
        amount: 45.00,
        dueDate: DateTime.now().subtract(const Duration(days: 2)),
        status: 'overdue',
        description: 'Monthly water bill',
        accountNumber: 'WAT345678',
      ),
    ];

    _notifications = [
      NotificationItem(
        id: '1',
        title: 'Payment Received',
        message: 'You received Rs1,000.00 from Jane Smith',
        type: 'success',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationItem(
        id: '2',
        title: 'Bill Due Soon',
        message: 'Your electricity bill of Rs125.50 is due in 5 days',
        type: 'warning',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        isRead: false,
      ),
      NotificationItem(
        id: '3',
        title: 'Investment Update',
        message: 'Your Apple stock has gained 17% this month',
        type: 'info',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ];

    notifyListeners();
  }

  void _loadMockTransactions() {
    _transactions = [
      Transaction(
        id: '1',
        type: 'transfer',
        status: 'completed',
        amount: -250.0,
        fromAccount: '1234567890',
        toAccount: '0987654321',
        description: 'Transfer to John Doe',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        fee: 2.50,
        reference: 'TXN${DateTime.now().millisecondsSinceEpoch}',
      ),
      Transaction(
        id: '2',
        type: 'deposit',
        status: 'completed',
        amount: 1000.0,
        toAccount: '1234567890',
        description: 'Salary Deposit',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        reference: 'SAL${DateTime.now().millisecondsSinceEpoch}',
      ),
      Transaction(
        id: '3',
        type: 'withdrawal',
        status: 'completed',
        amount: -50.0,
        fromAccount: '1234567890',
        description: 'ATM Withdrawal',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        fee: 1.00,
        reference: 'ATM${DateTime.now().millisecondsSinceEpoch}',
      ),
      Transaction(
        id: '4',
        type: 'payment',
        status: 'completed',
        amount: -75.0,
        fromAccount: '1234567890',
        description: 'Electricity Bill Payment',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        reference: 'BILL${DateTime.now().millisecondsSinceEpoch}',
      ),
      Transaction(
        id: '5',
        type: 'transfer',
        status: 'completed',
        amount: -100.0,
        fromAccount: '1234567890',
        toAccount: '5555666677',
        description: 'Transfer to Jane Smith',
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        fee: 2.50,
        reference: 'TXN${DateTime.now().millisecondsSinceEpoch}',
      ),
    ];
    notifyListeners();
  }

  Future<void> addDeposit({
    required double amount,
    required String description,
    required String accountNumber,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'deposit',
        status: 'completed',
        amount: amount,
        toAccount: accountNumber,
        description: description,
        timestamp: DateTime.now(),
        reference: 'DEP${DateTime.now().millisecondsSinceEpoch}',
      );

      _transactions.insert(0, transaction);
      
      _notifications.insert(0, NotificationItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Deposit Successful',
        message: 'You deposited Rs${amount.toStringAsFixed(2)} successfully',
        type: 'success',
        timestamp: DateTime.now(),
        isRead: false,
      ));
    } catch (e) {
      _setError('Failed to process deposit. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addWithdrawal({
    required double amount,
    required String description,
    required String accountNumber,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'withdrawal',
        status: 'completed',
        amount: -amount,
        fromAccount: accountNumber,
        description: description,
        timestamp: DateTime.now(),
        fee: 1.00,
        reference: 'WD${DateTime.now().millisecondsSinceEpoch}',
      );

      _transactions.insert(0, transaction);
      
      _notifications.insert(0, NotificationItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Withdrawal Successful',
        message: 'You withdrew Rs${amount.toStringAsFixed(2)} successfully',
        type: 'success',
        timestamp: DateTime.now(),
        isRead: false,
      ));
    } catch (e) {
      _setError('Failed to process withdrawal. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createMoneyRequest({
    required double amount,
    required String description,
    required String recipientAccount,
    String? recipientName,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      _notifications.insert(0, NotificationItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Money Request Sent',
        message: 'You requested Rs${amount.toStringAsFixed(2)} from ${recipientName ?? recipientAccount}',
        type: 'info',
        timestamp: DateTime.now(),
        isRead: false,
      ));
    } catch (e) {
      _setError('Failed to send money request. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> payBill(String billId) async {
    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      final billIndex = _bills.indexWhere((bill) => bill.id == billId);
      if (billIndex != -1) {
        _bills[billIndex] = Bill(
          id: _bills[billIndex].id,
          name: _bills[billIndex].name,
          category: _bills[billIndex].category,
          amount: _bills[billIndex].amount,
          dueDate: _bills[billIndex].dueDate,
          status: 'paid',
          description: _bills[billIndex].description,
          accountNumber: _bills[billIndex].accountNumber,
          paidDate: DateTime.now(),
        );
        
        // Add notification
        _notifications.insert(0, NotificationItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'Bill Paid',
          message: '${_bills[billIndex].name} has been paid successfully',
          type: 'success',
          timestamp: DateTime.now(),
          isRead: false,
        ));
      }
    } catch (e) {
      _setError('Failed to pay bill. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final notificationIndex = _notifications.indexWhere((notif) => notif.id == notificationId);
    if (notificationIndex != -1) {
      _notifications[notificationIndex] = NotificationItem(
        id: _notifications[notificationIndex].id,
        title: _notifications[notificationIndex].title,
        message: _notifications[notificationIndex].message,
        type: _notifications[notificationIndex].type,
        timestamp: _notifications[notificationIndex].timestamp,
        isRead: true,
        actionUrl: _notifications[notificationIndex].actionUrl,
        metadata: _notifications[notificationIndex].metadata,
      );
      notifyListeners();
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = NotificationItem(
          id: _notifications[i].id,
          title: _notifications[i].title,
          message: _notifications[i].message,
          type: _notifications[i].type,
          timestamp: _notifications[i].timestamp,
          isRead: true,
          actionUrl: _notifications[i].actionUrl,
          metadata: _notifications[i].metadata,
        );
      }
    }
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
