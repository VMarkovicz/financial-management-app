class UserModel {
  final String id;
  String username;
  final String email;
  String? profilePictureUrl;
  double? balance;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.balance = 0.0,
    this.profilePictureUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      balance: (json['balance'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'username': username, 'email': email, 'balance': balance};
  }
}

class UserRegisterModel {
  final String username;
  final String email;
  final String password;
  final double? balance;

  UserRegisterModel({
    required this.username,
    required this.email,
    required this.password,
    this.balance = 0.0,
  });

  factory UserRegisterModel.fromJson(Map<String, dynamic> json) {
    return UserRegisterModel(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      balance: (json['balance'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'balance': balance,
    };
  }
}
