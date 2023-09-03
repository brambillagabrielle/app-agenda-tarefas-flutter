import 'tarefa_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'agenda_dao.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'dbtarefas.db');
  return openDatabase(path, onCreate: (db, version) {
    db.execute(TarefaDao.tableTarefa);
  }, onUpgrade: (db, oldVersion, newVersion) async {
    var batch = db.batch();
    print("Versão antiga: " + oldVersion.toString());
    print("Versão nova: " + newVersion.toString());
    if (newVersion == 2) {
      batch.execute(AgendaDao.tableAgenda);
      print("Criando nova tabela Agenda....");
    } else if (newVersion == 3) {
      batch.execute(TarefaDao.addCol);
      print("Adicionando nova coluna em Tarefa....");
    }
    await batch.commit();
  }, onDowngrade: onDatabaseDowngradeDelete, version: 3);
}
