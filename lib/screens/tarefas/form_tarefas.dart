import 'package:flutter/material.dart';
import '../../models/tarefa.dart';
import '../../components/editor.dart';
import '../../database/tarefa_dao.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:color_parser/color_parser.dart';

class FormTarefa extends StatefulWidget {
  final Tarefa? tarefa;
  FormTarefa({this.tarefa});

  @override
  State<StatefulWidget> createState() {
    return FormTarefaState();
  }
}

class FormTarefaState extends State<FormTarefa> {
  final TextEditingController _controladorTarefa = TextEditingController();
  final TextEditingController _controladorObs = TextEditingController();
  final TextEditingController _controladorCor = TextEditingController();
  int? _id;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Formulário de Tarefas"),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Editor(_controladorTarefa, "Tarefa", "Informe a Tarefa",
                      Icons.assignment),
                  Editor(_controladorObs, "Observação", "Informe a Observação",
                      Icons.assignment),
                  TextFormField(
                    controller: _controladorCor,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.color_lens_rounded),
                        labelText: "Selecione uma cor"),
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe uma cor!';
                      }
                      return null;
                    },
                    onTap: () async {
                      ColorParser parser;
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Selecione uma cor'),
                              content: SingleChildScrollView(
                                child: MaterialPicker(
                                  pickerColor: Colors.white,
                                  onColorChanged: (Color corSelecionada) {
                                    setState(() {
                                      parser =
                                          ColorParser.color(corSelecionada);
                                      _controladorCor.text = parser.toHex();
                                    });
                                  },
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('Selecionar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          criarTarefa(context);
                        }
                      },
                      child: Text("Salvar"))
                ],
              ))),
    );
  }

  void criarTarefa(BuildContext context) {
    TarefaDao dao = TarefaDao();
    if (_id != null) {
      final tarefa = Tarefa(_id!, _controladorTarefa.text, _controladorObs.text,
          _controladorCor.text);
      dao.update(tarefa).then((id) => Navigator.pop(context));
    } else {
      final tarefa = Tarefa(0, _controladorTarefa.text, _controladorObs.text,
          _controladorCor.text);
      dao.save(tarefa).then((id) {
        print("Tarefa incluída: " + id.toString());
        Navigator.pop(context);
      });
    }
    SnackBar snackBar = SnackBar(content: Text("Tarefa atualizada!"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    if (widget.tarefa != null) {
      _id = widget.tarefa!.id;
      _controladorTarefa.text = widget.tarefa!.descricao;
      _controladorObs.text = widget.tarefa!.observacao;
      _controladorCor.text = widget.tarefa!.cor;
    }
  }
}
