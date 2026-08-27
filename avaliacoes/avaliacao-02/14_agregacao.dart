// 14-agregacao.dart
// Agregação e Composição

import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': _nome,
    };
  }
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': _nome,
      'dependentes': _dependentes.map((d) => d.toJson()).toList(),
    };
  }
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }

  Map<String, dynamic> toJson() {
    return {
      'nomeProjeto': _nomeProjeto,
      'funcionarios': _funcionarios.map((f) => f.toJson()).toList(),
    };
  }
}

void main() {
  // 1. Criar vários objetos Dependentes
  Dependente dep1 = Dependente('Lucas');
  Dependente dep2 = Dependente('Mariana');
  Dependente dep3 = Dependente('Enzo');

  // 2. Criar vários objetos Funcionário & 
  // 3. Associar os Dependentes aos funcionários
  Funcionario func1 = Funcionario('Carlos Silva', [dep1, dep2]);
  Funcionario func2 = Funcionario('Ana Souza', [dep3]);
  Funcionario func3 = Funcionario('Roberto Lima', []);

  // 4. Criar uma lista de Funcionários
  List<Funcionario> listaFuncionarios = [func1, func2, func3];

  // 5. Criar objeto EquipeProjeto
  EquipeProjeto equipe = EquipeProjeto('Sistemas de IA', listaFuncionarios);

  // 6. Printar no formato JSON
  String jsonEquipe = JsonEncoder.withIndent('  ').convert(equipe.toJson());
  print(jsonEquipe);
}
