import 'package:sqflite/sqflite.dart';
import '../models/tarefa.dart';
import 'app_database.dart';

class TarefaDao {
  static const String _tableName = "tarefas";
  static const String _id = "id";
  static const String _descricao = "descricao";
  static const String _observacao = "observacao";
  static const String _cor = "cor";

  static const String tableTarefa = 'CREATE TABLE tarefas ( '
      ' id INTEGER PRIMARY KEY, '
      ' descricao TEXT, '
      ' observacao TEXT)';

  static const String addCol = 'ALTER TABLE tarefas ADD cor TEXT';

  Map<String, dynamic> toMap(Tarefa tarefa) {
    final Map<String, dynamic> tarefaMap = Map();
    tarefaMap[_descricao] = tarefa.descricao;
    tarefaMap[_observacao] = tarefa.observacao;
    tarefaMap[_cor] = tarefa.cor;
    return tarefaMap;
  }

  Future<int> save(Tarefa tarefa) async {
    final Database db = await getDatabase();
    Map<String, dynamic> tarefaMap = toMap(tarefa);
    return db.insert(_tableName, tarefaMap);
  }

  Future<int> update(Tarefa tarefa) async {
    final Database db = await getDatabase();
    Map<String, dynamic> tarefaMap = toMap(tarefa);
    return db
        .update(_tableName, tarefaMap, where: 'id = ?', whereArgs: [tarefa.id]);
  }

  Future<int> delete(int id) async {
    final Database db = await getDatabase();
    return db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  List<Tarefa> toList(List<Map<String, dynamic>> result) {
    final List<Tarefa> tarefas = [];
    for (Map<String, dynamic> row in result) {
      final Tarefa tarefa =
          Tarefa(row[_id], row[_descricao], row[_observacao], row[_cor]);
      tarefas.add(tarefa);
    }
    return tarefas;
  }

  Future<List<Tarefa>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Tarefa> tarefas = toList(result);
    return tarefas;
  }
}
