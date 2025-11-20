import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/projeto_response.dart';
import 'projeto_form_screen.dart';

class ProjetoDetailScreen extends StatefulWidget {
  final int projetoId;

  const ProjetoDetailScreen({super.key, required this.projetoId});

  @override
  State<ProjetoDetailScreen> createState() => _ProjetoDetailScreenState();
}

class _ProjetoDetailScreenState extends State<ProjetoDetailScreen> {
  Projeto? _projeto;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _carregarProjeto();
  }

  Future<void> _carregarProjeto() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService.buscarProjetoPorId(widget.projetoId);

      if (!mounted) return;

      if (response.success && response.projeto != null) {
        setState(() {
          _projeto = response.projeto!;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message ?? 'Erro ao carregar projeto';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Erro: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _deletarProjeto() async {
    if (_projeto == null) return;

    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir o projeto "${_projeto!.nomeProjeto}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmacao != true) return;

    try {
      final response = await ApiService.removerProjeto(_projeto!.idValue);

      if (!mounted) return;

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Projeto removido com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Erro ao remover projeto'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Projeto'),
        backgroundColor: const Color(0xFF2C3E50),
        foregroundColor: Colors.white,
        actions: [
          if (_projeto != null) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProjetoFormScreen(projeto: _projeto),
                  ),
                ).then((_) => _carregarProjeto());
              },
              tooltip: 'Editar',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deletarProjeto,
              tooltip: 'Excluir',
            ),
          ],
        ],
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
        child: _isLoading
            ? const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : _errorMessage != null
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _carregarProjeto,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C3E50),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        )
            : _projeto == null
            ? const Center(
          child: Text(
            'Projeto não encontrado',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        )
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                            _projeto!.possuiMotorredutorValue ==
                                'POSSUI_MOTORREDUTOR'
                                ? const Color(0xFF4A90A4)
                                : const Color(0xFF5B9BD5),
                            radius: 30,
                            child: Icon(
                              _projeto!.possuiMotorredutorValue ==
                                  'POSSUI_MOTORREDUTOR'
                                  ? Icons.settings
                                  : Icons.build,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _projeto!.nomeProjeto,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _projeto!.possuiMotorredutorValue ==
                                        'POSSUI_MOTORREDUTOR'
                                        ? Colors
                                        .green
                                        .withOpacity(0.2)
                                        : Colors
                                        .blue
                                        .withOpacity(0.2),
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _projeto!.possuiMotorredutorValue ==
                                        'POSSUI_MOTORREDUTOR'
                                        ? 'Com Motorredutor'
                                        : 'Sem Motorredutor',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: _projeto!.possuiMotorredutorValue ==
                                          'POSSUI_MOTORREDUTOR'
                                          ? Colors.green.shade700
                                          : Colors.blue.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _buildSectionCard(
                'Informações Gerais',
                [
                  _buildInfoRow(
                      'ID', _projeto!.idValue.toString()),
                  _buildInfoRow(
                      'CNPJ Cliente',
                      _projeto!.cnpjCliente ?? ''),
                  _buildInfoRow(
                      'CPF Funcionário',
                      _projeto!.cpf_funcionario ?? ''),
                ],
              ),

              const SizedBox(height: 16),

              _buildSectionCard(
                'Especificações do Motor',
                [
                  _buildInfoRow('Potência',
                      '${_projeto!.potenciaMotor} kW'),
                  _buildInfoRow('Rotação',
                      '${_projeto!.rotacaoMotor} rpm'),
                  if (_projeto!.rendimento != null)
                    _buildInfoRow('Rendimento',
                        '${_projeto!.rendimento}'),
                  if (_projeto!.fatorDeServico != null)
                    _buildInfoRow('Fator de Serviço',
                        '${_projeto!.fatorDeServico}'),
                ],
              ),

              const SizedBox(height: 16),

              if (_projeto!.possuiMotorredutorValue ==
                  'POSSUI_MOTORREDUTOR')
                _buildSectionCard(
                  'Especificações do Motorredutor',
                  [
                    if (_projeto!.diametro != null)
                      _buildInfoRow('Diâmetro',
                          '${_projeto!.diametro} m'),
                    if (_projeto!.reducao != null)
                      _buildInfoRow(
                          'Redução', '${_projeto!.reducao}'),
                  ],
                )
              else
                _buildSectionCard(
                  'Especificações do Projeto',
                  [
                    if (_projeto!.fileiras != null)
                      _buildInfoRow('Fileiras',
                          _projeto!.fileiras.toString()),
                    if (_projeto!.diametro != null)
                      _buildInfoRow('Diâmetro',
                          '${_projeto!.diametro} m'),
                    if (_projeto!.altura != null)
                      _buildInfoRow('Altura',
                          '${_projeto!.altura} m'),
                    if (_projeto!.densidade != null)
                      _buildInfoRow(
                          'Densidade',
                          '${_projeto!.densidade} kg/m³'),
                    if (_projeto!.velocidade != null)
                      _buildInfoRow('Velocidade',
                          '${_projeto!.velocidade} m/s'),
                    if (_projeto!.passo != null)
                      _buildInfoRow(
                          'Passo', '${_projeto!.passo} m'),
                  ],
                ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
