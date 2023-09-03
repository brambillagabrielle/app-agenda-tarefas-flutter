import 'package:flutter/material.dart';
import '../../models/evento.dart';
import '../../components/editor.dart';
import '../../database/agenda_dao.dart';
import 'package:intl/intl.dart';

class FormEvento extends StatefulWidget {
  final Evento? evento;
  FormEvento({this.evento});

  @override
  State<StatefulWidget> createState() {
    return FormEventoState();
  }
}

class FormEventoState extends State<FormEvento> {
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorDescricao = TextEditingController();
  final TextEditingController _controladorData = TextEditingController();
  final TextEditingController _controladorHorario = TextEditingController();
  int? _id;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form de Eventos"),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Editor(_controladorNome, "Nome", "Informe o Nome",
                      Icons.assignment),
                  Editor(_controladorDescricao, "Descrição",
                      "Informe a Descrição", Icons.assignment),
                  TextFormField(
                    controller: _controladorData,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: "Informe uma data"),
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe uma data!';
                      }
                      return null;
                    },
                    onTap: () async {
                      DateTime? dataEscolhida = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year),
                          lastDate: DateTime(2101));

                      if (dataEscolhida == null) {
                        dataEscolhida = DateTime.now();
                      }

                      String dataFormatada =
                          DateFormat('dd-MM-yyyy').format(dataEscolhida);

                      setState(() {
                        _controladorData.text = dataFormatada;
                      });
                    },
                  ),
                  TextFormField(
                    controller: _controladorHorario,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.more_time),
                        labelText: "Informe um horário"),
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe um horário!';
                      }
                      return null;
                    },
                    onTap: () async {
                      TimeOfDay? horarioEscolhido = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());

                      if (horarioEscolhido == null) {
                        horarioEscolhido = TimeOfDay.now();
                      }

                      setState(() {
                        _controladorHorario.text =
                            "${horarioEscolhido?.hour}:${horarioEscolhido?.minute}";
                      });
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          criarEvento(context);
                        }
                      },
                      child: Text("Salvar"))
                ],
              ))),
    );
  }

  void criarEvento(BuildContext context) {
    AgendaDao dao = AgendaDao();
    if (_id != null) {
      final evento = Evento(
          _id!,
          _controladorNome.text,
          _controladorDescricao.text,
          _controladorData.text,
          _controladorHorario.text);
      dao.update(evento).then((id) => Navigator.pop(context));
    } else {
      final evento = Evento(
          0,
          _controladorNome.text,
          _controladorDescricao.text,
          _controladorData.text,
          _controladorHorario.text);
      dao.save(evento).then((id) {
        print("Evento adicionado: " + id.toString());
        Navigator.pop(context);
      });
    }
    SnackBar snackBar = SnackBar(content: Text("Evento atualizado!"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    if (widget.evento != null) {
      _id = widget.evento!.id;
      _controladorNome.text = widget.evento!.nome;
      _controladorDescricao.text = widget.evento!.descricao;
      _controladorData.text = widget.evento!.data;
      _controladorHorario.text = widget.evento!.horario;
    }
  }
}
