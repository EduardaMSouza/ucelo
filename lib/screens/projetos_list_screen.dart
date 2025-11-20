import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/projeto_response.dart';
import 'projeto_form_screen.dart';
import 'projeto_detail_screen.dart';
import 'novo_projeto_cnpj_screen.dart';
import 'company_register_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

class ProjetosListScreen extends StatefulWidget {
  const ProjetosListScreen({super.key});

  @override
  State<ProjetosListScreen> createState() => _ProjetosListScreenState();
}

class _ProjetosListScreenState extends State<ProjetosListScreen> {
  List<Projeto> _projetos = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _carregarProjetos();
  }

  Future<void> _carregarProjetos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService.listarProjetos();

      if (!mounted) return;

      if (response.success && response.projetos != null) {
        setState(() {
          _projetos = response.projetos!;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message ?? 'Erro ao carregar projetos';
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

  Future<void> _deletarProjeto(int id, String nomeProjeto) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir o projeto "$nomeProjeto"?'),
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
      final response = await ApiService.removerProjeto(id);

      if (!mounted) return;

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Projeto removido com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
        _carregarProjetos();
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
      // 🔹 ADD THE SAME DRAWER FROM HomeScreen
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF2C3E50),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Color(0xFF4A90A4),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Usuário',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('Cadastrar Empresa'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CompanyRegisterScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sair', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Projetos'),
        backgroundColor: const Color(0xFF2C3E50),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarProjetos,
            tooltip: 'Atualizar',
          ),
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
                onPressed: _carregarProjetos,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C3E50),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        )
            : _projetos.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.folder_open,
                size: 64,
                color: Colors.white70,
              ),
              const SizedBox(height: 16),
              const Text(
                'Nenhum projeto encontrado',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Crie um novo projeto para começar',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        )
            : RefreshIndicator(
          onRefresh: _carregarProjetos,
          color: const Color(0xFF2C3E50),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _projetos.length,
            itemBuilder: (context, index) {
              final projeto = _projetos[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor:
                    projeto.possuiMotorredutorValue ==
                        'POSSUI_MOTORREDUTOR'
                        ? const Color(0xFF4A90A4)
                        : const Color(0xFF5B9BD5),
                    child: Icon(
                      projeto.possuiMotorredutorValue ==
                          'POSSUI_MOTORREDUTOR'
                          ? Icons.settings
                          : Icons.build,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    projeto.nomeProjeto,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      if (projeto.cnpjCliente != null)
                        Text(
                          'CNPJ: ${projeto.cnpjCliente}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      if (projeto.cnpjCliente != null)
                        const SizedBox(height: 2),
                      Text(
                        projeto.possuiMotorredutorValue ==
                            'POSSUI_MOTORREDUTOR'
                            ? 'Com Motorredutor'
                            : 'Sem Motorredutor',
                        style: TextStyle(
                          fontSize: 12,
                          color: projeto.possuiMotorredutorValue ==
                              'POSSUI_MOTORREDUTOR'
                              ? Colors.green
                              : Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.visibility, size: 20),
                            SizedBox(width: 8),
                            Text('Ver detalhes'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete,
                                size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Excluir',
                                style:
                                TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'view') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProjetoDetailScreen(
                                    projetoId:
                                    projeto.idValue),
                          ),
                        ).then((_) => _carregarProjetos());
                      } else if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProjetoFormScreen(
                                    projeto: projeto),
                          ),
                        ).then((_) => _carregarProjetos());
                      } else if (value == 'delete') {
                        _deletarProjeto(
                            projeto.idValue,
                            projeto.nomeProjeto);
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProjetoDetailScreen(
                                projetoId:
                                projeto.idValue),
                      ),
                    ).then((_) => _carregarProjetos());
                  },
                ),
              );
            },
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NovoProjetoCnpjScreen(),
            ),
          ).then((_) => _carregarProjetos());
        },
        backgroundColor: const Color(0xFF2C3E50),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Novo Projeto',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
