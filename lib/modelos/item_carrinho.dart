import 'package:uuid/uuid.dart';
import 'produto.dart';

/// Modelo de dados para itens do carrinho de compras
class ItemCarrinho {
  final String id;
  final Produto produto;
  int quantidade;
  final DateTime dataAdicao;

  ItemCarrinho({
    String? id,
    required this.produto,
    this.quantidade = 1,
    DateTime? dataAdicao,
  }) : id = id ?? const Uuid().v4(),
       dataAdicao = dataAdicao ?? DateTime.now();

  /// Cria uma cópia do item com campos atualizados
  ItemCarrinho copyWith({Produto? produto, int? quantidade}) {
    return ItemCarrinho(
      id: id,
      produto: produto ?? this.produto,
      quantidade: quantidade ?? this.quantidade,
      dataAdicao: dataAdicao,
    );
  }

  /// Incrementa a quantidade do item
  ItemCarrinho incrementar() {
    return copyWith(quantidade: quantidade + 1);
  }

  /// Decrementa a quantidade do item
  ItemCarrinho decrementar() {
    final novaQuantidade = (quantidade - 1).clamp(0, double.infinity).toInt();
    return copyWith(quantidade: novaQuantidade);
  }

  /// Calcula o subtotal do item
  double get subtotal => produto.preco * quantidade;

  /// Formata o subtotal para exibição
  String get subtotalFormatado {
    return 'R\$ ${subtotal.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Verifica se o item é válido
  bool get isValid => quantidade > 0 && produto.isValid;

  /// Verifica se o item pode ser incrementado
  bool get podeIncrementar => quantidade < 999;

  /// Verifica se o item pode ser decrementado
  bool get podeDecrementar => quantidade > 1;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ItemCarrinho && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ItemCarrinho{id: $id, produto: ${produto.nome}, quantidade: $quantidade}';
  }

  /// Converte para Map para serialização
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'produto': produto.toMap(),
      'quantidade': quantidade,
      'dataAdicao': dataAdicao.toIso8601String(),
    };
  }

  /// Cria item a partir de Map
  factory ItemCarrinho.fromMap(Map<String, dynamic> map) {
    return ItemCarrinho(
      id: map['id'] as String,
      produto: Produto.fromMap(map['produto'] as Map<String, dynamic>),
      quantidade: map['quantidade'] as int,
      dataAdicao: DateTime.parse(map['dataAdicao'] as String),
    );
  }
}
