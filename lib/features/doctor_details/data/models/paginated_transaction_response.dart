import 'package:equatable/equatable.dart';
import 'package:i_thera_dashboard/features/doctor_details/data/models/transaction_model.dart';

class PaginatedTransactionResponse extends Equatable {
  final int pageIndex;
  final int pageSize;
  final int count;
  final List<TransactionModel> items;

  const PaginatedTransactionResponse({
    required this.pageIndex,
    required this.pageSize,
    required this.count,
    required this.items,
  });

  factory PaginatedTransactionResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedTransactionResponse(
      pageIndex: json['pageIndex'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      count: json['count'] ?? 0,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [pageIndex, pageSize, count, items];
}
