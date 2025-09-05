import 'package:flutter/foundation.dart';
import '../modelos/produto.dart';
import '../core/constants.dart';

/// Gerenciador de estado para produtos do sistema PDV
class GerenciadorProdutos with ChangeNotifier {
  final List<Produto> _produtos = [
    Produto(
      nome: AppConstants.defaultProductName,
      preco: AppConstants.defaultProductPrice,
      descricao: AppConstants.defaultProductDescription,
      urlImagem: AppConstants.defaultProductImageUrl,
    ),
  ];

  /// Lista de produtos (somente leitura)
  List<Produto> get produtos => List.unmodifiable(_produtos);

  /// Número total de produtos
  int get totalProdutos => _produtos.length;

  /// Produtos válidos (filtrados)
  List<Produto> get produtosValidos =>
      _produtos.where((p) => p.isValid).toList();

  /// Busca produto por ID
  Produto? buscarProdutoPorId(String id) {
    try {
      return _produtos.firstWhere((produto) => produto.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Busca produtos por nome (busca parcial)
  List<Produto> buscarProdutosPorNome(String nome) {
    if (nome.trim().isEmpty) return produtos;

    final nomeBusca = nome.toLowerCase().trim();
    return _produtos
        .where((produto) => produto.nome.toLowerCase().contains(nomeBusca))
        .toList();
  }

  /// Adiciona um novo produto
  Future<bool> adicionarProduto({
    required String nome,
    required double preco,
    required String descricao,
    required String urlImagem,
  }) async {
    try {
      // Validações
      if (nome.trim().isEmpty) {
        throw Exception(AppStrings.enterProductName);
      }

      if (preco < AppConstants.minPrice || preco > AppConstants.maxPrice) {
        throw Exception(AppStrings.enterValidPrice);
      }

      if (descricao.trim().isEmpty) {
        throw Exception(AppStrings.enterDescription);
      }

      // URL é opcional - não valida se vazia

      final novoProduto = Produto(
        nome: nome.trim(),
        preco: preco,
        descricao: descricao.trim(),
        urlImagem: urlImagem.trim(),
      );

      // Verifica se o produto já existe (por nome)
      final produtoExistente = _produtos.any(
        (p) => p.nome.toLowerCase() == novoProduto.nome.toLowerCase(),
      );

      if (produtoExistente) {
        throw Exception('Produto com este nome já existe');
      }

      _produtos.add(novoProduto);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erro ao adicionar produto: $e');
      rethrow;
    }
  }

  /// Atualiza um produto existente
  Future<bool> atualizarProduto({
    required String id,
    String? nome,
    double? preco,
    String? descricao,
    String? urlImagem,
  }) async {
    try {
      final index = _produtos.indexWhere((p) => p.id == id);
      if (index == -1) {
        throw Exception('Produto não encontrado');
      }

      final produtoAtual = _produtos[index];
      final produtoAtualizado = produtoAtual.copyWith(
        nome: nome?.trim(),
        preco: preco,
        descricao: descricao?.trim(),
        urlImagem: urlImagem?.trim(),
      );

      // Validações
      if (!produtoAtualizado.isValid) {
        throw Exception('Dados do produto inválidos');
      }

      _produtos[index] = produtoAtualizado;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erro ao atualizar produto: $e');
      rethrow;
    }
  }

  /// Remove um produto
  Future<bool> removerProduto(String id) async {
    try {
      final index = _produtos.indexWhere((p) => p.id == id);
      if (index == -1) {
        throw Exception('Produto não encontrado');
      }

      _produtos.removeAt(index);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erro ao remover produto: $e');
      rethrow;
    }
  }

  /// Limpa todos os produtos
  void limparProdutos() {
    _produtos.clear();
    notifyListeners();
  }

  /// Ordena produtos por nome
  void ordenarPorNome({bool crescente = true}) {
    _produtos.sort((a, b) {
      final comparacao = a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
      return crescente ? comparacao : -comparacao;
    });
    notifyListeners();
  }

  /// Ordena produtos por preço
  void ordenarPorPreco({bool crescente = true}) {
    _produtos.sort((a, b) {
      final comparacao = a.preco.compareTo(b.preco);
      return crescente ? comparacao : -comparacao;
    });
    notifyListeners();
  }

  /// Ordena produtos por data de criação
  void ordenarPorDataCriacao({bool crescente = true}) {
    _produtos.sort((a, b) {
      final comparacao = a.dataCriacao.compareTo(b.dataCriacao);
      return crescente ? comparacao : -comparacao;
    });
    notifyListeners();
  }
}
