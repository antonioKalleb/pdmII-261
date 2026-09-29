import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final url = Uri.parse('http://localhost:8080/api/alunos');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List alunos = jsonResponse['dados'];

      print('ID NOME DISCIPLINA MEDIA FALTAS MENSAGEM');
      print('-' * 60);

      for (var aluno in alunos) {
        int id = aluno['id'];
        String nome = aluno['nome'];
        String disciplina = aluno['disciplina'];
        double media = (aluno['media'] as num).toDouble();
        int faltas = aluno['faltas'];

        String mensagem = '';

        if (faltas > 20) {
          mensagem = 'Reprovado por Faltas';
        } else if (media < 6.0) {
          mensagem = 'Reprovado';
        } else {
          mensagem = 'Aprovado';
        }

        print('$id $nome $disciplina $media $faltas $mensagem');
      }
    } else {
      print('Erro ao consultar a API: Status ${response.statusCode}');
    }
  } catch (e) {
    print('Erro de conexão: Certifique-se de que o servidor está a rodar!');
  }
}