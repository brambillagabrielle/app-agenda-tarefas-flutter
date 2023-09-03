import 'package:flutter/material.dart';
import '../../database/tarefa_dao.dart';
import '../../models/tarefa.dart';
import 'form_tarefas.dart';
import 'package:color_parser/color_parser.dart';

class ListaTarefa extends StatefulWidget {
  List<Tarefa> tarefas = [];

  @override
  State<StatefulWidget> createState() {
    return ListaTarefaState();
  }
}

class ListaTarefaState extends State<ListaTarefa> {
  TarefaDao dao = TarefaDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista de Tarefas"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final Future future =
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FormTarefa();
            }));
            future.then((tarefa) {
              setState(() {});
            });
          },
          child: Icon(Icons.add),
        ),
        body: FutureBuilder<List<Tarefa>>(
            initialData: [],
            future: dao.findAll(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.data != null) {
                    final List<Tarefa>? tarefas = snapshot.data;
                    return ListView.builder(
                        itemCount: tarefas!.length,
                        itemBuilder: (context, indice) {
                          final tarefa = tarefas[indice];
                          return ItemTarefa(context, tarefa);
                        });
                  }
                default:
                  return Center(
                    child: Text("Carregando"),
                  );
              }
              return Center(child: Text("Nenhuma Tarefa"));
            }));
  }

  Widget ItemTarefa(BuildContext context, Tarefa _tarefa) {
    Color _backgroundColor = hexToColor(_tarefa.cor),
        _textColor = getColorText(hexToColor(_tarefa.cor));

    return GestureDetector(
        onTap: () {
          final Future future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormTarefa(tarefa: _tarefa);
          }));
          future.then((value) => setState(() {}));
        },
        child: Card(
          color: _backgroundColor,
          child: ListTile(
            textColor: _textColor,
            title: Text(_tarefa.descricao),
            subtitle: Text(_tarefa.observacao),
            leading: Icon(Icons.add_alert, color: _textColor),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => _excluir(context, _tarefa.id),
                      barrierDismissible: true,
                    );
                  },
                  child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.remove_circle, color: _textColor)),
                ),
              ],
            ),
          ),
        ));
  }

  AlertDialog _excluir(BuildContext context, int id) {
    return AlertDialog(
      title: const Text('Exclusão'),
      content: const Text('Confirma a exclusão da tarefa?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, 'Cancelar');
            },
            child: const Text('Cancelar')),
        TextButton(
            onPressed: () {
              dao.delete(id).then((value) => setState(() {}));

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('A tarefa foi excluída!'),
                backgroundColor: Colors.redAccent,
              ));
              Navigator.pop(context, 'Confirmar');
            },
            child: const Text('Confirmar'))
      ],
    );
  }

  Color hexToColor(String hexCode) {
    return Color(int.parse(hexCode.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Color getColorText(Color color) {
    return 0.299 * color.red + 0.587 * color.green + 0.114 * color.blue > 128
        ? Colors.black
        : Colors.white;
  }
}
