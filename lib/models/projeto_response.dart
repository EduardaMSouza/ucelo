class ProjetoResponse {
  final bool success;
  final String? message;
  final Projeto? projeto;
  final List<Projeto>? projetos;
  final ProjetoSemMotorredutorResponse? responseSemMotorredutor;
  final ProjetoComMotorredutorResponse? responseComMotorredutor;

  ProjetoResponse({
    required this.success,
    this.message,
    this.projeto,
    this.projetos,
    this.responseSemMotorredutor,
    this.responseComMotorredutor,
  });

  factory ProjetoResponse.fromJson(Map<String, dynamic> json) {
    if (json is List) {
      return ProjetoResponse(
        success: true,
        projetos: (json as List).map((p) => Projeto.fromJson(p as Map<String, dynamic>)).toList(),
      );
    } else if (json.containsKey('projetos') && json['projetos'] is List) {
      return ProjetoResponse(
        success: true,
        projetos: (json['projetos'] as List)
            .map((p) => Projeto.fromJson(p as Map<String, dynamic>))
            .toList(),
      );
    } else if (json.containsKey('projeto')) {
      return ProjetoResponse(
        success: true,
        projeto: Projeto.fromJson(json['projeto'] as Map<String, dynamic>),
      );
    } else if (json.containsKey('idProjeto')) {
      return ProjetoResponse(
        success: true,
        projeto: Projeto.fromJson(json),
      );
    } else {
      return ProjetoResponse(
        success: json['success'] as bool? ?? false,
        message: json['message'] as String?,
      );
    }
  }

  factory ProjetoResponse.error(String message) {
    return ProjetoResponse(
      success: false,
      message: message,
    );
  }

  factory ProjetoResponse.success(Projeto projeto) {
    return ProjetoResponse(
      success: true,
      projeto: projeto,
      message: 'Operação realizada com sucesso',
    );
  }

  factory ProjetoResponse.successList(List<Projeto> projetos) {
    return ProjetoResponse(
      success: true,
      projetos: projetos,
      message: 'Lista de projetos carregada com sucesso',
    );
  }
}

// Response para projeto sem motorredutor
class ProjetoSemMotorredutorResponse {
  final double capacidadeReal;
  final double velocidadeElevadorDesejada;
  final double potenciaNecessaria;
  final double potenciaEmCv;
  final double momentoMaximo;
  final Motor? motorRecomendado;
  final double comprimentoCorreia;
  final int quantidadeCanecaSuportada;

  ProjetoSemMotorredutorResponse({
    required this.capacidadeReal,
    required this.velocidadeElevadorDesejada,
    required this.potenciaNecessaria,
    required this.potenciaEmCv,
    required this.momentoMaximo,
    this.motorRecomendado,
    required this.comprimentoCorreia,
    required this.quantidadeCanecaSuportada,
  });

  factory ProjetoSemMotorredutorResponse.fromJson(Map<String, dynamic> json) {
    return ProjetoSemMotorredutorResponse(
      capacidadeReal: (json['capacidadeReal'] as num).toDouble(),
      velocidadeElevadorDesejada: (json['velocidadeElevadorDesejada'] as num).toDouble(),
      potenciaNecessaria: (json['potenciaNecessaria'] as num).toDouble(),
      potenciaEmCv: (json['potenciaEmCv'] as num).toDouble(),
      momentoMaximo: (json['momentoMaximo'] as num).toDouble(),
      motorRecomendado: json['motorRecomendado'] != null
          ? Motor.fromJson(json['motorRecomendado'] as Map<String, dynamic>)
          : null,
      comprimentoCorreia: (json['comprimentoCorreia'] as num).toDouble(),
      quantidadeCanecaSuportada: json['quantidadeCanecaSuportada'] as int,
    );
  }
}

// Response para projeto com motorredutor
class ProjetoComMotorredutorResponse {
  final double rotacaoExistente;
  final double velocidadeExistente;
  final double capacidadeReal;
  final double potenciaNecessaria;
  final double momentoMaximo;
  final Motor? motorRecomendado;

