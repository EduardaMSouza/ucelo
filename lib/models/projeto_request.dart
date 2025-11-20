// Request para projeto sem motorredutor
class ProjetoSemMotorredutorRequest {
  final String nomeProjeto;
  final double alturaElevador;
  final double densidade;
  final double capacidadeDesejada;
  final double velocidadeElevador;
  final double passoCorreia;
  final int numeroFileiras;
  final double enchimento;
  final String possuiMotorRedutor;
  final double diametroTambor;
  final int volumeCaneca;
  final double rendimento;
  final double fatorDeServico;

  ProjetoSemMotorredutorRequest({
    required this.nomeProjeto,
    required this.alturaElevador,
    required this.densidade,
    required this.capacidadeDesejada,
    required this.velocidadeElevador,
    required this.passoCorreia,
    required this.numeroFileiras,
    required this.enchimento,
    required this.possuiMotorRedutor,
    required this.diametroTambor,
    required this.volumeCaneca,
    required this.rendimento,
    required this.fatorDeServico,
  });

  Map<String, dynamic> toJson() {
    return {
      'nomeProjeto': nomeProjeto,
      'alturaElevador': alturaElevador,
      'densidade': densidade,
      'capacidadeDesejada': capacidadeDesejada,
      'velocidadeElevador': velocidadeElevador,
      'passoCorreia': passoCorreia,
      'numeroFileiras': numeroFileiras,
      'enchimento': enchimento,
      'possuiMotorRedutor': possuiMotorRedutor,
      'diametroTambor': diametroTambor,
      'volumeCaneca': volumeCaneca,
      'rendimento': rendimento,
      'fatorDeServico': fatorDeServico,
    };
  }
}

// Request para projeto com motorredutor
class ProjetoComMotorredutorRequest {
  final String nomeProjeto;
  final double potenciaMotor;
  final double rotacaoMotor;
  final double diametro;
  final double reducao;
  final double rendimento;
  final double fatorDeServico;
  final String possuiMotorredutor;

  ProjetoComMotorredutorRequest({
    required this.nomeProjeto,
    required this.potenciaMotor,
    required this.rotacaoMotor,
    required this.diametro,
    required this.reducao,
    required this.rendimento,
    required this.fatorDeServico,
    required this.possuiMotorredutor,
  });

  Map<String, dynamic> toJson() {
    return {
      'nomeProjeto': nomeProjeto,
      'potenciaMotor': potenciaMotor,
      'rotacaoMotor': rotacaoMotor,
      'diametro': diametro,
      'reducao': reducao,
      'rendimento': rendimento,
      'fatorDeServico': fatorDeServico,
      'possuiMotorredutor': possuiMotorredutor,
    };
  }
}

// Classe antiga mantida para compatibilidade (será removida gradualmente)
class ProjetoRequest {
  final String nomeProjeto;
  final String? cnpjCliente;
  final String? cpf_funcionario;
  final double? potenciaMotor;
  final double? rotacaoMotor;
  final String possuiMotorredutor;
  
  // Campos específicos para projeto sem motorredutor
  final int? fileiras;
  final double? diametro;
  final double? altura;
  final double? densidade;
  final double? rendimento;
  final double? fatorDeServico;
  final double? velocidade;
  final double? passo;
  
  // Campos específicos para projeto com motorredutor
  final double? reducao;

  ProjetoRequest({
    required this.nomeProjeto,
    this.cnpjCliente,
    this.cpf_funcionario,
    this.potenciaMotor,
    this.rotacaoMotor,
    required this.possuiMotorredutor,
    this.fileiras,
    this.diametro,
    this.altura,
    this.densidade,
    this.rendimento,
    this.fatorDeServico,
    this.velocidade,
    this.passo,
    this.reducao,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'nomeProjeto': nomeProjeto,
      'possuiMotorredutor': possuiMotorredutor,
    };

    if (cnpjCliente != null) json['cnpjCliente'] = cnpjCliente;
    if (cpf_funcionario != null) json['cpf_funcionario'] = cpf_funcionario;
    if (potenciaMotor != null) json['potenciaMotor'] = potenciaMotor;
    if (rotacaoMotor != null) json['rotacaoMotor'] = rotacaoMotor;

    if (possuiMotorredutor == 'NAO_POSSUI_MOTORREDUTOR') {
      if (fileiras != null) json['fileiras'] = fileiras;
      if (diametro != null) json['diametro'] = diametro;
      if (altura != null) json['altura'] = altura;
      if (densidade != null) json['densidade'] = densidade;
      if (rendimento != null) json['rendimento'] = rendimento;
      if (fatorDeServico != null) json['fatorDeServico'] = fatorDeServico;
      if (velocidade != null) json['velocidade'] = velocidade;
      if (passo != null) json['passo'] = passo;
    } else if (possuiMotorredutor == 'POSSUI_MOTORREDUTOR') {
      if (diametro != null) json['diametro'] = diametro;
      if (rendimento != null) json['rendimento'] = rendimento;
      if (fatorDeServico != null) json['fatorDeServico'] = fatorDeServico;
      if (reducao != null) json['reducao'] = reducao;
    }

    return json;
  }

  factory ProjetoRequest.fromJson(Map<String, dynamic> json) {
    return ProjetoRequest(
      nomeProjeto: json['nomeProjeto'] as String,
      cnpjCliente: json['cnpjCliente'] as String?,
      cpf_funcionario: json['cpf_funcionario'] as String?,
      potenciaMotor: json['potenciaMotor'] != null ? (json['potenciaMotor'] as num).toDouble() : null,
      rotacaoMotor: json['rotacaoMotor'] != null ? (json['rotacaoMotor'] as num).toDouble() : null,
      possuiMotorredutor: json['possuiMotorredutor'] as String,
      fileiras: json['fileiras'] as int?,
      diametro: json['diametro'] != null ? (json['diametro'] as num).toDouble() : null,
      altura: json['altura'] != null ? (json['altura'] as num).toDouble() : null,
      densidade: json['densidade'] != null ? (json['densidade'] as num).toDouble() : null,
      rendimento: json['rendimento'] != null ? (json['rendimento'] as num).toDouble() : null,
      fatorDeServico: json['fatorDeServico'] != null ? (json['fatorDeServico'] as num).toDouble() : null,
      velocidade: json['velocidade'] != null ? (json['velocidade'] as num).toDouble() : null,
      passo: json['passo'] != null ? (json['passo'] as num).toDouble() : null,
      reducao: json['reducao'] != null ? (json['reducao'] as num).toDouble() : null,
    );
  }
}

