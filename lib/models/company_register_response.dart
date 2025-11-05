class CompanyRegisterResponse {
  final bool success;
  final String? message;
  final String? companyId;
  final String? companyName;
  final String? email;

  CompanyRegisterResponse({
    required this.success,
    this.message,
    this.companyId,
    this.companyName,
    this.email,
  });

  factory CompanyRegisterResponse.fromJson(Map<String, dynamic> json) {
    return CompanyRegisterResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      companyId: json['companyId'] as String?,
      companyName: json['companyName'] as String?,
      email: json['email'] as String?,
    );
  }

  factory CompanyRegisterResponse.error(String message) {
    return CompanyRegisterResponse(
      success: false,
      message: message,
    );
  }
}

