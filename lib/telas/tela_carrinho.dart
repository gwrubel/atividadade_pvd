import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../gerenciadores/gerenciador_carrinho.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import 'tela_pagamento.dart';

/// Tela que exibe o carrinho de compras e permite gerenciar itens
class TelaCarrinho extends StatefulWidget {
  const TelaCarrinho({super.key});

  @override
  State<TelaCarrinho> createState() => _TelaCarrinhoState();
}

class _TelaCarrinhoState extends State<TelaCarrinho> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(theme),
      body: Consumer<GerenciadorCarrinho>(
        builder: (context, carrinho, child) {
          if (carrinho.isEmpty) {
            return _buildEmptyCart(theme);
          }

          return Column(
            children: [
              Expanded(child: _buildCartItems(carrinho, theme)),
              _buildCartSummary(carrinho, theme),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      title: Text(AppStrings.cartTitle),
      backgroundColor: AppTheme.screenColors['cart'],
      foregroundColor: Colors.white,
      elevation: 2,
      actions: [
        Consumer<GerenciadorCarrinho>(
          builder: (context, carrinho, child) {
            return PopupMenuButton<String>(
              onSelected: _onMenuSelected,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'clear',
                  child: ListTile(
                    leading: Icon(Icons.clear_all),
                    title: Text('Limpar carrinho'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'sort_name',
                  child: ListTile(
                    leading: Icon(Icons.sort_by_alpha),
                    title: Text('Ordenar por nome'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'sort_price',
                  child: ListTile(
                    leading: Icon(Icons.sort),
                    title: Text('Ordenar por preço'),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyCart(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: AppConstants.largeIconSize,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            AppStrings.emptyCart,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            AppStrings.addProductsToContinue,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppConstants.largePadding),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar aos produtos'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems(GerenciadorCarrinho carrinho, ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: carrinho.itensLista.length,
      itemBuilder: (context, index) {
        final item = carrinho.itensLista[index];
        return _buildCartItem(item, carrinho, theme);
      },
    );
  }

  Widget _buildCartItem(item, GerenciadorCarrinho carrinho, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Row(
          children: [
            // Imagem do produto
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              child: Image.network(
                item.produto.urlImagem,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: theme.colorScheme.surfaceVariant,
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            // Informações do produto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.produto.nome,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppConstants.smallPadding / 2),
                  Text(
                    '${item.produto.precoFormatado} x ${item.quantidade}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    item.subtotalFormatado,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColorsExtension.price,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Controles de quantidade
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _incrementQuantity(item, carrinho),
                  tooltip: 'Aumentar quantidade',
                ),
                Text(
                  '${item.quantidade}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => _decrementQuantity(item, carrinho),
                  tooltip: 'Diminuir quantidade',
                ),
              ],
            ),
            // Botão remover
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: AppColorsExtension.error,
              onPressed: () => _removeItem(item, carrinho),
              tooltip: 'Remover item',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary(GerenciadorCarrinho carrinho, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.total,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                carrinho.valorTotalFormatado,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppColorsExtension.price,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _clearCart(carrinho),
                  icon: const Icon(Icons.clear_all),
                  label: const Text(AppStrings.clearCart),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColorsExtension.error,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.smallPadding),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () => _navigateToPayment(),
                  icon: const Icon(Icons.payment),
                  label: const Text(AppStrings.goToPayment),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.screenColors['cart'],
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onMenuSelected(String value) {
    final carrinho = Provider.of<GerenciadorCarrinho>(context, listen: false);

    switch (value) {
      case 'clear':
        _clearCart(carrinho);
        break;
      case 'sort_name':
        carrinho.ordenarPorNome();
        break;
      case 'sort_price':
        carrinho.ordenarPorPreco();
        break;
    }
  }

  Future<void> _incrementQuantity(item, GerenciadorCarrinho carrinho) async {
    try {
      await carrinho.incrementarQuantidade(item.produto.id);
    } catch (e) {
      _showErrorSnackBar('Erro ao aumentar quantidade: $e');
    }
  }

  Future<void> _decrementQuantity(item, GerenciadorCarrinho carrinho) async {
    try {
      await carrinho.decrementarQuantidade(item.produto.id);
    } catch (e) {
      _showErrorSnackBar('Erro ao diminuir quantidade: $e');
    }
  }

  Future<void> _removeItem(item, GerenciadorCarrinho carrinho) async {
    final confirmed = await _showConfirmDialog(
      'Remover item',
      'Deseja remover ${item.produto.nome} do carrinho?',
    );

    if (confirmed == true) {
      try {
        await carrinho.removerItem(item.produto.id);
        _showSuccessSnackBar('Item removido do carrinho');
      } catch (e) {
        _showErrorSnackBar('Erro ao remover item: $e');
      }
    }
  }

  Future<void> _clearCart(GerenciadorCarrinho carrinho) async {
    final confirmed = await _showConfirmDialog(
      'Limpar carrinho',
      'Deseja remover todos os itens do carrinho?',
    );

    if (confirmed == true) {
      carrinho.limpar();
      _showSuccessSnackBar('Carrinho limpo');
    }
  }

  void _navigateToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaPagamento()),
    );
  }

  Future<bool?> _showConfirmDialog(String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColorsExtension.success,
        duration: AppConstants.snackBarDuration,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColorsExtension.error,
        duration: AppConstants.snackBarDuration,
      ),
    );
  }
}
