class LoginResponse {
  final String? token;
  final String? userId;
  final String? email;
  final String? name;
  final String? message;
  final bool success;

  LoginResponse({
    this.token,
    this.userId,
    this.email,
    this.name,
    this.message,
    required this.success,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String?,
      userId: json['userId'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool? ?? false,
    );
  }

  factory LoginResponse.error(String message) {
    return LoginResponse(
      success: false,
      message: message,
    );
  }
}

