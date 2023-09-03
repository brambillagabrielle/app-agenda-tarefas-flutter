import 'package:flutter/material.dart';

class Editor extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String hint;
  final IconData? icone;
  const Editor(this.controlador, this.rotulo, this.hint, [this.icone]);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      decoration: InputDecoration(
        icon: icone != null ? Icon(icone) : null,
        labelText: rotulo,
        hintText: hint,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um(a) $rotulo!';
        }
        return null;
      },
    );
  }
}
