class CompanyRegisterRequest {
  final String companyName;
  final String cnpj;
  final String address;
  final String phone;
  final String email;

  CompanyRegisterRequest({
    required this.companyName,
    required this.cnpj,
    required this.address,
    required this.phone,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'cnpj': cnpj,
      'address': address,
      'phone': phone,
      'email': email,
    };
  }
}

