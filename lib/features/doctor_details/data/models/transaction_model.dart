import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  final int id;
  final num amount;
  final int type;
  final String date;
  final String description;

  const TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.date,
    required this.description,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? 0,
      amount: json['amount'] ?? 0,
      type: json['type'] ?? 0,
      date: json['date'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'date': date,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [id, amount, type, date, description];
}
