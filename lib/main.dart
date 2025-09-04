import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'gerenciadores/gerenciador_produtos.dart';
import 'gerenciadores/gerenciador_carrinho.dart';
import 'telas/tela_lista_produtos.dart';

void main() {
  runApp(const AplicativoPDV());
}

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
        title: 'PDV Brasil',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const TelaListaProdutos(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