  ProjetoComMotorredutorResponse({
    required this.rotacaoExistente,
    required this.velocidadeExistente,
    required this.capacidadeReal,
    required this.potenciaNecessaria,
    required this.momentoMaximo,
    this.motorRecomendado,
  });

  factory ProjetoComMotorredutorResponse.fromJson(Map<String, dynamic> json) {
    return ProjetoComMotorredutorResponse(
      rotacaoExistente: (json['rotacaoExistente'] as num).toDouble(),
      velocidadeExistente: (json['velocidadeExistente'] as num).toDouble(),
      capacidadeReal: (json['capacidadeReal'] as num).toDouble(),
      potenciaNecessaria: (json['potenciaNecessaria'] as num).toDouble(),
      momentoMaximo: (json['momentoMaximo'] as num).toDouble(),
      motorRecomendado: json['motorRecomendado'] != null
          ? Motor.fromJson(json['motorRecomendado'] as Map<String, dynamic>)
          : null,
    );
  }
}

// Modelo de Motor
class Motor {
  final int id;
  final String modelo;
  final double potenciaNominal;
  final int torqueMaximo;
  final int rotacaoSaida;

  Motor({
    required this.id,
    required this.modelo,
    required this.potenciaNominal,
    required this.torqueMaximo,
    required this.rotacaoSaida,
  });

  factory Motor.fromJson(Map<String, dynamic> json) {
    return Motor(
      id: json['id'] as int,
      modelo: json['modelo'] as String,
      potenciaNominal: (json['potenciaNominal'] as num).toDouble(),
      torqueMaximo: json['torqueMaximo'] as int,
      rotacaoSaida: json['rotacaoSaida'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modelo': modelo,
      'potenciaNominal': potenciaNominal,
      'torqueMaximo': torqueMaximo,
      'rotacaoSaida': rotacaoSaida,
    };
  }
}

class Projeto {
  final int? idProjeto;
  final int? id;
  final String nomeProjeto;
  final String? cnpjCliente;
  final String? cpfFuncionario;
  final double? potenciaMotor;
  final double? rotacaoMotor;
  final String? possuiMotorRedutor;
  final String? possuiMotorredutor;
  
  // Campos específicos para projeto sem motorredutor
  final int? numeroFileiras;
  final int? fileiras;
  final double? diametroTambor;
  final double? diametro;
  final double? alturaElevador;
  final double? altura;
  final double? densidade;
  final double? rendimento;
  final double? fatorDeServico;
  final double? velocidadeElevador;
  final double? velocidade;
  final double? passoCorreia;
  final double? passo;
  final double? canecaMetro;
  final double? enchimento;
  final double? momentoMaximo;
  final String? modeloCorreia;
  final String? fixacaoAdequada;
  final int? quantidadeCanecaSuportada;
  final double? comprimentoCorreia;
  final double? potenciaEmCv;
  final double? torque;
  final int? volumeCaneca;
  
  // Campos específicos para projeto com motorredutor
  final double? reducao;
  final double? rotacaoExistente;
  final double? velocidadeExistente;
  final double? capacidadeReal;
  final double? potenciaNecessaria;
  final double? momento;
  final double? tracaoNecessaria;
  final double? tracaoSelecionada;
  final double? relacaoTracao;
  
  final Motor? motorRecomendado;

  Projeto({
    this.idProjeto,
    this.id,
    required this.nomeProjeto,
    this.cnpjCliente,
    this.cpfFuncionario,
    this.potenciaMotor,
    this.rotacaoMotor,
    this.possuiMotorRedutor,
    this.possuiMotorredutor,
    this.numeroFileiras,
    this.fileiras,
    this.diametroTambor,
    this.diametro,
    this.alturaElevador,
    this.altura,
    this.densidade,
    this.rendimento,
    this.fatorDeServico,
    this.velocidadeElevador,
    this.velocidade,
    this.passoCorreia,
    this.passo,
    this.canecaMetro,
    this.enchimento,
    this.momentoMaximo,
    this.modeloCorreia,
    this.fixacaoAdequada,
    this.quantidadeCanecaSuportada,
    this.comprimentoCorreia,
    this.potenciaEmCv,
    this.torque,
    this.volumeCaneca,
    this.reducao,
    this.rotacaoExistente,
    this.velocidadeExistente,
    this.capacidadeReal,
    this.potenciaNecessaria,
    this.momento,
    this.tracaoNecessaria,
    this.tracaoSelecionada,
    this.relacaoTracao,
    this.motorRecomendado,
  });

