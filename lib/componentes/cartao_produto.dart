import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/produto.dart';
import '../gerenciadores/gerenciador_carrinho.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import 'imagem_produto.dart';

/// Componente de card para exibição de produtos
class CartaoProduto extends StatelessWidget {
  final Produto produto;
  final VoidCallback? onTap;
  final bool mostrarBotaoAdicionar;

  const CartaoProduto({
    super.key,
    required this.produto,
    this.onTap,
    this.mostrarBotaoAdicionar = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Row(
            children: [
              // Imagem do produto
              _buildImagemProduto(),
              const SizedBox(width: AppConstants.defaultPadding),
              // Informações do produto
              Expanded(child: _buildInformacoesProduto(theme)),
              // Botão adicionar ao carrinho
              if (mostrarBotaoAdicionar) _buildBotaoAdicionar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagemProduto() {
    return SizedBox(
      width: AppConstants.imageSize,
      height: AppConstants.imageSize,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: ImagemProduto(
          urlImagem: produto.temImagem ? produto.urlImagem : null,
          width: AppConstants.imageSize,
          height: AppConstants.imageSize,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildInformacoesProduto(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          produto.nome,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (produto.descricao.isNotEmpty) ...[
          const SizedBox(height: AppConstants.smallPadding / 2),
          Text(
            produto.descricao,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: AppConstants.smallPadding),
        Text(
          produto.precoFormatado,
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColorsExtension.price,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBotaoAdicionar(BuildContext context) {
    return Consumer<GerenciadorCarrinho>(
      builder: (context, carrinho, child) {
        final quantidadeNoCarrinho = carrinho.quantidadeDoProduto(produto.id);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              color: AppColorsExtension.primary,
              onPressed: () => _adicionarAoCarrinho(context, carrinho),
              tooltip: AppStrings.addToCart,
            ),
            if (quantidadeNoCarrinho > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.smallPadding,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColorsExtension.badge,
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                ),
                child: Text(
                  '$quantidadeNoCarrinho',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _adicionarAoCarrinho(
    BuildContext context,
    GerenciadorCarrinho carrinho,
  ) async {
    try {
      await carrinho.adicionarItem(produto);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${produto.nome} ${AppStrings.productAddedToCart}'),
            backgroundColor: AppColorsExtension.success,
            duration: AppConstants.snackBarDuration,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: AppColorsExtension.error,
            duration: AppConstants.snackBarDuration,
          ),
        );
      }
    }
  }
}
