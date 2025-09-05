import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'gerenciadores/gerenciador_produtos.dart';
import 'gerenciadores/gerenciador_carrinho.dart';
import 'core/theme.dart';
import 'core/constants.dart';
import 'core/responsive_helper.dart';
import 'telas/tela_lista_produtos.dart';

/// Função principal do aplicativo PDV
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Configura orientação da tela
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const AplicativoPDV());
}

/// Widget principal do aplicativo PDV
class AplicativoPDV extends StatelessWidget {
  const AplicativoPDV({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GerenciadorProdutos()),
        ChangeNotifierProvider(create: (context) => GerenciadorCarrinho()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        home: const TelaListaProdutos(),
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(
                ResponsiveHelper.getTextScaleFactor(context),
              ),
            ),
            child: child!,
          );
        },
        onGenerateRoute: (settings) {
          // Configuração de rotas nomeadas (para futuras expansões)
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (context) => const TelaListaProdutos(),
              );
            default:
              return MaterialPageRoute(
                builder: (context) => const TelaListaProdutos(),
              );
          }
        },
      ),
    );
  }
}
