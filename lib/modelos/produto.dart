import 'package:uuid/uuid.dart';
import '../core/constants.dart';

/// Modelo de dados para produtos do sistema PDV
class Produto {
  final String id;
  final String nome;
  final double preco;
  final String descricao;
  final String urlImagem;
  final DateTime dataCriacao;
  final DateTime? dataAtualizacao;

  Produto({
    String? id,
    required this.nome,
    required this.preco,
    required this.descricao,
    required this.urlImagem,
    DateTime? dataCriacao,
    this.dataAtualizacao,
  }) : id = id ?? const Uuid().v4(),
       dataCriacao = dataCriacao ?? DateTime.now();

  /// Cria uma cópia do produto com campos atualizados
  Produto copyWith({
    String? nome,
    double? preco,
    String? descricao,
    String? urlImagem,
    DateTime? dataAtualizacao,
  }) {
    return Produto(
      id: id,
      nome: nome ?? this.nome,
      preco: preco ?? this.preco,
      descricao: descricao ?? this.descricao,
      urlImagem: urlImagem ?? this.urlImagem,
      dataCriacao: dataCriacao,
      dataAtualizacao: dataAtualizacao ?? DateTime.now(),
    );
  }

  /// Valida se o produto está válido
  bool get isValid {
    return nome.trim().isNotEmpty &&
        preco >= AppConstants.minPrice &&
        preco <= AppConstants.maxPrice &&
        descricao.trim().isNotEmpty;
    // URL é opcional - não valida se vazia
  }

  /// Formata o preço para exibição
  String get precoFormatado {
    return 'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Verifica se o produto tem imagem
  bool get temImagem => urlImagem.trim().isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Produto && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Produto{id: $id, nome: $nome, preco: $preco, descricao: $descricao}';
  }

  /// Converte para Map para serialização
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'preco': preco,
      'descricao': descricao,
      'urlImagem': urlImagem,
      'dataCriacao': dataCriacao.toIso8601String(),
      'dataAtualizacao': dataAtualizacao?.toIso8601String(),
    };
  }

  /// Cria produto a partir de Map
  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'] as String,
      nome: map['nome'] as String,
      preco: (map['preco'] as num).toDouble(),
      descricao: map['descricao'] as String,
      urlImagem: map['urlImagem'] as String,
      dataCriacao: DateTime.parse(map['dataCriacao'] as String),
      dataAtualizacao: map['dataAtualizacao'] != null
          ? DateTime.parse(map['dataAtualizacao'] as String)
          : null,
    );
  }
}
