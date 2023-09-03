class Evento {
  int id;
  String nome;
  String descricao;
  String data;
  String horario;

  Evento(this.id, this.nome, this.descricao, this.data, this.horario);

  @override
  String toString() {
    return 'Tarefa(nome: $nome, descricao: $descricao, data: $data, horario: $horario)';
  }
}
