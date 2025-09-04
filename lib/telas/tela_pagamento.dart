import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/forma_pagamento.dart';
import '../gerenciadores/gerenciador_carrinho.dart';
import 'tela_lista_produtos.dart';

class TelaPagamento extends StatefulWidget {
  const TelaPagamento({super.key});

  @override
  State<TelaPagamento> createState() => _TelaPagamentoState();
}

class _TelaPagamentoState extends State<TelaPagamento> {
  FormaPagamento? _formaPagamentoSelecionada;

  final List<FormaPagamento> _formasPagamento = [
    FormaPagamento(nome: 'Dinheiro', icone: Icons.money),
    FormaPagamento(nome: 'Cartão de Crédito', icone: Icons.credit_card),
    FormaPagamento(nome: 'PIX', icone: Icons.qr_code),
  ];

  void _finalizarVenda() {
    if (_formaPagamentoSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione uma forma de pagamento'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Venda'),
          content: Text(
            'Deseja finalizar a venda com pagamento em ${_formaPagamentoSelecionada!.nome}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Limpar o carrinho
                Provider.of<GerenciadorCarrinho>(context, listen: false).limpar();
                
                // Fechar o diálogo
                Navigator.of(context).pop();
                
                // Mostrar mensagem de sucesso
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Venda finalizada com sucesso! Pagamento: ${_formaPagamentoSelecionada!.nome}',
                    ),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 3),
                  ),
                );
                
                // Navegar de volta para a lista de produtos
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const TelaListaProdutos(),
                  ),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamento'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecione a forma de pagamento:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...(_formasPagamento.map((forma) => ListTile(
              leading: Icon(
                _formaPagamentoSelecionada == forma 
                    ? Icons.radio_button_checked 
                    : Icons.radio_button_unchecked,
                color: _formaPagamentoSelecionada == forma ? Colors.blue : Colors.grey,
              ),
              title: Row(
                children: [
                  Icon(forma.icone),
                  const SizedBox(width: 8),
                  Text(forma.nome),
                ],
              ),
              onTap: () {
                setState(() {
                  _formaPagamentoSelecionada = forma;
                });
              },
            )).toList()),
            const Spacer(),
            Consumer<GerenciadorCarrinho>(
              builder: (context, carrinho, child) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total da Venda:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'R\$ ${carrinho.valorTotal.toStringAsFixed(2).replaceAll('.', ',')}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _finalizarVenda,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Finalizar Venda',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
