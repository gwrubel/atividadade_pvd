import 'package:uuid/uuid.dart';

class Produto {
  final String id;
  final String nome;
  final double preco;
  final String descricao;
  final String urlImagem;

  Produto({
    String? id,
    required this.nome,
    required this.preco,
    required this.descricao,
    required this.urlImagem,
  }) : id = id ?? const Uuid().v4();
}
