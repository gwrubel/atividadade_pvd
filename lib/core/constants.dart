/// Constantes globais do sistema PDV
class AppConstants {
  // App Info
  static const String appName = 'PDV Brasil';
  static const String appVersion = '1.0.0';

  // Dimensões
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 8.0;
  static const double largeBorderRadius = 12.0;
  static const double buttonHeight = 50.0;
  static const double imageSize = 80.0;
  static const double iconSize = 24.0;
  static const double largeIconSize = 100.0;

  // Durações
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  static const Duration snackBarDuration = Duration(seconds: 2);
  static const Duration successSnackBarDuration = Duration(seconds: 3);

  // Validações
  static const int maxProductNameLength = 100;
  static const int maxDescriptionLength = 500;
  static const int maxUrlLength = 1000;
  static const double minPrice = 0.01;
  static const double maxPrice = 999999.99;

  // Produto padrão
  static const String defaultProductName = 'Tênis';
  static const double defaultProductPrice = 5.50;
  static const String defaultProductDescription =
      'Um tênis muito bom, confortável e bonito para o dia a dia.';
  static const String defaultProductImageUrl =
      'https://artwalk.vtexassets.com/arquivos/ids/516429-1200-auto?v=638499942909830000&width=1200&height=auto&aspect=true';
}

/// Strings de interface do usuário
class AppStrings {
  // Títulos das telas
  static const String productsTitle = 'Produtos';
  static const String cartTitle = 'Carrinho de Compras';
  static const String paymentTitle = 'Pagamento';
  static const String addProductTitle = 'Adicionar Produto';

  // Botões
  static const String addToCart = 'Adicionar ao Carrinho';
  static const String goToPayment = 'Ir para Pagamento';
  static const String clearCart = 'Limpar Carrinho';
  static const String finalizeSale = 'Finalizar Venda';
  static const String saveProduct = 'Salvar Produto';
  static const String cancel = 'Cancelar';
  static const String confirm = 'Confirmar';
  static const String registerProduct = 'Cadastrar Produto';

  // Labels de formulário
  static const String productNameLabel = 'Nome do Produto';
  static const String priceLabel = 'Preço';
  static const String descriptionLabel = 'Descrição';
  static const String imageUrlLabel = 'URL da Imagem';
  static const String selectPaymentMethod = 'Selecione a forma de pagamento:';

  // Mensagens
  static const String emptyCart = 'Carrinho vazio';
  static const String addProductsToContinue =
      'Adicione produtos para continuar';
  static const String total = 'Total:';
  static const String saleTotal = 'Total da Venda:';
  static const String productAddedToCart = 'adicionado ao carrinho!';
  static const String productSavedSuccessfully = 'Produto salvo com sucesso!';
  static const String saleCompletedSuccessfully =
      'Venda finalizada com sucesso!';
  static const String selectPaymentMethodError =
      'Por favor, selecione uma forma de pagamento';
  static const String confirmSale = 'Confirmar Venda';
  static const String confirmSaleMessage =
      'Deseja finalizar a venda com pagamento em';

  // Validações
  static const String enterProductName = 'Por favor, insira o nome do produto';
  static const String enterPrice = 'Por favor, insira o preço';
  static const String enterValidPrice = 'Por favor, insira um preço válido';
  static const String enterDescription = 'Por favor, insira a descrição';
  static const String enterImageUrl = 'Por favor, insira a URL da imagem';
  static const String enterValidImageUrl = 'Por favor, insira uma URL válida';

  // Formas de pagamento
  static const String cashPayment = 'Dinheiro';
  static const String creditCardPayment = 'Cartão de Crédito';
  static const String pixPayment = 'PIX';

  // Tooltips
  static const String addProductTooltip = 'Adicionar Produto';
  static const String cartTooltip = 'Carrinho de Compras';

  // Fallbacks
  static const String noImage = 'Sem imagem';
  static const String loading = 'Carregando...';
  static const String error = 'Erro';
}

/// Cores do sistema
class AppColors {
  // Cores primárias
  static const int primaryColorValue = 0xFF2196F3;
  static const int secondaryColorValue = 0xFF4CAF50;
  static const int accentColorValue = 0xFFFF9800;
  static const int errorColorValue = 0xFFF44336;
  static const int warningColorValue = 0xFFFF9800;
  static const int successColorValue = 0xFF4CAF50;

  // Cores de fundo
  static const int backgroundColorValue = 0xFFF5F5F5;
  static const int surfaceColorValue = 0xFFFFFFFF;
  static const int cardColorValue = 0xFFFFFFFF;

  // Cores de texto
  static const int textPrimaryValue = 0xFF212121;
  static const int textSecondaryValue = 0xFF757575;
  static const int textHintValue = 0xFFBDBDBD;

  // Cores específicas das telas
  static const int productsScreenColorValue = 0xFF9E9E9E; // Grey
  static const int cartScreenColorValue = 0xFFFF9800; // Orange
  static const int paymentScreenColorValue = 0xFF9C27B0; // Purple
  static const int addProductScreenColorValue = 0xFF4CAF50; // Green

  // Cores de status
  static const int badgeColorValue = 0xFFF44336; // Red
  static const int priceColorValue = 0xFF4CAF50; // Green
  static const int disabledColorValue = 0xFFBDBDBD; // Grey
}

/// Ícones do sistema
class AppIcons {
  static const String shoppingCart = 'shopping_cart';
  static const String addShoppingCart = 'add_shopping_cart';
  static const String shoppingCartOutlined = 'shopping_cart_outlined';
  static const String add = 'add';
  static const String money = 'money';
  static const String creditCard = 'credit_card';
  static const String qrCode = 'qr_code';
  static const String shoppingBag = 'shopping_bag';
  static const String attachMoney = 'attach_money';
  static const String description = 'description';
  static const String image = 'image';
  static const String imageNotSupported = 'image_not_supported';
  static const String radioButtonChecked = 'radio_button_checked';
  static const String radioButtonUnchecked = 'radio_button_unchecked';
}
