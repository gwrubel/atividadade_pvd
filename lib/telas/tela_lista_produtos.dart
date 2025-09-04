import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../gerenciadores/gerenciador_produtos.dart';
import '../gerenciadores/gerenciador_carrinho.dart';
import '../componentes/cartao_produto.dart';
import 'tela_carrinho.dart';
import 'tela_adicionar_produto.dart';

class TelaListaProdutos extends StatelessWidget {
  const TelaListaProdutos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
        actions: [
          Consumer<GerenciadorCarrinho>(
            builder: (context, carrinho, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TelaCarrinho(),
                        ),
                      );
                    },
                  ),
                  if (carrinho.quantidadeDeItens > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${carrinho.quantidadeDeItens}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<GerenciadorProdutos>(
        builder: (context, gerenciadorProdutos, child) {
          return ListView.builder(
            itemCount: gerenciadorProdutos.produtos.length,
            itemBuilder: (context, index) {
              final produto = gerenciadorProdutos.produtos[index];
              return CartaoProduto(produto: produto);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TelaAdicionarProduto(),
            ),
          );
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        tooltip: 'Adicionar Produto',
        icon: const Icon(Icons.add),
        label: const Text('Cadastrar Produto'),
      ),
    );
  }
}
