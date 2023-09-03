import 'package:flutter/material.dart';
import '../../database/agenda_dao.dart';
import '../../models/evento.dart';
import 'form_eventos.dart';

class ListaEvento extends StatefulWidget {
  List<Evento> eventos = [];

  @override
  State<StatefulWidget> createState() {
    return ListaEventoState();
  }
}

class ListaEventoState extends State<ListaEvento> {
  AgendaDao dao = AgendaDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Agenda"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final Future future =
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FormEvento();
            }));
            future.then((evento) {
              setState(() {});
            });
          },
          child: Icon(Icons.add),
        ),
        body: FutureBuilder<List<Evento>>(
            initialData: [],
            future: dao.findAll(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.data != null) {
                    final List<Evento>? eventos = snapshot.data;
                    return ListView.builder(
                        itemCount: eventos!.length,
                        itemBuilder: (context, indice) {
                          final evento = eventos[indice];
                          return ItemEvento(context, evento);
                        });
                  }
                default:
                  return Center(
                    child: Text("Carregando"),
                  );
              }
              return Center(child: Text("Nenhum Evento agendado"));
            }));
  }

  Widget ItemEvento(BuildContext context, Evento _evento) {
    return GestureDetector(
        onTap: () {
          final Future future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormEvento(evento: _evento);
          }));
          future.then((value) => setState(() {}));
        },
        child: Card(
          child: ListTile(
            title: Text(_evento.nome),
            subtitle: Text(_evento.data + ", " + _evento.horario),
            leading: Icon(Icons.add_alert),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => _excluir(context, _evento.id),
                      barrierDismissible: true,
                    );
                  },
                  child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.remove_circle, color: Colors.black)),
                ),
              ],
            ),
          ),
        ));
  }

  AlertDialog _excluir(BuildContext context, int id) {
    return AlertDialog(
      title: const Text('Exclusão'),
      content: const Text('Confirma a exclusão do evento?'),
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
                content: Text('O evento foi excluído!'),
                backgroundColor: Colors.redAccent,
              ));
              Navigator.pop(context, 'Confirmar');
            },
            child: const Text('Confirmar'))
      ],
    );
  }
}
