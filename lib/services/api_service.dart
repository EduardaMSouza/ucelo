import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/company_register_request.dart';
import '../models/company_register_response.dart';

class ApiService {
  // static const String baseUrl = 'https://seu-backend.com/api';
  // static const String baseUrl = 'http://localhost:3000/api';
  // static const String baseUrl = 'https://api.ucelo.com/v1';

  static Future<LoginResponse> login(LoginRequest request) async {
    /*
    try {
      final url = Uri.parse('$baseUrl/auth/login');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // 'Accept': 'application/json',
          // 'Authorization': 'Bearer token',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return LoginResponse.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return LoginResponse.fromJson(jsonResponse);
      } else {
        return LoginResponse.error(
          'Erro no servidor: ${response.statusCode}',
        );
      }
    } catch (e) {
      return LoginResponse.error(
        'Erro de conexão: ${e.toString()}',
      );
    }
    */
    
    await Future.delayed(const Duration(milliseconds: 500));
    final email = request.email.trim();
    final password = request.password;
    
    if (email.isNotEmpty && password.isNotEmpty && password.length >= 6) {
      return LoginResponse(
        success: true,
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'mock_user_id_${email.hashCode}',
        email: email,
        name: 'Usuário Mock',
        message: 'Login realizado com sucesso (mock)',
      );
    } else {
      return LoginResponse(
        success: false,
        message: 'Email e senha são obrigatórios (mínimo 6 caracteres para senha)',
      );
    }
  }

  static Future<CompanyRegisterResponse> registerCompany(
      CompanyRegisterRequest request) async {
    /*
    try {
      final url = Uri.parse('$baseUrl/company/register');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // 'Accept': 'application/json',
          // 'Authorization': 'Bearer token',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return CompanyRegisterResponse.fromJson(jsonResponse);
      } else if (response.statusCode == 400) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return CompanyRegisterResponse.fromJson(jsonResponse);
      } else if (response.statusCode == 409) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return CompanyRegisterResponse.fromJson(jsonResponse);
      } else {
        return CompanyRegisterResponse.error(
          'Erro no servidor: ${response.statusCode}',
        );
      }
    } catch (e) {
      return CompanyRegisterResponse.error(
        'Erro de conexão: ${e.toString()}',
      );
    }
    */
    
    await Future.delayed(const Duration(milliseconds: 500));
    if (request.companyName.trim().isNotEmpty &&
        request.cnpj.trim().isNotEmpty &&
        request.address.trim().isNotEmpty &&
        request.phone.trim().isNotEmpty &&
        request.email.trim().isNotEmpty) {
      return CompanyRegisterResponse(
        success: true,
        companyId: 'mock_company_id_${DateTime.now().millisecondsSinceEpoch}',
        companyName: request.companyName.trim(),
        email: request.email.trim(),
        message: 'Empresa cadastrada com sucesso (mock)',
      );
    } else {
      return CompanyRegisterResponse(
        success: false,
        message: 'Todos os campos são obrigatórios',
      );
    }
  }

  /*
  static Future<Map<String, dynamic>> getProfile(String token) async {
    try {
      final url = Uri.parse('$baseUrl/user/profile');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Erro ao buscar perfil: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: ${e.toString()}');
    }
  }
  */
}

