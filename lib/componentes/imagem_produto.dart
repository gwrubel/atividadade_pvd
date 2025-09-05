import 'dart:io';
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/theme.dart';

/// Componente para exibição de imagens de produtos com fallbacks
class ImagemProduto extends StatelessWidget {
  final String? urlImagem;
  final File? imagemLocal;
  final double width;
  final double height;
  final BoxFit fit;
  final bool mostrarLoading;
  final Widget? placeholder;
  final Widget? errorWidget;

  const ImagemProduto({
    super.key,
    this.urlImagem,
    this.imagemLocal,
    this.width = AppConstants.imageSize,
    this.height = AppConstants.imageSize,
    this.fit = BoxFit.cover,
    this.mostrarLoading = true,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: _buildImage(context, theme),
      ),
    );
  }

  Widget _buildImage(BuildContext context, ThemeData theme) {
    // Prioriza imagem local se disponível
    if (imagemLocal != null) {
      return _buildLocalImage(context, theme);
    }

    // Fallback para URL se disponível
    if (urlImagem != null && urlImagem!.isNotEmpty) {
      return _buildNetworkImage(context, theme);
    }

    // Fallback final
    return _buildFallback(context, theme);
  }

  Widget _buildLocalImage(BuildContext context, ThemeData theme) {
    return FutureBuilder<bool>(
      future: _verificarArquivoExiste(imagemLocal!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            mostrarLoading) {
          return _buildLoadingIndicator(theme);
        }

        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!) {
          return _buildFallback(context, theme);
        }

        return Image.file(
          imagemLocal!,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Erro ao carregar imagem local: $error');
            return _buildFallback(context, theme);
          },
        );
      },
    );
  }

  Widget _buildNetworkImage(BuildContext context, ThemeData theme) {
    return Image.network(
      urlImagem!,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        if (!mostrarLoading) return child;

        return _buildLoadingIndicator(theme, loadingProgress);
      },
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Erro ao carregar imagem da rede: $error');
        return _buildFallback(context, theme);
      },
    );
  }

  Widget _buildLoadingIndicator(
    ThemeData theme, [
    ImageChunkEvent? loadingProgress,
  ]) {
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress?.expectedTotalBytes != null
            ? loadingProgress!.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
            : null,
        strokeWidth: 2,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildFallback(BuildContext context, ThemeData theme) {
    if (errorWidget != null) return errorWidget!;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            color: theme.colorScheme.onSurfaceVariant,
            size: width * 0.4,
          ),
          const SizedBox(height: AppConstants.smallPadding / 2),
          Text(
            AppStrings.noImage,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _verificarArquivoExiste(File arquivo) async {
    try {
      return await arquivo.exists();
    } catch (e) {
      debugPrint('Erro ao verificar arquivo: $e');
      return false;
    }
  }
}

/// Widget de placeholder para imagens
class ImagemPlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final String? texto;
  final IconData? icone;

  const ImagemPlaceholder({
    super.key,
    this.width = AppConstants.imageSize,
    this.height = AppConstants.imageSize,
    this.texto,
    this.icone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icone ?? Icons.image_outlined,
            color: theme.colorScheme.onSurfaceVariant,
            size: width * 0.4,
          ),
          if (texto != null) ...[
            const SizedBox(height: AppConstants.smallPadding / 2),
            Text(
              texto!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
