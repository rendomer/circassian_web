// lib/models/user_model.dart

class User {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final int? childrenCount;
  final int? confirmationsCount;
  final bool iHaveConfirmed; // 🚩 новый флаг!

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.childrenCount,
    this.confirmationsCount,
    this.iHaveConfirmed = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final raw = json['children_count'];
    int? parsedCount;
    if (raw is int) {
      parsedCount = raw;
    } else if (raw is String && raw.isNotEmpty) {
      parsedCount = int.tryParse(raw);
    }

    return User(
      id: json['user_id']?.toString(),
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      childrenCount: parsedCount,
      confirmationsCount: json['confirmations_count'] as int? ?? 0,
      iHaveConfirmed: json['i_have_confirmed'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'children_count': childrenCount,
      'confirmations_count': confirmationsCount,
      'i_have_confirmed': iHaveConfirmed,
    };
  }
}
