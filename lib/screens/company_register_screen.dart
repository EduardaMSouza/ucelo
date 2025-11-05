import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import '../models/company_register_request.dart';

class CompanyRegisterScreen extends StatefulWidget {
  const CompanyRegisterScreen({super.key});

  @override
  State<CompanyRegisterScreen> createState() => _CompanyRegisterScreenState();
}

class _CompanyRegisterScreenState extends State<CompanyRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  
  bool _isLoading = false;
  int? _focusedFieldIndex;

  @override
  void dispose() {
    _companyNameController.dispose();
    _cnpjController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String? _validateCNPJ(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite o CNPJ';
    }
    final cnpj = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cnpj.length != 14) {
      return 'CNPJ deve ter 14 dígitos';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite o telefone';
    }
    final phone = value.replaceAll(RegExp(r'[^\d]'), '');
    if (phone.length < 10) {
      return 'Telefone inválido';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite o e-mail';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Por favor, digite um e-mail válido';
    }
    return null;
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = CompanyRegisterRequest(
        companyName: _companyNameController.text.trim(),
        cnpj: _cnpjController.text.replaceAll(RegExp(r'[^\d]'), ''),
        address: _addressController.text.trim(),
        phone: _phoneController.text.replaceAll(RegExp(r'[^\d]'), ''),
        email: _emailController.text.trim(),
      );

      final response = await ApiService.registerCompany(request);

      if (!mounted) return;

      if (response.success) {
        print('✅ Cadastro mock bem-sucedido!');
        print('Company ID: ${response.companyId}');
        print('Company Name: ${response.companyName}');
        print('Email: ${response.email}');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Empresa cadastrada com sucesso!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      } else {
        print('❌ Cadastro falhou: ${response.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Erro ao cadastrar empresa'),
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
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  TextInputFormatter get _cnpjFormatter => TextInputFormatter.withFunction(
        (oldValue, newValue) {
          final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
          if (text.length > 14) {
            return oldValue;
          }
          
          String formatted = text;
          if (text.length > 12) {
            formatted = '${text.substring(0, 2)}.${text.substring(2, 5)}.${text.substring(5, 8)}/${text.substring(8, 12)}-${text.substring(12)}';
          } else if (text.length > 8) {
            formatted = '${text.substring(0, 2)}.${text.substring(2, 5)}.${text.substring(5, 8)}/${text.substring(8)}';
          } else if (text.length > 5) {
            formatted = '${text.substring(0, 2)}.${text.substring(2, 5)}.${text.substring(5)}';
          } else if (text.length > 2) {
            formatted = '${text.substring(0, 2)}.${text.substring(2)}';
          }
          
          int cursorPosition = formatted.length;
          if (newValue.selection.baseOffset < oldValue.text.length) {
            final oldDigits = oldValue.text.replaceAll(RegExp(r'[^\d]'), '');
            final newDigits = text;
            if (newDigits.length < oldDigits.length) {
              cursorPosition = newValue.selection.baseOffset;
            }
          }
          
          return TextEditingValue(
            text: formatted,
            selection: TextSelection.collapsed(offset: cursorPosition),
          );
        },
      );

  TextInputFormatter get _phoneFormatter => TextInputFormatter.withFunction(
        (oldValue, newValue) {
          final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
          if (text.length > 11) {
            return oldValue;
          }
          
          String formatted = text;
          if (text.length > 7) {
            formatted = '(${text.substring(0, 2)}) ${text.substring(2, 7)}-${text.substring(7)}';
          } else if (text.length > 2) {
            formatted = '(${text.substring(0, 2)}) ${text.substring(2)}';
          }
          
          int cursorPosition = formatted.length;
          if (newValue.selection.baseOffset < oldValue.text.length) {
            final oldDigits = oldValue.text.replaceAll(RegExp(r'[^\d]'), '');
            final newDigits = text;
            if (newDigits.length < oldDigits.length) {
              cursorPosition = newValue.selection.baseOffset;
            }
          }
          
          return TextEditingValue(
            text: formatted,
            selection: TextSelection.collapsed(offset: cursorPosition),
          );
        },
      );

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    int fieldIndex = 0,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final isFocused = _focusedFieldIndex == fieldIndex;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: isFocused
            ? Border.all(color: const Color(0xFF4A90A4), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: const Color(0xFF4A90A4)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        keyboardType: keyboardType,
        validator: validator,
        inputFormatters: inputFormatters,
        onTap: () {
          setState(() {
            _focusedFieldIndex = fieldIndex;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF4A8FB4),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 56,
                color: const Color(0xFF2C3E50),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 40),
                        const Text(
                          'Cadastro',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 40),
                        _buildInputField(
                          controller: _companyNameController,
                          hintText: 'Nome da empresa',
                          icon: Icons.business,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, digite o nome da empresa';
                            }
                            return null;
                          },
                          fieldIndex: 0,
                        ),
                        _buildInputField(
                          controller: _cnpjController,
                          hintText: 'CNPJ',
                          icon: Icons.description,
                          validator: _validateCNPJ,
                          keyboardType: TextInputType.number,
                          fieldIndex: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            _cnpjFormatter,
                          ],
                        ),
                        _buildInputField(
                          controller: _addressController,
                          hintText: 'Endereço',
                          icon: Icons.location_on,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, digite o endereço';
                            }
                            return null;
                          },
                          fieldIndex: 2,
                        ),
                        _buildInputField(
                          controller: _phoneController,
                          hintText: 'Telefone',
                          icon: Icons.phone,
                          validator: _validatePhone,
                          keyboardType: TextInputType.phone,
                          fieldIndex: 3,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            _phoneFormatter,
                          ],
                        ),
                        _buildInputField(
                          controller: _emailController,
                          hintText: 'E-mail',
                          icon: Icons.email,
                          validator: _validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          fieldIndex: 4,
                        ),
                        
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2C3E50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 5,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Confirmar',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

