import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../gerenciadores/gerenciador_produtos.dart';
import '../gerenciadores/gerenciador_carrinho.dart';
import '../componentes/cartao_produto.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import 'tela_carrinho.dart';
import 'tela_adicionar_produto.dart';

/// Tela principal que exibe a lista de produtos disponíveis
class TelaListaProdutos extends StatefulWidget {
  const TelaListaProdutos({super.key});

  @override
  State<TelaListaProdutos> createState() => _TelaListaProdutosState();
}

class _TelaListaProdutosState extends State<TelaListaProdutos> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(theme),
      body: Column(
        children: [
          _buildSearchBar(theme),
          Expanded(child: _buildProductsList(theme)),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(theme),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      title: Text(AppStrings.productsTitle),
      backgroundColor: AppTheme.screenColors['products'],
      foregroundColor: Colors.white,
      elevation: 2,
      actions: [
        _buildCartButton(),
        const SizedBox(width: AppConstants.smallPadding),
      ],
    );
  }

  Widget _buildCartButton() {
    return Consumer<GerenciadorCarrinho>(
      builder: (context, carrinho, child) {
        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => _navigateToCart(),
              tooltip: AppStrings.cartTooltip,
            ),
            if (carrinho.quantidadeDeItens > 0)
              Positioned(
                right: AppConstants.smallPadding,
                top: AppConstants.smallPadding,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColorsExtension.badge,
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
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar produtos...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }

  Widget _buildProductsList(ThemeData theme) {
    return Consumer<GerenciadorProdutos>(
      builder: (context, gerenciadorProdutos, child) {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final produtos = _searchQuery.isEmpty
            ? gerenciadorProdutos.produtosValidos
            : gerenciadorProdutos.buscarProdutosPorNome(_searchQuery);

        if (produtos.isEmpty) {
          return _buildEmptyState(theme);
        }

        return RefreshIndicator(
          onRefresh: _refreshProducts,
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: AppConstants.largePadding),
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              final produto = produtos[index];
              return CartaoProduto(
                produto: produto,
                onTap: () => _showProductDetails(produto),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: AppConstants.largeIconSize,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            _searchQuery.isEmpty
                ? 'Nenhum produto cadastrado'
                : 'Nenhum produto encontrado',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            _searchQuery.isEmpty
                ? 'Toque no botão + para adicionar produtos'
                : 'Tente uma busca diferente',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: AppConstants.defaultPadding),
            ElevatedButton.icon(
              onPressed: _clearSearch,
              icon: const Icon(Icons.clear),
              label: const Text('Limpar busca'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(ThemeData theme) {
    return FloatingActionButton.extended(
      onPressed: _navigateToAddProduct,
      backgroundColor: AppTheme.screenColors['addProduct'],
      foregroundColor: Colors.white,
      tooltip: AppStrings.addProductTooltip,
      icon: const Icon(Icons.add),
      label: const Text(AppStrings.registerProduct),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _isLoading = true;
    });

    // Simula um delay de carregamento
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaCarrinho()),
    );
  }

  void _navigateToAddProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaAdicionarProduto()),
    );
  }

  void _showProductDetails(produto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(produto.nome),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (produto.temImagem) ...[
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                  child: Image.network(
                    produto.urlImagem,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported, size: 100);
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.defaultPadding),
            ],
            Text('Preço: ${produto.precoFormatado}'),
            const SizedBox(height: AppConstants.smallPadding),
            Text('Descrição: ${produto.descricao}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _addToCart(produto);
            },
            child: const Text(AppStrings.addToCart),
          ),
        ],
      ),
    );
  }

  void _addToCart(produto) {
    Provider.of<GerenciadorCarrinho>(
      context,
      listen: false,
    ).adicionarItem(produto);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${produto.nome} ${AppStrings.productAddedToCart}'),
        backgroundColor: AppColorsExtension.success,
        duration: AppConstants.snackBarDuration,
      ),
    );
  }
}
