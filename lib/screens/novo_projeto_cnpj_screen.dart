import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'projeto_form_screen.dart';

class NovoProjetoCnpjScreen extends StatefulWidget {
  const NovoProjetoCnpjScreen({super.key});

  @override
  State<NovoProjetoCnpjScreen> createState() => _NovoProjetoCnpjScreenState();
}

class _NovoProjetoCnpjScreenState extends State<NovoProjetoCnpjScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cnpjController = TextEditingController();
  bool _possuiMotorredutor = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _cnpjController.dispose();
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

  Future<void> _confirmar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Aqui você pode validar o CNPJ com a API se necessário
    // Por enquanto, apenas navega para a próxima tela
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjetoFormScreen(
          cnpjCliente: _cnpjController.text.replaceAll(RegExp(r'[^\d]'), ''),
          possuiMotorredutor: _possuiMotorredutor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Projeto'),
        backgroundColor: const Color(0xFF2C3E50),
        foregroundColor: Colors.white,
      ),
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
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CNPJ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _cnpjController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              _cnpjFormatter,
                            ],
                            validator: _validateCNPJ,
                            decoration: InputDecoration(
                              hintText: 'Digite o CNPJ',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _errorMessage != null
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF2C3E50),
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          if (_errorMessage != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _possuiMotorredutor,
                            onChanged: (value) {
                              setState(() {
                                _possuiMotorredutor = value ?? false;
                              });
                            },
                            activeColor: const Color(0xFF2C3E50),
                          ),
                          const Expanded(
                            child: Text(
                              'Possui motorredutor',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _confirmar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C3E50),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              'Confirmar',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

