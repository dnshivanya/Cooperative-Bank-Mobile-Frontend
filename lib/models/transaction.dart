class Transaction {
  final String id;
  final String type; // transfer, deposit, withdrawal, payment
  final String status; // pending, completed, failed, cancelled
  final double amount;
  final String? fromAccount;
  final String? toAccount;
  final String? description;
  final String? reference;
  final DateTime timestamp;
  final double? fee;
  final String? category;

  Transaction({
    required this.id,
    required this.type,
    required this.status,
    required this.amount,
    this.fromAccount,
    this.toAccount,
    this.description,
    this.reference,
    required this.timestamp,
    this.fee,
    this.category,
  });

  bool get isCredit => type == 'deposit' || (type == 'transfer' && toAccount != null);
  bool get isDebit => type == 'withdrawal' || (type == 'transfer' && fromAccount != null);
  bool get isPending => status == 'pending';
  bool get isCompleted => status == 'completed';
  bool get isFailed => status == 'failed';

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: json['type'],
      status: json['status'],
      amount: json['amount'].toDouble(),
      fromAccount: json['fromAccount'],
      toAccount: json['toAccount'],
      description: json['description'],
      reference: json['reference'],
      timestamp: DateTime.parse(json['timestamp']),
      fee: json['fee']?.toDouble(),
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'status': status,
      'amount': amount,
      'fromAccount': fromAccount,
      'toAccount': toAccount,
      'description': description,
      'reference': reference,
      'timestamp': timestamp.toIso8601String(),
      'fee': fee,
      'category': category,
    };
  }

  Transaction copyWith({
    String? id,
    String? type,
    String? status,
    double? amount,
    String? fromAccount,
    String? toAccount,
    String? description,
    String? reference,
    DateTime? timestamp,
    double? fee,
    String? category,
  }) {
    return Transaction(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      fromAccount: fromAccount ?? this.fromAccount,
      toAccount: toAccount ?? this.toAccount,
      description: description ?? this.description,
      reference: reference ?? this.reference,
      timestamp: timestamp ?? this.timestamp,
      fee: fee ?? this.fee,
      category: category ?? this.category,
    );
  }
}
