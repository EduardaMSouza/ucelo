import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/login_request.dart';
import 'company_register_screen.dart';
import 'home_screen.dart';
import '../widgets/validated_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Por favor, digite sua senha';
    if (value.length < 6) return 'A senha deve ter pelo menos 6 caracteres';
    if (value.length > 50) return 'A senha deve ter no máximo 50 caracteres';
    if (value.contains(' ')) return 'A senha não pode conter espaços';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Por favor, digite seu e-mail';
    final trimmedEmail = value.trim();
    if (trimmedEmail.isEmpty) return 'Por favor, digite seu e-mail';
    if (!trimmedEmail.contains('@')) return 'O e-mail deve conter @';
    final parts = trimmedEmail.split('@');
    if (parts.length != 2) return 'Formato de e-mail inválido';
    if (parts[0].isEmpty) return 'O e-mail deve ter um nome antes do @';
    if (parts[1].isEmpty || !parts[1].contains('.')) {
      return 'O e-mail deve ter um domínio válido';
    }
    if (!_isValidEmail(trimmedEmail)) return 'Por favor, digite um e-mail válido';
    if (trimmedEmail.length > 100) return 'O e-mail deve ter no máximo 100 caracteres';
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final emailError = _validateEmail(email);
    final passwordError = _validatePassword(password);
    if (emailError != null || passwordError != null) {
      _formKey.currentState!.validate();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final loginRequest = LoginRequest(email: email, password: password);
      final response = await ApiService.login(loginRequest);

      if (!mounted) return;

      if (response.success) {
        print('✅ Login mock bem-sucedido!');
        print('Token: ${response.token}');
        print('User ID: ${response.userId}');
        print('Email: ${response.email}');

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Erro ao fazer login'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A90A4),
              Color(0xFF5B9BD5),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.flutter_dash,
                          size: 50,
                          color: Color(0xFF4A90A4),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Ucelo',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(flex: 2),
                  ValidatedTextField(
                    controller: _emailController,
                    hintText: 'Digite seu e-mail',
                    icon: Icons.email_outlined,
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => _formKey.currentState?.validate(),
                  ),

                  const SizedBox(height: 20),
                  ValidatedTextField(
                    controller: _passwordController,
                    hintText: 'Digite sua senha',
                    icon: Icons.lock_outline,
                    validator: _validatePassword,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    onFieldSubmitted: (_) {
                      if (_formKey.currentState!.validate()) _handleLogin();
                    },
                    onChanged: (_) => _formKey.currentState?.validate(),
                  ),

                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C3E50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 5,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : const Text(
                        'Entrar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CompanyRegisterScreen()),
                      );
                    },
                    child: const Text(
                      'Não tem uma conta? Cadastre-se',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
