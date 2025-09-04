import 'package:flutter/foundation.dart';
import '../modelos/produto.dart';
import '../modelos/item_carrinho.dart';

class GerenciadorCarrinho with ChangeNotifier {
  final Map<String, ItemCarrinho> _itens = {};

  Map<String, ItemCarrinho> get itens => Map.unmodifiable(_itens);

  int get quantidadeDeItens => _itens.length;

  double get valorTotal {
    double total = 0.0;
    for (var item in _itens.values) {
      total += item.produto.preco * item.quantidade;
    }
    return total;
  }

  void adicionarItem(Produto produto) {
    if (_itens.containsKey(produto.id)) {
      _itens[produto.id]!.quantidade++;
    } else {
      _itens[produto.id] = ItemCarrinho(produto: produto);
    }
    notifyListeners();
  }

  void limpar() {
    _itens.clear();
    notifyListeners();
  }
}
