import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../gerenciadores/gerenciador_produtos.dart';

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

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    _descricaoController.dispose();
    _urlImagemController.dispose();
    super.dispose();
  }

  void _salvarProduto() {
    if (_formKey.currentState!.validate()) {
      final nome = _nomeController.text.trim();
      final preco = double.parse(_precoController.text.replaceAll(',', '.'));
      final descricao = _descricaoController.text.trim();
      final urlImagem = _urlImagemController.text.trim();

      Provider.of<GerenciadorProdutos>(context, listen: false)
          .adicionarProduto(nome, preco, descricao, urlImagem);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produto salvo com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Produto'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Produto',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira o nome do produto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _precoController,
                decoration: const InputDecoration(
                  labelText: 'Preço',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira o preço';
                  }
                  final preco = double.tryParse(value.replaceAll(',', '.'));
                  if (preco == null || preco <= 0) {
                    return 'Por favor, insira um preço válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira a URL da imagem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _urlImagemController,
                decoration: const InputDecoration(
                  labelText: 'URL da Imagem',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira a URL da imagem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _salvarProduto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Salvar Produto',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
