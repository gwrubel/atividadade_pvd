import 'package:flutter/foundation.dart';
import '../modelos/produto.dart';
import '../modelos/item_carrinho.dart';

/// Gerenciador de estado para carrinho de compras do sistema PDV
class GerenciadorCarrinho with ChangeNotifier {
  final Map<String, ItemCarrinho> _itens = {};

  GerenciadorCarrinho();

  /// Lista de itens do carrinho (somente leitura)
  Map<String, ItemCarrinho> get itens => Map.unmodifiable(_itens);

  /// Lista de itens como lista (para facilitar iteração)
  List<ItemCarrinho> get itensLista => _itens.values.toList();

  /// Número total de itens únicos no carrinho
  int get quantidadeDeItens => _itens.length;

  /// Quantidade total de produtos (soma das quantidades)
  int get quantidadeTotalProdutos {
    return _itens.values.fold(0, (total, item) => total + item.quantidade);
  }

  /// Valor total do carrinho
  double get valorTotal {
    return _itens.values.fold(0.0, (total, item) => total + item.subtotal);
  }

  /// Valor total formatado para exibição
  String get valorTotalFormatado {
    return 'R\$ ${valorTotal.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Verifica se o carrinho está vazio
  bool get isEmpty => _itens.isEmpty;

  /// Verifica se o carrinho tem itens
  bool get isNotEmpty => _itens.isNotEmpty;

  /// Adiciona um item ao carrinho
  Future<bool> adicionarItem(Produto produto, {int quantidade = 1}) async {
    try {
      if (!produto.isValid) {
        throw Exception('Produto inválido');
      }

      if (quantidade <= 0) {
        throw Exception('Quantidade deve ser maior que zero');
      }

      if (_itens.containsKey(produto.id)) {
        final itemExistente = _itens[produto.id]!;
        final novaQuantidade = itemExistente.quantidade + quantidade;

        if (novaQuantidade > 999) {
          throw Exception('Quantidade máxima permitida é 999');
        }

        _itens[produto.id] = itemExistente.copyWith(quantidade: novaQuantidade);
      } else {
        _itens[produto.id] = ItemCarrinho(
          produto: produto,
          quantidade: quantidade,
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erro ao adicionar item ao carrinho: $e');
      rethrow;
    }
  }

  /// Remove um item do carrinho
  Future<bool> removerItem(String produtoId) async {
    try {
      if (!_itens.containsKey(produtoId)) {
        throw Exception('Item não encontrado no carrinho');
      }

      _itens.remove(produtoId);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erro ao remover item do carrinho: $e');
      rethrow;
    }
  }

  /// Atualiza a quantidade de um item
  Future<bool> atualizarQuantidade(String produtoId, int novaQuantidade) async {
    try {
      if (!_itens.containsKey(produtoId)) {
        throw Exception('Item não encontrado no carrinho');
      }

      if (novaQuantidade <= 0) {
        return await removerItem(produtoId);
      }

      if (novaQuantidade > 999) {
        throw Exception('Quantidade máxima permitida é 999');
      }

      final item = _itens[produtoId]!;
      _itens[produtoId] = item.copyWith(quantidade: novaQuantidade);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erro ao atualizar quantidade: $e');
      rethrow;
    }
  }

  /// Incrementa a quantidade de um item
  Future<bool> incrementarQuantidade(String produtoId) async {
    try {
      if (!_itens.containsKey(produtoId)) {
        throw Exception('Item não encontrado no carrinho');
      }

      final item = _itens[produtoId]!;
      if (!item.podeIncrementar) {
        throw Exception('Quantidade máxima permitida é 999');
      }

      _itens[produtoId] = item.incrementar();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erro ao incrementar quantidade: $e');
      rethrow;
    }
  }

  /// Decrementa a quantidade de um item
  Future<bool> decrementarQuantidade(String produtoId) async {
    try {
      if (!_itens.containsKey(produtoId)) {
        throw Exception('Item não encontrado no carrinho');
      }

      final item = _itens[produtoId]!;
      if (item.quantidade <= 1) {
        return await removerItem(produtoId);
      }

      _itens[produtoId] = item.decrementar();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erro ao decrementar quantidade: $e');
      rethrow;
    }
  }

  /// Busca um item no carrinho por ID do produto
  ItemCarrinho? buscarItem(String produtoId) {
    return _itens[produtoId];
  }

  /// Verifica se um produto está no carrinho
  bool contemProduto(String produtoId) {
    return _itens.containsKey(produtoId);
  }

  /// Obtém a quantidade de um produto no carrinho
  int quantidadeDoProduto(String produtoId) {
    return _itens[produtoId]?.quantidade ?? 0;
  }

  /// Limpa todos os itens do carrinho
  void limpar() {
    _itens.clear();
    notifyListeners();
  }

  /// Limpa itens inválidos do carrinho
  void limparItensInvalidos() {
    final itensInvalidos = _itens.entries
        .where((entry) => !entry.value.isValid)
        .map((entry) => entry.key)
        .toList();

    for (final id in itensInvalidos) {
      _itens.remove(id);
    }

    if (itensInvalidos.isNotEmpty) {
      notifyListeners();
    }
  }

  /// Ordena itens por nome do produto
  void ordenarPorNome({bool crescente = true}) {
    final itensOrdenados = _itens.values.toList();
    itensOrdenados.sort((a, b) {
      final comparacao = a.produto.nome.toLowerCase().compareTo(
        b.produto.nome.toLowerCase(),
      );
      return crescente ? comparacao : -comparacao;
    });

    _itens.clear();
    for (final item in itensOrdenados) {
      _itens[item.produto.id] = item;
    }
    notifyListeners();
  }

  /// Ordena itens por preço do produto
  void ordenarPorPreco({bool crescente = true}) {
    final itensOrdenados = _itens.values.toList();
    itensOrdenados.sort((a, b) {
      final comparacao = a.produto.preco.compareTo(b.produto.preco);
      return crescente ? comparacao : -comparacao;
    });

    _itens.clear();
    for (final item in itensOrdenados) {
      _itens[item.produto.id] = item;
    }
    notifyListeners();
  }

  /// Ordena itens por data de adição
  void ordenarPorDataAdicao({bool crescente = true}) {
    final itensOrdenados = _itens.values.toList();
    itensOrdenados.sort((a, b) {
      final comparacao = a.dataAdicao.compareTo(b.dataAdicao);
      return crescente ? comparacao : -comparacao;
    });

    _itens.clear();
    for (final item in itensOrdenados) {
      _itens[item.produto.id] = item;
    }
    notifyListeners();
  }

  /// Converte carrinho para Map para serialização
  Map<String, dynamic> toMap() {
    return {
      'itens': _itens.map((key, value) => MapEntry(key, value.toMap())),
      'valorTotal': valorTotal,
      'quantidadeItens': quantidadeDeItens,
    };
  }

  /// Cria carrinho a partir de Map
  factory GerenciadorCarrinho.fromMap(Map<String, dynamic> map) {
    final gerenciador = GerenciadorCarrinho();
    final itensMap = map['itens'] as Map<String, dynamic>;

    for (final entry in itensMap.entries) {
      final item = ItemCarrinho.fromMap(entry.value as Map<String, dynamic>);
      gerenciador._itens[entry.key] = item;
    }

    return gerenciador;
  }
}
