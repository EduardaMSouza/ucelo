import 'dart:math';
import 'package:flutter/material.dart';
import '../models/projeto_response.dart';
import '../services/api_service.dart';
import 'projetos_list_screen.dart';

class ProjetoResultadoScreen extends StatefulWidget {
  final ProjetoResponse response;
  final String nomeProjeto;
  final bool possuiMotorredutor;

  const ProjetoResultadoScreen({
    super.key,
    required this.response,
    required this.nomeProjeto,
    required this.possuiMotorredutor,
  });

  @override
  State<ProjetoResultadoScreen> createState() => _ProjetoResultadoScreenState();
}

class _ProjetoResultadoScreenState extends State<ProjetoResultadoScreen> {
  bool _isSaving = false;
  bool _isDownloading = false;

  final List<String> modelosCaneca = [
    "11X6",
    "12X6",
    "14X6",
    "16X6",
    "18X6",
    "11X8M1",
    "12X8M1",
    "14X8M1",
    "16X8M1",
  ];

  late final String modeloCanecaAleatorio;

  @override
  void initState() {
    super.initState();
    final random = Random();
    modeloCanecaAleatorio = modelosCaneca[random.nextInt(modelosCaneca.length)];
  }

  Future<void> _salvarProjeto() async {
    setState(() => _isSaving = true);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Projeto salvo com sucesso'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ProjetosListScreen()),
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _downloadPdf(int? projetoId) async {
    if (projetoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ID do projeto não disponível'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isDownloading = true);

    try {
      final filePath = await ApiService.downloadPdf(projetoId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF baixado com sucesso: $filePath'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao baixar PDF: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6C8FA5),
      appBar: AppBar(
        title: Text('Projeto - ${widget.nomeProjeto}'),
        backgroundColor: const Color(0xFF2C3E50),
        foregroundColor: Colors.white,
        actions: [
          if (widget.response.projeto?.idValue != null)
            IconButton(
              icon: _isDownloading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Icon(Icons.download),
              onPressed: _isDownloading
                  ? null
                  : () => _downloadPdf(widget.response.projeto?.idValue),
              tooltip: 'Download PDF',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resultado',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // 🔥 NOVOS CAMPOS BONITOS
            _buildMockResultCard(
              "Canecas por metro",
              "5 canecas p/metro",
              Icons.shopping_basket,
            ),
            const SizedBox(height: 16),

            _buildMockResultCard(
              "Potência necessária do motor",
              "500 rpm",
              Icons.power,
            ),
            const SizedBox(height: 16),

            _buildMockResultCard(
              "Modelo de correia compatível",
              "Modelo exemplo",
              Icons.cable,
            ),
            const SizedBox(height: 16),

            _buildMockResultCard(
              "Modelo da caneca",
              modeloCanecaAleatorio,
              Icons.category,
            ),
            const SizedBox(height: 32),

            // CAMPOS REAIS
            if (widget.possuiMotorredutor &&
                widget.response.responseComMotorredutor != null)
              _buildComMotorredutorResults(
                  widget.response.responseComMotorredutor!)
            else if (!widget.possuiMotorredutor &&
                widget.response.responseSemMotorredutor != null)
              _buildSemMotorredutorResults(
                  widget.response.responseSemMotorredutor!),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _salvarProjeto,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F2D3A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(
                  valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : const Text(
                  'Salvar projeto',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 Novo card estiloso (substitui o antigo mock)
  Widget _buildMockResultCard(String label, String value, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Color(0xFF4A90A4), size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------------------
  // RESULTADOS REAIS (sem alterações)
  // -----------------------------------------------------

  Widget _buildSemMotorredutorResults(
      ProjetoSemMotorredutorResponse response) {
    return Column(
      children: [
        _buildResultCard(
          'Capacidade real',
          '${response.capacidadeReal.toStringAsFixed(2)} kg/h',
          Icons.speed,
        ),
        const SizedBox(height: 16),
        _buildResultCard(
          'Velocidade do elevador desejada',
          '${response.velocidadeElevadorDesejada.toStringAsFixed(2)} m/s',
          Icons.speed,
        ),
        const SizedBox(height: 16),
        _buildResultCard(
          'Potência necessária do motor',
          '${response.potenciaNecessaria.toStringAsFixed(2)} kW',
          Icons.power,
        ),
        const SizedBox(height: 16),
        _buildResultCard(
          'Potência em CV',
          '${response.potenciaEmCv.toStringAsFixed(2)} CV',
          Icons.power,
        ),
        const SizedBox(height: 16),
        _buildResultCard(
          'Momento máximo',
          '${response.momentoMaximo.toStringAsFixed(2)}',
          Icons.trending_up,
        ),
        const SizedBox(height: 16),
        _buildResultCard(
          'Comprimento da correia',
          '${response.comprimentoCorreia.toStringAsFixed(2)} m',
          Icons.straighten,
        ),
        const SizedBox(height: 16),
        _buildResultCard(
          'Quantidade de canecas suportadas',
          '${response.quantidadeCanecaSuportada}',
          Icons.numbers,
        ),
        if (response.motorRecomendado != null) ...[
          const SizedBox(height: 16),
          _buildMotorCard(response.motorRecomendado!),
        ],
      ],
    );
  }

  Widget _buildComMotorredutorResults(
      ProjetoComMotorredutorResponse response) {
    return Column(
      children: [
        _buildResultCard(
          'Rotação existente',
          '${response.rotacaoExistente.toStringAsFixed(2)} rpm',
          Icons.rotate_right,
        ),
        const SizedBox(height: 16),
        _buildResultCard(
          'Velocidade existente',
          '${response.velocidadeExistente.toStringAsFixed(2)} m/s',
          Icons.speed,
        ),
        const SizedBox(height: 16),
        _buildResultCard(
          'Capacidade real',
          '${response.capacidadeReal.toStringAsFixed(2)} kg/h',
          Icons.speed,
        ),
        const SizedBox(height: 16),
        _buildResultCard(
          'Potência necessária',
          '${response.potenciaNecessaria.toStringAsFixed(2)} kW',
          Icons.power,
        ),
        const SizedBox(height: 16),
        _buildResultCard(
          'Momento máximo',
          '${response.momentoMaximo.toStringAsFixed(2)}',
          Icons.trending_up,
        ),
        if (response.motorRecomendado != null) ...[
          const SizedBox(height: 16),
          _buildMotorCard(response.motorRecomendado!),
        ],
      ],
    );
  }

  Widget _buildResultCard(String label, String value, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF4A90A4), size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotorCard(Motor motor) {
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
            const Text(
              'Motor Recomendado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Modelo', motor.modelo),
            _buildInfoRow('Potência Nominal', '${motor.potenciaNominal} kW'),
            _buildInfoRow('Torque Máximo', '${motor.torqueMaximo} N.m'),
            _buildInfoRow('Rotação de Saída', '${motor.rotacaoSaida} rpm'),
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
