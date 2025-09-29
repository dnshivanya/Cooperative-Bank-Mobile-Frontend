class Loan {
  final String id;
  final String type; // personal, home, car, business
  final double amount;
  final double interestRate;
  final int termMonths;
  final double monthlyPayment;
  final double remainingBalance;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // active, paid, defaulted
  final String accountNumber;

  Loan({
    required this.id,
    required this.type,
    required this.amount,
    required this.interestRate,
    required this.termMonths,
    required this.monthlyPayment,
    required this.remainingBalance,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.accountNumber,
  });

  double get progressPercentage {
    final totalMonths = termMonths;
    final elapsedMonths = DateTime.now().difference(startDate).inDays / 30;
    return (elapsedMonths / totalMonths * 100).clamp(0, 100);
  }

  bool get isActive => status == 'active';
  bool get isPaid => status == 'paid';
  bool get isDefaulted => status == 'defaulted';

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'],
      type: json['type'],
      amount: json['amount'].toDouble(),
      interestRate: json['interestRate'].toDouble(),
      termMonths: json['termMonths'],
      monthlyPayment: json['monthlyPayment'].toDouble(),
      remainingBalance: json['remainingBalance'].toDouble(),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      status: json['status'],
      accountNumber: json['accountNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'interestRate': interestRate,
      'termMonths': termMonths,
      'monthlyPayment': monthlyPayment,
      'remainingBalance': remainingBalance,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
      'accountNumber': accountNumber,
    };
  }
}

class Investment {
  final String id;
  final String type; // stocks, bonds, mutual_funds, etf
  final String name;
  final String symbol;
  final double shares;
  final double currentPrice;
  final double purchasePrice;
  final double totalValue;
  final double gainLoss;
  final double gainLossPercentage;
  final DateTime purchaseDate;
  final String status; // active, sold, suspended

  Investment({
    required this.id,
    required this.type,
    required this.name,
    required this.symbol,
    required this.shares,
    required this.currentPrice,
    required this.purchasePrice,
    required this.totalValue,
    required this.gainLoss,
    required this.gainLossPercentage,
    required this.purchaseDate,
    required this.status,
  });

  bool get isGain => gainLoss >= 0;
  bool get isLoss => gainLoss < 0;
  bool get isActive => status == 'active';

  factory Investment.fromJson(Map<String, dynamic> json) {
    return Investment(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      symbol: json['symbol'],
      shares: json['shares'].toDouble(),
      currentPrice: json['currentPrice'].toDouble(),
      purchasePrice: json['purchasePrice'].toDouble(),
      totalValue: json['totalValue'].toDouble(),
      gainLoss: json['gainLoss'].toDouble(),
      gainLossPercentage: json['gainLossPercentage'].toDouble(),
      purchaseDate: DateTime.parse(json['purchaseDate']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'symbol': symbol,
      'shares': shares,
      'currentPrice': currentPrice,
      'purchasePrice': purchasePrice,
      'totalValue': totalValue,
      'gainLoss': gainLoss,
      'gainLossPercentage': gainLossPercentage,
      'purchaseDate': purchaseDate.toIso8601String(),
      'status': status,
    };
  }
}

class CreditCard {
  final String id;
  final String cardNumber;
  final String cardHolderName;
  final DateTime expiryDate;
  final String cvv;
  final double creditLimit;
  final double availableCredit;
  final double currentBalance;
  final double minimumPayment;
  final DateTime dueDate;
  final String status; // active, blocked, expired
  final String type; // visa, mastercard, amex

  CreditCard({
    required this.id,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvv,
    required this.creditLimit,
    required this.availableCredit,
    required this.currentBalance,
    required this.minimumPayment,
    required this.dueDate,
    required this.status,
    required this.type,
  });

  bool get isActive => status == 'active';
  bool get isBlocked => status == 'blocked';
  bool get isExpired => status == 'expired' || DateTime.now().isAfter(expiryDate);
  double get utilizationPercentage => (currentBalance / creditLimit * 100).clamp(0, 100);

  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      id: json['id'],
      cardNumber: json['cardNumber'],
      cardHolderName: json['cardHolderName'],
      expiryDate: DateTime.parse(json['expiryDate']),
      cvv: json['cvv'],
      creditLimit: json['creditLimit'].toDouble(),
      availableCredit: json['availableCredit'].toDouble(),
      currentBalance: json['currentBalance'].toDouble(),
      minimumPayment: json['minimumPayment'].toDouble(),
      dueDate: DateTime.parse(json['dueDate']),
      status: json['status'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate.toIso8601String(),
      'cvv': cvv,
      'creditLimit': creditLimit,
      'availableCredit': availableCredit,
      'currentBalance': currentBalance,
      'minimumPayment': minimumPayment,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'type': type,
    };
  }
}

class Bill {
  final String id;
  final String name;
  final String category; // electricity, water, internet, phone, insurance
  final double amount;
  final DateTime dueDate;
  final String status; // pending, paid, overdue
  final String? description;
  final String? accountNumber;
  final DateTime? paidDate;

  Bill({
    required this.id,
    required this.name,
    required this.category,
    required this.amount,
    required this.dueDate,
    required this.status,
    this.description,
    this.accountNumber,
    this.paidDate,
  });

  bool get isPending => status == 'pending';
  bool get isPaid => status == 'paid';
  bool get isOverdue => status == 'overdue' || (DateTime.now().isAfter(dueDate) && status == 'pending');
  int get daysUntilDue => dueDate.difference(DateTime.now()).inDays;

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      amount: json['amount'].toDouble(),
      dueDate: DateTime.parse(json['dueDate']),
      status: json['status'],
      description: json['description'],
      accountNumber: json['accountNumber'],
      paidDate: json['paidDate'] != null ? DateTime.parse(json['paidDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'description': description,
      'accountNumber': accountNumber,
      'paidDate': paidDate?.toIso8601String(),
    };
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type; // info, warning, error, success
  final DateTime timestamp;
  final bool isRead;
  final String? actionUrl;
  final Map<String, dynamic>? metadata;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
    this.actionUrl,
    this.metadata,
  });

  bool get isUnread => !isRead;

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'],
      actionUrl: json['actionUrl'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'actionUrl': actionUrl,
      'metadata': metadata,
    };
  }
}
