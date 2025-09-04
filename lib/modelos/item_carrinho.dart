import 'package:uuid/uuid.dart';
import 'produto.dart';

class ItemCarrinho {
  final String id;
  final Produto produto;
  int quantidade;

  ItemCarrinho({
    String? id,
    required this.produto,
    this.quantidade = 1,
  }) : id = id ?? const Uuid().v4();
}
