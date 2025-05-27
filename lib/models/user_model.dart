class UserModel {
  final String id;
  String username;
  final String email;
  String? profilePictureUrl;
  double? balance;
  String? defaultCurrency;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.balance = 0.0,
    this.profilePictureUrl,
    this.defaultCurrency,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      balance: (json['balance'] as num?)?.toDouble(),
      defaultCurrency: json['defaultCurrency'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'balance': balance,
      'defaultCurrency': defaultCurrency,
    };
  }
}

class UserRegisterModel {
  final String username;
  final String email;
  final String password;
  final double? balance;
  final String? defaultCurrency;

  UserRegisterModel({
    required this.username,
    required this.email,
    required this.password,
    this.balance = 0.0,
    this.defaultCurrency = 'USD',
  });

  factory UserRegisterModel.fromJson(Map<String, dynamic> json) {
    return UserRegisterModel(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      balance: (json['balance'] as num?)?.toDouble(),
      defaultCurrency: json['defaultCurrency'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'balance': balance,
      'defaultCurrency': defaultCurrency,
    };
  }
}
