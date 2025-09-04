import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/produto.dart';
import '../gerenciadores/gerenciador_carrinho.dart';

class CartaoProduto extends StatelessWidget {
  final Produto produto;

  const CartaoProduto({
    super.key,
    required this.produto,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Imagem do produto
            if (produto.urlImagem.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  produto.urlImagem,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(width: 12),
            // Informações do produto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produto.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (produto.descricao.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      produto.descricao,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    'R\$ ${produto.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Botão adicionar ao carrinho
            IconButton(
              icon: const Icon(Icons.add_shopping_cart, color: Colors.blue),
              onPressed: () {
                Provider.of<GerenciadorCarrinho>(context, listen: false)
                    .adicionarItem(produto);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${produto.nome} adicionado ao carrinho!'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
