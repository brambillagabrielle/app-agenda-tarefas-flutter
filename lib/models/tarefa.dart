class Tarefa {
  int id;
  String descricao;
  String observacao;
  String cor;
  Tarefa(this.id, this.descricao, this.observacao, this.cor);

  @override
  String toString() {
    return 'Tarefa(descricao: $descricao, obs: $observacao, cor: $cor)';
  }
}