  int get idValue => idProjeto ?? id ?? 0;
  String get possuiMotorredutorValue => possuiMotorRedutor ?? possuiMotorredutor ?? 'NAO_POSSUI_MOTORREDUTOR';
  String? get cpf_funcionario => cpfFuncionario;

  factory Projeto.fromJson(Map<String, dynamic> json) {
    return Projeto(
      idProjeto: json['idProjeto'] as int?,
      id: json['id'] as int?,
      nomeProjeto: json['nomeProjeto'] as String,
      cnpjCliente: json['cnpjCliente'] as String?,
      cpfFuncionario: json['cpfFuncionario'] as String? ?? json['cpf_funcionario'] as String?,
      potenciaMotor: json['potenciaMotor'] != null ? (json['potenciaMotor'] as num).toDouble() : null,
      rotacaoMotor: json['rotacaoMotor'] != null ? (json['rotacaoMotor'] as num).toDouble() : null,
      possuiMotorRedutor: json['possuiMotorRedutor'] as String?,
      possuiMotorredutor: json['possuiMotorredutor'] as String?,
      numeroFileiras: json['numeroFileiras'] as int?,
      fileiras: json['fileiras'] as int? ?? json['numeroFileiras'] as int?,
      diametroTambor: json['diametroTambor'] != null ? (json['diametroTambor'] as num).toDouble() : null,
      diametro: json['diametro'] != null ? (json['diametro'] as num).toDouble() : null,
      alturaElevador: json['alturaElevador'] != null ? (json['alturaElevador'] as num).toDouble() : null,
      altura: json['altura'] != null ? (json['altura'] as num).toDouble() : null,
      densidade: json['densidade'] != null ? (json['densidade'] as num).toDouble() : null,
      rendimento: json['rendimento'] != null ? (json['rendimento'] as num).toDouble() : null,
      fatorDeServico: json['fatorDeServico'] != null ? (json['fatorDeServico'] as num).toDouble() : null,
      velocidadeElevador: json['velocidadeElevador'] != null ? (json['velocidadeElevador'] as num).toDouble() : null,
      velocidade: json['velocidade'] != null ? (json['velocidade'] as num).toDouble() : null,
      passoCorreia: json['passoCorreia'] != null ? (json['passoCorreia'] as num).toDouble() : null,
      passo: json['passo'] != null ? (json['passo'] as num).toDouble() : null,
      canecaMetro: json['canecaMetro'] != null ? (json['canecaMetro'] as num).toDouble() : null,
      enchimento: json['enchimento'] != null ? (json['enchimento'] as num).toDouble() : null,
      momentoMaximo: json['momentoMaximo'] != null ? (json['momentoMaximo'] as num).toDouble() : null,
      modeloCorreia: json['modeloCorreia'] as String?,
      fixacaoAdequada: json['fixacaoAdequada'] as String?,
      quantidadeCanecaSuportada: json['quantidadeCanecaSuportada'] as int?,
      comprimentoCorreia: json['comprimentoCorreia'] != null ? (json['comprimentoCorreia'] as num).toDouble() : null,
      potenciaEmCv: json['potenciaEmCv'] != null ? (json['potenciaEmCv'] as num).toDouble() : null,
      torque: json['torque'] != null ? (json['torque'] as num).toDouble() : null,
      volumeCaneca: json['volumeCaneca'] as int?,
      reducao: json['reducao'] != null ? (json['reducao'] as num).toDouble() : null,
      rotacaoExistente: json['rotacaoExistente'] != null ? (json['rotacaoExistente'] as num).toDouble() : null,
      velocidadeExistente: json['velocidadeExistente'] != null ? (json['velocidadeExistente'] as num).toDouble() : null,
      capacidadeReal: json['capacidadeReal'] != null ? (json['capacidadeReal'] as num).toDouble() : null,
      potenciaNecessaria: json['potenciaNecessaria'] != null ? (json['potenciaNecessaria'] as num).toDouble() : null,
      momento: json['momento'] != null ? (json['momento'] as num).toDouble() : null,
      tracaoNecessaria: json['tracaoNecessaria'] != null ? (json['tracaoNecessaria'] as num).toDouble() : null,
      tracaoSelecionada: json['tracaoSelecionada'] != null ? (json['tracaoSelecionada'] as num).toDouble() : null,
      relacaoTracao: json['relacaoTracao'] != null ? (json['relacaoTracao'] as num).toDouble() : null,
      motorRecomendado: json['motorRecomendado'] != null
          ? Motor.fromJson(json['motorRecomendado'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      if (idProjeto != null) 'idProjeto': idProjeto,
      if (id != null) 'id': id,
      'nomeProjeto': nomeProjeto,
      if (cnpjCliente != null) 'cnpjCliente': cnpjCliente,
      if (cpfFuncionario != null) 'cpfFuncionario': cpfFuncionario,
      if (potenciaMotor != null) 'potenciaMotor': potenciaMotor,
      if (rotacaoMotor != null) 'rotacaoMotor': rotacaoMotor,
      if (possuiMotorredutorValue.isNotEmpty) 'possuiMotorredutor': possuiMotorredutorValue,
    };

    // Adicionar todos os outros campos opcionais
    if (numeroFileiras != null) json['numeroFileiras'] = numeroFileiras;
    if (diametroTambor != null) json['diametroTambor'] = diametroTambor;
    if (alturaElevador != null) json['alturaElevador'] = alturaElevador;
    if (densidade != null) json['densidade'] = densidade;
    if (rendimento != null) json['rendimento'] = rendimento;
    if (fatorDeServico != null) json['fatorDeServico'] = fatorDeServico;
    if (velocidadeElevador != null) json['velocidadeElevador'] = velocidadeElevador;
    if (passoCorreia != null) json['passoCorreia'] = passoCorreia;
    if (canecaMetro != null) json['canecaMetro'] = canecaMetro;
    if (enchimento != null) json['enchimento'] = enchimento;
    if (momentoMaximo != null) json['momentoMaximo'] = momentoMaximo;
    if (modeloCorreia != null) json['modeloCorreia'] = modeloCorreia;
    if (fixacaoAdequada != null) json['fixacaoAdequada'] = fixacaoAdequada;
    if (quantidadeCanecaSuportada != null) json['quantidadeCanecaSuportada'] = quantidadeCanecaSuportada;
    if (comprimentoCorreia != null) json['comprimentoCorreia'] = comprimentoCorreia;
    if (potenciaEmCv != null) json['potenciaEmCv'] = potenciaEmCv;
    if (torque != null) json['torque'] = torque;
    if (volumeCaneca != null) json['volumeCaneca'] = volumeCaneca;
    if (reducao != null) json['reducao'] = reducao;
    if (rotacaoExistente != null) json['rotacaoExistente'] = rotacaoExistente;
    if (velocidadeExistente != null) json['velocidadeExistente'] = velocidadeExistente;
    if (capacidadeReal != null) json['capacidadeReal'] = capacidadeReal;
    if (potenciaNecessaria != null) json['potenciaNecessaria'] = potenciaNecessaria;
    if (momento != null) json['momento'] = momento;
    if (tracaoNecessaria != null) json['tracaoNecessaria'] = tracaoNecessaria;
    if (tracaoSelecionada != null) json['tracaoSelecionada'] = tracaoSelecionada;
    if (relacaoTracao != null) json['relacaoTracao'] = relacaoTracao;
    if (motorRecomendado != null) json['motorRecomendado'] = motorRecomendado!.toJson();

    return json;
  }
}

