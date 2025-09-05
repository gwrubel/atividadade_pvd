import 'package:flutter/material.dart';
import '../core/constants.dart';

/// Enum para tipos de pagamento
enum TipoPagamento { dinheiro, cartaoCredito, pix }

/// Modelo de dados para formas de pagamento
class FormaPagamento {
  final String id;
  final String nome;
  final IconData icone;
  final TipoPagamento tipo;
  final bool ativo;
  final String? descricao;

  const FormaPagamento({
    required this.id,
    required this.nome,
    required this.icone,
    required this.tipo,
    this.ativo = true,
    this.descricao,
  });

  /// Cria uma cópia da forma de pagamento com campos atualizados
  FormaPagamento copyWith({
    String? nome,
    IconData? icone,
    TipoPagamento? tipo,
    bool? ativo,
    String? descricao,
  }) {
    return FormaPagamento(
      id: id,
      nome: nome ?? this.nome,
      icone: icone ?? this.icone,
      tipo: tipo ?? this.tipo,
      ativo: ativo ?? this.ativo,
      descricao: descricao ?? this.descricao,
    );
  }

  /// Verifica se a forma de pagamento está ativa
  bool get isAtiva => ativo;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FormaPagamento && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'FormaPagamento{id: $id, nome: $nome, tipo: $tipo}';
  }

  /// Converte para Map para serialização
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo.name,
      'ativo': ativo,
      'descricao': descricao,
    };
  }

  /// Cria forma de pagamento a partir de Map
  factory FormaPagamento.fromMap(Map<String, dynamic> map) {
    return FormaPagamento(
      id: map['id'] as String,
      nome: map['nome'] as String,
      icone: _getIconePorTipo(
        TipoPagamento.values.firstWhere((e) => e.name == map['tipo']),
      ),
      tipo: TipoPagamento.values.firstWhere((e) => e.name == map['tipo']),
      ativo: map['ativo'] as bool,
      descricao: map['descricao'] as String?,
    );
  }

  /// Retorna o ícone baseado no tipo de pagamento
  static IconData _getIconePorTipo(TipoPagamento tipo) {
    switch (tipo) {
      case TipoPagamento.dinheiro:
        return Icons.money;
      case TipoPagamento.cartaoCredito:
        return Icons.credit_card;
      case TipoPagamento.pix:
        return Icons.qr_code;
    }
  }
}

/// Extensão para facilitar a criação de formas de pagamento
extension FormaPagamentoExtension on FormaPagamento {
  /// Lista de formas de pagamento padrão
  static List<FormaPagamento> get formasPadrao => [
    const FormaPagamento(
      id: 'dinheiro',
      nome: AppStrings.cashPayment,
      icone: Icons.money,
      tipo: TipoPagamento.dinheiro,
      descricao: 'Pagamento em dinheiro',
    ),
    const FormaPagamento(
      id: 'cartao_credito',
      nome: AppStrings.creditCardPayment,
      icone: Icons.credit_card,
      tipo: TipoPagamento.cartaoCredito,
      descricao: 'Pagamento com cartão de crédito',
    ),
    const FormaPagamento(
      id: 'pix',
      nome: AppStrings.pixPayment,
      icone: Icons.qr_code,
      tipo: TipoPagamento.pix,
      descricao: 'Pagamento via PIX',
    ),
  ];
}
