import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/company_register_request.dart';
import '../models/company_register_response.dart';
import '../models/projeto_request.dart';
import '../models/projeto_response.dart';

class ApiService {
  // static const String baseUrl = 'https://seu-backend.com/api';
  // static const String baseUrl = 'http://localhost:3000/api';
  // static const String baseUrl = 'https://api.ucelo.com/v1';
  static const String baseUrl = 'http://10.5.0.2:8081';

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

  // ========== MÉTODOS DE PROJETO ==========

  // Listar todos os projetos
  static Future<ProjetoResponse> listarProjetos() async {
    try {
      final url = Uri.parse('$baseUrl/criar-projeto');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
        final projetos = jsonList.map((p) => Projeto.fromJson(p as Map<String, dynamic>)).toList();
        return ProjetoResponse.successList(projetos);
      } else {
        return ProjetoResponse.error(
          'Erro no servidor: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ProjetoResponse.error(
        'Erro de conexão: ${e.toString()}',
      );
    }
  }

  // Buscar projeto por ID
  static Future<ProjetoResponse> buscarProjetoPorId(int id) async {
    try {
      final url = Uri.parse('$baseUrl/criar-projeto/$id/projeto');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final projeto = Projeto.fromJson(jsonResponse);
        return ProjetoResponse.success(projeto);
      } else if (response.statusCode == 404) {
        return ProjetoResponse.error('Projeto não encontrado');
      } else {
        return ProjetoResponse.error(
          'Erro no servidor: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ProjetoResponse.error(
        'Erro de conexão: ${e.toString()}',
      );
    }
  }

  // Criar projeto sem motorredutor
  static Future<ProjetoResponse> criarProjetoSemMotorredutor(
      ProjetoSemMotorredutorRequest request) async {
    try {
      final url = Uri.parse('$baseUrl/criar-projeto/sem-motorredutor');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final responseData = ProjetoSemMotorredutorResponse.fromJson(jsonResponse);
        return ProjetoResponse(
          success: true,
          responseSemMotorredutor: responseData,
          message: 'Projeto criado com sucesso',
        );
      } else if (response.statusCode == 400) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return ProjetoResponse.error(
          jsonResponse['message'] as String? ?? 'Dados inválidos',
        );
      } else {
        return ProjetoResponse.error(
          'Erro no servidor: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ProjetoResponse.error(
        'Erro de conexão: ${e.toString()}',
      );
    }
  }

  // Criar projeto com motorredutor
  static Future<ProjetoResponse> criarProjetoComMotorredutor(
      ProjetoComMotorredutorRequest request) async {
    try {
      final url = Uri.parse('$baseUrl/criar-projeto/com-motorredutor');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final responseData = ProjetoComMotorredutorResponse.fromJson(jsonResponse);
        return ProjetoResponse(
          success: true,
          responseComMotorredutor: responseData,
          message: 'Projeto criado com sucesso',
        );
      } else if (response.statusCode == 400) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return ProjetoResponse.error(
          jsonResponse['message'] as String? ?? 'Dados inválidos',
        );
      } else {
        return ProjetoResponse.error(
          'Erro no servidor: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ProjetoResponse.error(
        'Erro de conexão: ${e.toString()}',
      );
    }
  }

  // Remover projeto
  static Future<ProjetoResponse> removerProjeto(int id) async {
    try {
      final url = Uri.parse('$baseUrl/criar-projeto/$id');
      
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return ProjetoResponse(
          success: true,
          message: 'Projeto removido com sucesso',
        );
      } else if (response.statusCode == 404) {
        return ProjetoResponse.error('Projeto não encontrado');
      } else {
        return ProjetoResponse.error(
          'Erro no servidor: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ProjetoResponse.error(
        'Erro de conexão: ${e.toString()}',
      );
    }
  }

  // Atualizar projeto sem motorredutor
  static Future<ProjetoResponse> atualizarProjetoSemMotorredutor(
      int id, ProjetoSemMotorredutorRequest request) async {
    try {
      final url = Uri.parse('$baseUrl/criar-projeto/atualizar-sem-motorredutor/$id');
      
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return ProjetoResponse(
          success: true,
          message: 'Projeto atualizado com sucesso',
        );
      } else if (response.statusCode == 400) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return ProjetoResponse.error(
          jsonResponse['message'] as String? ?? 'Dados inválidos',
        );
      } else if (response.statusCode == 404) {
        return ProjetoResponse.error('Projeto não encontrado');
      } else {
        return ProjetoResponse.error(
          'Erro no servidor: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ProjetoResponse.error(
        'Erro de conexão: ${e.toString()}',
      );
    }
  }

  // Atualizar projeto com motorredutor
  static Future<ProjetoResponse> atualizarProjetoComMotorredutor(
      int id, ProjetoComMotorredutorRequest request) async {
    try {
      final url = Uri.parse('$baseUrl/criar-projeto/atualizar-com-motorredutor/$id');
      
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return ProjetoResponse(
          success: true,
          message: 'Projeto atualizado com sucesso',
        );
      } else if (response.statusCode == 400) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return ProjetoResponse.error(
          jsonResponse['message'] as String? ?? 'Dados inválidos',
        );
      } else if (response.statusCode == 404) {
        return ProjetoResponse.error('Projeto não encontrado');
      } else {
        return ProjetoResponse.error(
          'Erro no servidor: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ProjetoResponse.error(
        'Erro de conexão: ${e.toString()}',
      );
    }
  }

  // Download PDF do projeto
  static Future<String?> downloadPdf(int id) async {
    try {
      final url = Uri.parse('$baseUrl/criar-projeto/$id/pdf');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/projeto_$id.pdf');
        await file.writeAsBytes(response.bodyBytes);
        return file.path;
      } else if (response.statusCode == 404) {
        throw Exception('Projeto não encontrado');
      } else {
        throw Exception('Erro ao baixar PDF: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: ${e.toString()}');
    }
  }
}

