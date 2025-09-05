import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../gerenciadores/gerenciador_produtos.dart';
import '../core/constants.dart';
import '../core/theme.dart';

/// Tela para adicionar novos produtos ao sistema
class TelaAdicionarProduto extends StatefulWidget {
  const TelaAdicionarProduto({super.key});

  @override
  State<TelaAdicionarProduto> createState() => _TelaAdicionarProdutoState();
}

class _TelaAdicionarProdutoState extends State<TelaAdicionarProduto> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _urlImagemController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    _descricaoController.dispose();
    _urlImagemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(appBar: _buildAppBar(theme), body: _buildBody(theme));
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      title: Text(AppStrings.addProductTitle),
      backgroundColor: AppTheme.screenColors['addProduct'],
      foregroundColor: Colors.white,
      elevation: 2,
      actions: [
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBody(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProductImagePreview(theme),
            const SizedBox(height: AppConstants.largePadding),
            _buildFormFields(theme),
            const SizedBox(height: AppConstants.largePadding),
            _buildActionButtons(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImagePreview(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            Text(
              'Preview da Imagem',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                child: _urlImagemController.text.isNotEmpty
                    ? Image.network(
                        _urlImagemController.text,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildImagePlaceholder(theme);
                        },
                      )
                    : _buildImagePlaceholder(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceVariant,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 50,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            'Nenhuma imagem',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields(ThemeData theme) {
    return Column(
      children: [
        _buildNameField(theme),
        const SizedBox(height: AppConstants.defaultPadding),
        _buildPriceField(theme),
        const SizedBox(height: AppConstants.defaultPadding),
        _buildDescriptionField(theme),
        const SizedBox(height: AppConstants.defaultPadding),
        _buildImageUrlField(theme),
      ],
    );
  }

  Widget _buildNameField(ThemeData theme) {
    return TextFormField(
      controller: _nomeController,
      decoration: InputDecoration(
        labelText: AppStrings.productNameLabel,
        prefixIcon: const Icon(Icons.shopping_bag),
        helperText: 'Máximo ${AppConstants.maxProductNameLength} caracteres',
        counterText:
            '${_nomeController.text.length}/${AppConstants.maxProductNameLength}',
      ),
      maxLength: AppConstants.maxProductNameLength,
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppStrings.enterProductName;
        }
        if (value.trim().length < 2) {
          return 'Nome deve ter pelo menos 2 caracteres';
        }
        return null;
      },
    );
  }

  Widget _buildPriceField(ThemeData theme) {
    return TextFormField(
      controller: _precoController,
      decoration: InputDecoration(
        labelText: AppStrings.priceLabel,
        prefixIcon: const Icon(Icons.attach_money),
        helperText:
            'Valor entre R\$ ${AppConstants.minPrice.toStringAsFixed(2)} e R\$ ${AppConstants.maxPrice.toStringAsFixed(2)}',
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppStrings.enterPrice;
        }
        final preco = double.tryParse(value.replaceAll(',', '.'));
        if (preco == null) {
          return 'Formato de preço inválido';
        }
        if (preco < AppConstants.minPrice) {
          return 'Preço deve ser pelo menos R\$ ${AppConstants.minPrice.toStringAsFixed(2)}';
        }
        if (preco > AppConstants.maxPrice) {
          return 'Preço deve ser no máximo R\$ ${AppConstants.maxPrice.toStringAsFixed(2)}';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField(ThemeData theme) {
    return TextFormField(
      controller: _descricaoController,
      decoration: InputDecoration(
        labelText: AppStrings.descriptionLabel,
        prefixIcon: const Icon(Icons.description),
        helperText: 'Máximo ${AppConstants.maxDescriptionLength} caracteres',
        counterText:
            '${_descricaoController.text.length}/${AppConstants.maxDescriptionLength}',
      ),
      maxLines: 3,
      maxLength: AppConstants.maxDescriptionLength,
      textCapitalization: TextCapitalization.sentences,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppStrings.enterDescription;
        }
        if (value.trim().length < 10) {
          return 'Descrição deve ter pelo menos 10 caracteres';
        }
        return null;
      },
    );
  }

  Widget _buildImageUrlField(ThemeData theme) {
    return TextFormField(
      controller: _urlImagemController,
      decoration: InputDecoration(
        labelText: AppStrings.imageUrlLabel,
        prefixIcon: const Icon(Icons.image),
        helperText: 'URL da imagem do produto',
        suffixIcon: _urlImagemController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  setState(() {});
                },
                tooltip: 'Atualizar preview',
              )
            : null,
      ),
      keyboardType: TextInputType.url,
      onChanged: (value) {
        setState(() {});
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppStrings.enterImageUrl;
        }
        final uri = Uri.tryParse(value);
        if (uri == null || !uri.hasAbsolutePath) {
          return AppStrings.enterValidImageUrl;
        }
        return null;
      },
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
        ),
        const SizedBox(width: AppConstants.defaultPadding),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _salvarProduto,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.screenColors['addProduct'],
              foregroundColor: Colors.white,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(AppStrings.saveProduct),
          ),
        ),
      ],
    );
  }

  Future<void> _salvarProduto() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final nome = _nomeController.text.trim();
      final preco = double.parse(_precoController.text.replaceAll(',', '.'));
      final descricao = _descricaoController.text.trim();
      final urlImagem = _urlImagemController.text.trim();

      await Provider.of<GerenciadorProdutos>(
        context,
        listen: false,
      ).adicionarProduto(
        nome: nome,
        preco: preco,
        descricao: descricao,
        urlImagem: urlImagem,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.productSavedSuccessfully),
            backgroundColor: AppColorsExtension.success,
            duration: AppConstants.snackBarDuration,
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar produto: $e'),
            backgroundColor: AppColorsExtension.error,
            duration: AppConstants.snackBarDuration,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
