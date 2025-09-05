import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/forma_pagamento.dart';
import '../gerenciadores/gerenciador_carrinho.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import 'tela_lista_produtos.dart';

/// Tela para seleção da forma de pagamento e finalização da venda
class TelaPagamento extends StatefulWidget {
  const TelaPagamento({super.key});

  @override
  State<TelaPagamento> createState() => _TelaPagamentoState();
}

class _TelaPagamentoState extends State<TelaPagamento> {
  FormaPagamento? _formaPagamentoSelecionada;
  bool _isProcessing = false;

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

          return Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPaymentMethods(theme),
                const Spacer(),
                _buildCartSummary(carrinho, theme),
                const SizedBox(height: AppConstants.defaultPadding),
                _buildFinalizeButton(theme),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      title: Text(AppStrings.paymentTitle),
      backgroundColor: AppTheme.screenColors['payment'],
      foregroundColor: Colors.white,
      elevation: 2,
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
            'Carrinho vazio',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            'Adicione produtos ao carrinho para continuar',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppConstants.largePadding),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar ao carrinho'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.selectPaymentMethod,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        ...FormaPagamentoExtension.formasPadrao.map(
          (forma) => _buildPaymentMethodTile(forma, theme),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodTile(FormaPagamento forma, ThemeData theme) {
    final isSelected = _formaPagamentoSelecionada?.id == forma.id;

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: ListTile(
        leading: Icon(
          isSelected
              ? Icons.radio_button_checked
              : Icons.radio_button_unchecked,
          color: isSelected
              ? AppColorsExtension.primary
              : theme.colorScheme.onSurfaceVariant,
        ),
        title: Row(
          children: [
            Icon(
              forma.icone,
              color: isSelected
                  ? AppColorsExtension.primary
                  : theme.colorScheme.onSurface,
            ),
            const SizedBox(width: AppConstants.smallPadding),
            Text(forma.nome),
          ],
        ),
        subtitle: forma.descricao != null ? Text(forma.descricao!) : null,
        onTap: () {
          setState(() {
            _formaPagamentoSelecionada = forma;
          });
        },
        selected: isSelected,
        selectedTileColor: theme.colorScheme.primaryContainer.withOpacity(0.1),
      ),
    );
  }

  Widget _buildCartSummary(GerenciadorCarrinho carrinho, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.saleTotal,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                carrinho.valorTotalFormatado,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColorsExtension.price,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            '${carrinho.quantidadeTotalProdutos} itens no carrinho',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalizeButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: AppConstants.buttonHeight,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _finalizarVenda,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.screenColors['payment'],
          foregroundColor: Colors.white,
        ),
        child: _isProcessing
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                AppStrings.finalizeSale,
                style: TextStyle(fontSize: 18),
              ),
      ),
    );
  }

  Future<void> _finalizarVenda() async {
    if (_formaPagamentoSelecionada == null) {
      _showErrorSnackBar(AppStrings.selectPaymentMethodError);
      return;
    }

    final confirmed = await _showConfirmDialog();
    if (confirmed != true) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Simula processamento da venda
      await Future.delayed(const Duration(seconds: 2));

      // Limpar o carrinho
      Provider.of<GerenciadorCarrinho>(context, listen: false).limpar();

      // Mostrar mensagem de sucesso
      _showSuccessSnackBar(
        '${AppStrings.saleCompletedSuccessfully} Pagamento: ${_formaPagamentoSelecionada!.nome}',
      );

      // Navegar de volta para a lista de produtos
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const TelaListaProdutos()),
          (route) => false,
        );
      }
    } catch (e) {
      _showErrorSnackBar('Erro ao finalizar venda: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<bool?> _showConfirmDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.confirmSale),
        content: Text(
          '${AppStrings.confirmSaleMessage} ${_formaPagamentoSelecionada!.nome}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColorsExtension.success,
              foregroundColor: Colors.white,
            ),
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
        duration: AppConstants.successSnackBarDuration,
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
