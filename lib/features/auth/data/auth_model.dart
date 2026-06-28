// Auth User Model
class AuthUser {
  final String id;
  final String email;
  final String name;
  final String? token;
  final bool onboardingDone;

  AuthUser({
    required this.id,
    required this.email,
    required this.name,
    this.token,
    this.onboardingDone = false,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] as Map<String, dynamic>?;
    return AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: (json['name'] ?? profile?['name'] ?? '') as String,
      token: json['token'] as String?,
      onboardingDone: json['onboardingDone'] == true || profile?['onboardingDone'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'token': token,
      'onboardingDone': onboardingDone,
    };
  }

  AuthUser copyWith({String? id, String? email, String? name, String? token, bool? onboardingDone}) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
      onboardingDone: onboardingDone ?? this.onboardingDone,
    );
  }
}

// Login Request Model
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

// Register Request Model
class RegisterRequest {
  final String email;
  final String password;
  final String name;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
    };
  }
}
