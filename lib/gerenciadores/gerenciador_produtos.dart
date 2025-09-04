import 'package:flutter/foundation.dart';
import '../modelos/produto.dart';

class GerenciadorProdutos with ChangeNotifier {
  final List<Produto> _produtos = [
    Produto(
      nome: 'Tenis',
      preco: 5.50,
      descricao: 'Um tenis muito bom, confortável e bonito para o dia a dia.',
      urlImagem:
          'https://artwalk.vtexassets.com/arquivos/ids/516429-1200-auto?v=638499942909830000&width=1200&height=auto&aspect=true',
    ),
  ];

  List<Produto> get produtos => List.unmodifiable(_produtos);

  void adicionarProduto(
    String nome,
    double preco,
    String descricao,
    String urlImagem,
  ) {
    final novoProduto = Produto(
      nome: nome,
      preco: preco,
      descricao: descricao,
      urlImagem: urlImagem,
    );
    _produtos.add(novoProduto);
    notifyListeners();
  }
}
