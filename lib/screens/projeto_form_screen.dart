import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/projeto_request.dart';
import '../models/projeto_response.dart';
import '../services/api_service.dart';
import 'projeto_resultado_screen.dart';

class ProjetoFormScreen extends StatefulWidget {
  final Projeto? projeto;
  final String? cnpjCliente;
  final bool? possuiMotorredutor;

  const ProjetoFormScreen({
    super.key,
    this.projeto,
    this.cnpjCliente,
    this.possuiMotorredutor,
  });

  @override
  State<ProjetoFormScreen> createState() => _ProjetoFormScreenState();
}

class _ProjetoFormScreenState extends State<ProjetoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _possuiMotorredutor = false;

  // Controllers
  final TextEditingController _nomeProjetoController = TextEditingController();
  final TextEditingController _cnpjClienteController = TextEditingController();
  final TextEditingController _cpfFuncionarioController = TextEditingController();
  final TextEditingController _potenciaMotorController = TextEditingController();
  final TextEditingController _rotacaoMotorController = TextEditingController();
  
  // Campos para sem motorredutor
  final TextEditingController _fileirasController = TextEditingController();
  final TextEditingController _diametroController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _densidadeController = TextEditingController();
  final TextEditingController _rendimentoController = TextEditingController();
  final TextEditingController _fatorDeServicoController = TextEditingController();
  final TextEditingController _velocidadeController = TextEditingController();
  final TextEditingController _passoController = TextEditingController();
  final TextEditingController _enchimentoController = TextEditingController();
  final TextEditingController _capacidadeDesejadaController = TextEditingController();
  final TextEditingController _volumeCanecaController = TextEditingController();
  
  // Campos para com motorredutor
  final TextEditingController _reducaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.projeto != null) {
      final projeto = widget.projeto!;
      _nomeProjetoController.text = projeto.nomeProjeto;
      _cnpjClienteController.text = projeto.cnpjCliente ?? '';
      _cpfFuncionarioController.text = projeto.cpf_funcionario ?? '';
      _potenciaMotorController.text = projeto.potenciaMotor?.toString() ?? '';
      _rotacaoMotorController.text = projeto.rotacaoMotor?.toString() ?? '';
      _possuiMotorredutor = projeto.possuiMotorredutorValue == 'POSSUI_MOTORREDUTOR';
      
      if (_possuiMotorredutor) {
        _diametroController.text = projeto.diametro?.toString() ?? '';
        _rendimentoController.text = projeto.rendimento?.toString() ?? '';
        _fatorDeServicoController.text = projeto.fatorDeServico?.toString() ?? '';
        _reducaoController.text = projeto.reducao?.toString() ?? '';
      } else {
        _fileirasController.text = projeto.fileiras?.toString() ?? '';
        _diametroController.text = projeto.diametroTambor?.toString() ?? '';
        _alturaController.text = projeto.alturaElevador?.toString() ?? '';
        _densidadeController.text = projeto.densidade?.toString() ?? '';
        _rendimentoController.text = projeto.rendimento?.toString() ?? '';
        _fatorDeServicoController.text = projeto.fatorDeServico?.toString() ?? '';
        _velocidadeController.text = projeto.velocidadeElevador?.toString() ?? '';
        _passoController.text = projeto.passoCorreia?.toString() ?? '';
      }
    } else {
      if (widget.cnpjCliente != null) {
        _cnpjClienteController.text = widget.cnpjCliente!;
      }
      if (widget.possuiMotorredutor != null) {
        _possuiMotorredutor = widget.possuiMotorredutor!;
      }
    }
  }

  @override
  void dispose() {
    _nomeProjetoController.dispose();
    _cnpjClienteController.dispose();
    _cpfFuncionarioController.dispose();
    _potenciaMotorController.dispose();
    _rotacaoMotorController.dispose();
    _fileirasController.dispose();
    _diametroController.dispose();
    _alturaController.dispose();
    _densidadeController.dispose();
    _rendimentoController.dispose();
    _fatorDeServicoController.dispose();
    _velocidadeController.dispose();
    _passoController.dispose();
    _reducaoController.dispose();
    _enchimentoController.dispose();
    _capacidadeDesejadaController.dispose();
    _volumeCanecaController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  String? _validateDouble(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    final doubleValue = double.tryParse(value);
    if (doubleValue == null) {
      return '$fieldName deve ser um número válido';
    }
    if (doubleValue <= 0) {
      return '$fieldName deve ser maior que zero';
    }
    return null;
  }

  String? _validateInt(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    final intValue = int.tryParse(value);
    if (intValue == null) {
      return '$fieldName deve ser um número inteiro válido';
    }
    if (intValue <= 0) {
      return '$fieldName deve ser maior que zero';
    }
    return null;
  }

  Future<void> _salvarProjeto() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      ProjetoResponse response;

      if (widget.projeto != null) {
        // Atualizar projeto existente - usar ProjetoRequest para compatibilidade
        final request = ProjetoRequest(
          nomeProjeto: _nomeProjetoController.text.trim(),
          cnpjCliente: _cnpjClienteController.text.trim(),
          cpf_funcionario: _cpfFuncionarioController.text.trim(),
          potenciaMotor: _potenciaMotorController.text.isNotEmpty
              ? double.parse(_potenciaMotorController.text)
              : null,
          rotacaoMotor: _rotacaoMotorController.text.isNotEmpty
              ? double.parse(_rotacaoMotorController.text)
              : null,
          possuiMotorredutor: _possuiMotorredutor
              ? 'POSSUI_MOTORREDUTOR'
              : 'NAO_POSSUI_MOTORREDUTOR',
          fileiras: _possuiMotorredutor
              ? null
              : int.tryParse(_fileirasController.text),
          diametro: _diametroController.text.isNotEmpty
              ? double.tryParse(_diametroController.text)
              : null,
          altura: _possuiMotorredutor
              ? null
              : (_alturaController.text.isNotEmpty
                  ? double.tryParse(_alturaController.text)
                  : null),
          densidade: _possuiMotorredutor
              ? null
              : (_densidadeController.text.isNotEmpty
                  ? double.tryParse(_densidadeController.text)
                  : null),
          rendimento: _rendimentoController.text.isNotEmpty
              ? double.tryParse(_rendimentoController.text)
              : null,
          fatorDeServico: _fatorDeServicoController.text.isNotEmpty
              ? double.tryParse(_fatorDeServicoController.text)
              : null,
          velocidade: _possuiMotorredutor
              ? null
              : (_velocidadeController.text.isNotEmpty
                  ? double.tryParse(_velocidadeController.text)
                  : null),
          passo: _possuiMotorredutor
              ? null
              : (_passoController.text.isNotEmpty
                  ? double.tryParse(_passoController.text)
                  : null),
          reducao: _possuiMotorredutor
              ? (_reducaoController.text.isNotEmpty
                  ? double.tryParse(_reducaoController.text)
                  : null)
              : null,
        );

        if (_possuiMotorredutor) {
          final requestComMotor = ProjetoComMotorredutorRequest(
            nomeProjeto: request.nomeProjeto,
            potenciaMotor: request.potenciaMotor ?? 0,
            rotacaoMotor: request.rotacaoMotor ?? 0,
            diametro: request.diametro ?? 0,
            reducao: request.reducao ?? 0,
            rendimento: request.rendimento ?? 0,
            fatorDeServico: request.fatorDeServico ?? 0,
            possuiMotorredutor: 'POSSUI_MOTORREDUTOR',
          );
          response = await ApiService.atualizarProjetoComMotorredutor(
              widget.projeto!.idValue, requestComMotor);
        } else {
          final requestSemMotor = ProjetoSemMotorredutorRequest(
            nomeProjeto: request.nomeProjeto,
            alturaElevador: request.altura ?? 0,
            densidade: request.densidade ?? 0,
            capacidadeDesejada: _capacidadeDesejadaController.text.isNotEmpty
                ? double.parse(_capacidadeDesejadaController.text)
                : 0,
            velocidadeElevador: request.velocidade ?? 0,
            passoCorreia: request.passo ?? 0,
            numeroFileiras: request.fileiras ?? 0,
            enchimento: _enchimentoController.text.isNotEmpty
                ? double.parse(_enchimentoController.text)
                : 0.8,
            possuiMotorRedutor: 'NAO_POSSUI_MOTORREDUTOR',
            diametroTambor: request.diametro ?? 0,
            volumeCaneca: _volumeCanecaController.text.isNotEmpty
                ? int.parse(_volumeCanecaController.text)
                : 10,
            rendimento: request.rendimento ?? 0,
            fatorDeServico: request.fatorDeServico ?? 0,
          );
          response = await ApiService.atualizarProjetoSemMotorredutor(
              widget.projeto!.idValue, requestSemMotor);
        }
      } else {
        // Criar novo projeto
        if (_possuiMotorredutor) {
          final request = ProjetoComMotorredutorRequest(
            nomeProjeto: _nomeProjetoController.text.trim(),
            potenciaMotor: double.parse(_potenciaMotorController.text),
            rotacaoMotor: double.parse(_rotacaoMotorController.text),
            diametro: double.parse(_diametroController.text),
            reducao: double.parse(_reducaoController.text),
            rendimento: double.parse(_rendimentoController.text),
            fatorDeServico: double.parse(_fatorDeServicoController.text),
            possuiMotorredutor: 'POSSUI_MOTORREDUTOR',
          );
          response = await ApiService.criarProjetoComMotorredutor(request);
        } else {
          final request = ProjetoSemMotorredutorRequest(
            nomeProjeto: _nomeProjetoController.text.trim(),
            alturaElevador: double.parse(_alturaController.text),
            densidade: double.parse(_densidadeController.text),
            capacidadeDesejada: double.parse(_capacidadeDesejadaController.text),
            velocidadeElevador: double.parse(_velocidadeController.text),
            passoCorreia: double.parse(_passoController.text),
            numeroFileiras: int.parse(_fileirasController.text),
            enchimento: _enchimentoController.text.isNotEmpty
                ? double.parse(_enchimentoController.text)
                : 0.8,
            possuiMotorRedutor: 'NAO_POSSUI_MOTORREDUTOR',
            diametroTambor: double.parse(_diametroController.text),
            volumeCaneca: _volumeCanecaController.text.isNotEmpty
                ? int.parse(_volumeCanecaController.text)
                : 10,
            rendimento: double.parse(_rendimentoController.text),
            fatorDeServico: double.parse(_fatorDeServicoController.text),
          );
          response = await ApiService.criarProjetoSemMotorredutor(request);
        }
      }

      if (!mounted) return;

      if (response.success) {
        if (widget.projeto == null) {
          // Navegar para tela de resultados ao criar novo projeto
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProjetoResultadoScreen(
                response: response,
                nomeProjeto: _nomeProjetoController.text.trim(),
                possuiMotorredutor: _possuiMotorredutor,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Projeto atualizado com sucesso'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Erro ao salvar projeto'),
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
      appBar: AppBar(
        title: Text(widget.projeto != null ? 'Editar Projeto' : 'Novo Projeto'),
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
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Tipo de projeto
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
                        'Tipo de Projeto',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('Sem Motorredutor'),
                              value: false,
                              groupValue: _possuiMotorredutor,
                              onChanged: (value) {
                                setState(() {
                                  _possuiMotorredutor = false;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('Com Motorredutor'),
                              value: true,
                              groupValue: _possuiMotorredutor,
                              onChanged: (value) {
                                setState(() {
                                  _possuiMotorredutor = true;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Campos comuns
              _buildTextField(
                controller: _nomeProjetoController,
                label: 'Nome do Projeto',
                validator: (value) => _validateRequired(value, 'Nome do Projeto'),
              ),
              const SizedBox(height: 16),
              if (widget.projeto != null) ...[
                _buildTextField(
                  controller: _cnpjClienteController,
                  label: 'CNPJ do Cliente',
                  validator: (value) => _validateRequired(value, 'CNPJ do Cliente'),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _cpfFuncionarioController,
                  label: 'CPF do Funcionário',
                  validator: (value) => _validateRequired(value, 'CPF do Funcionário'),
                ),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 16),

              // Campos específicos
              if (_possuiMotorredutor) ...[
                _buildTextField(
                  controller: _potenciaMotorController,
                  label: 'Potência do motorredutor (cv)',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => _validateDouble(value, 'Potência do motorredutor'),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _rotacaoMotorController,
                  label: 'Rotação do motor (rpm)',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => _validateDouble(value, 'Rotação do motor'),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _diametroController,
                  label: 'Diâmetro da polia (mm)',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => _validateDouble(value, 'Diâmetro da polia'),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _reducaoController,
                  label: 'Redução',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => _validateDouble(value, 'Redução'),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _rendimentoController,
                  label: 'Rendimento',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => _validateDouble(value, 'Rendimento'),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _fatorDeServicoController,
                  label: 'Fator de Serviço',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => _validateDouble(value, 'Fator de Serviço'),
                ),
              ] else ...[
                _buildTextField(
                  controller: _alturaController,
                  label: 'Altura do elevador (m)',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => _validateDouble(value, 'Altura do elevador'),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _densidadeController,
                  label: 'Densidade do produto (kg/m³)',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => _validateDouble(value, 'Densidade'),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _capacidadeDesejadaController,
                  label: 'Capacidade desejada (t/h)',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => _validateDouble(value, 'Capacidade desejada'),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _velocidadeController,
                  label: 'Velocidade do elevador (m/s)',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => _validateDouble(value, 'Velocidade'),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passoController,
                  label: 'Passo da correia (mm)',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => _validateDouble(value, 'Passo da correia'),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _fileirasController,
                  label: 'Fileiras da correia',
                  keyboardType: TextInputType.number,
                  validator: (value) => _validateInt(value, 'Fileiras'),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _enchimentoController,
                  label: 'Enchimento (0 a 1)',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enchimento é obrigatório';
                    }
                    final doubleValue = double.tryParse(value);
                    if (doubleValue == null) {
                      return 'Enchimento deve ser um número válido';
                    }
                    if (doubleValue < 0 || doubleValue > 1) {
                      return 'Enchimento deve estar entre 0 e 1';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _diametroController,
                  label: 'Diâmetro do tambor (m)',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => _validateDouble(value, 'Diâmetro do tambor'),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _volumeCanecaController,
                  label: 'Volume da caneca (litros)',
                  keyboardType: TextInputType.number,
                  validator: (value) => _validateInt(value, 'Volume da caneca'),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _rendimentoController,
                  label: 'Rendimento',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => _validateDouble(value, 'Rendimento'),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _fatorDeServicoController,
                  label: 'Fator de Serviço',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => _validateDouble(value, 'Fator de Serviço'),
                ),
              ],

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _salvarProjeto,
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
                      : Text(
                          widget.projeto != null ? 'Atualizar' : 'Calcular',
                          style: const TextStyle(
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: keyboardType == TextInputType.number ||
              keyboardType == TextInputType.numberWithOptions(decimal: true)
          ? [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))]
          : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2C3E50), width: 2),
        ),
      ),
    );
  }
}

