import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;

  String dbPath = p.join(Directory.current.path, 'alunos.db');
  Database? db;

  try {
    print('--------------------------------------------------');
    print('Iniciando conexao com o banco de dados...');
    
    db = await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          try {
            print('Criando a tabela "tb_alunos"...');
            await db.execute('''
              CREATE TABLE tb_alunos (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                nome TEXT NOT NULL,
                idade INTEGER NOT NULL
              )
            ''');
            print('Tabela "tb_alunos" criada com sucesso!');
          } catch (e) {
            print('Erro ao criar a tabela: $e');
            rethrow;
          }
        },
      ),
    );

    await inserirAlunos(db);
    await listarAlunos(db);

  } catch (e) {
    print('\n[EXCEÇÃO CAPTURADA NO FLUXO PRINCIPAL]: $e');
  } finally {
    if (db != null && db.isOpen) {
      try {
        await db.close();
        print('\nConexao com o banco de dados encerrada com sucesso.');
      } catch (e) {
        print('Erro ao fechar o banco de dados: $e');
      }
    }
    print('--------------------------------------------------');
  }
}

Future<void> inserirAlunos(Database db) async {
  try {
    print('\nInserindo 3 alunos na tabela...');

    List<Map<String, dynamic>> registros = await db.query('tb_alunos');
    if (registros.isNotEmpty) {
      print('A tabela ja possui registros. Pulando insercao...');
      return;
    }

    List<Map<String, dynamic>> novosAlunos = [
      {'nome': 'Ana Silva', 'idade': 20},
      {'nome': 'Carlos Eduardo', 'idade': 22},
      {'nome': 'Beatriz Souza', 'idade': 19},
    ];

    for (var aluno in novosAlunos) {
      int id = await db.insert('tb_alunos', aluno);
      print('Aluno inserido com ID: $id (${aluno['nome']})');
    }
  } catch (e) {
    print('Erro ao inserir alunos: $e');
    rethrow;
  }
}

Future<void> listarAlunos(Database db) async {
  try {
    print('\nListando conteudo da tabela "tb_alunos":');
    List<Map<String, dynamic>> alunos = await db.query('tb_alunos');

    if (alunos.isEmpty) {
      print('Nenhum aluno encontrado.');
      return;
    }

    print('--------------------------------------------------');
    print('ID  | NOME                           | IDADE');
    print('--------------------------------------------------');
    for (var aluno in alunos) {
      print(
        '${aluno['id'].toString().padRight(3)} | '
        '${aluno['nome'].toString().padRight(30)} | '
        '${aluno['idade']}',
      );
    }
    print('--------------------------------------------------');
  } catch (e) {
    print('Erro ao listar alunos: $e');
    rethrow;
  }
}