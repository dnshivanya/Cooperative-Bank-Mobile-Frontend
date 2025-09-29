class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String accountNumber;
  final double balance;
  final DateTime createdAt;
  final bool isVerified;
  final String? profileImage;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.accountNumber,
    required this.balance,
    required this.createdAt,
    required this.isVerified,
    this.profileImage,
  });

  String get fullName => '$firstName $lastName';
  String get displayName => '$firstName ${lastName[0]}.';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      accountNumber: json['accountNumber'],
      balance: json['balance'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      isVerified: json['isVerified'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'accountNumber': accountNumber,
      'balance': balance,
      'createdAt': createdAt.toIso8601String(),
      'isVerified': isVerified,
      'profileImage': profileImage,
    };
  }

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? accountNumber,
    double? balance,
    DateTime? createdAt,
    bool? isVerified,
    String? profileImage,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      accountNumber: accountNumber ?? this.accountNumber,
      balance: balance ?? this.balance,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
