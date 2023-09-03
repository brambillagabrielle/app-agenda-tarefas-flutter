import 'package:sqflite/sqflite.dart';
import '../models/evento.dart';
import 'app_database.dart';

class AgendaDao {
  static const String _tableName = "agenda";
  static const String _id = "id";
  static const String _nome = "nome";
  static const String _descricao = "descricao";
  static const String _data = "data";
  static const String _horario = "horario";

  static const String tableAgenda = 'CREATE TABLE agenda ( '
      ' id INTEGER PRIMARY KEY, '
      ' nome TEXT, '
      ' descricao TEXT, '
      ' data TEXT, '
      ' horario TEXT)';

  Map<String, dynamic> toMap(Evento evento) {
    final Map<String, dynamic> eventoMap = Map();
    eventoMap[_nome] = evento.nome;
    eventoMap[_descricao] = evento.descricao;
    eventoMap[_data] = evento.data;
    eventoMap[_horario] = evento.horario;
    return eventoMap;
  }

  Future<int> save(Evento evento) async {
    final Database db = await getDatabase();
    Map<String, dynamic> eventoMap = toMap(evento);
    return db.insert(_tableName, eventoMap);
  }

  Future<int> update(Evento evento) async {
    final Database db = await getDatabase();
    Map<String, dynamic> eventoMap = toMap(evento);
    return db
        .update(_tableName, eventoMap, where: 'id = ?', whereArgs: [evento.id]);
  }

  Future<int> delete(int id) async {
    final Database db = await getDatabase();
    return db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  List<Evento> toList(List<Map<String, dynamic>> result) {
    final List<Evento> eventos = [];
    for (Map<String, dynamic> row in result) {
      final Evento evento = Evento(
          row[_id], row[_nome], row[_descricao], row[_data], row[_horario]);
      eventos.add(evento);
    }
    return eventos;
  }

  Future<List<Evento>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Evento> eventos = toList(result);
    return eventos;
  }
}
