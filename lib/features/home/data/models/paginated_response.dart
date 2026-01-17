import 'package:equatable/equatable.dart';

class PaginatedResponse<T> extends Equatable {
  final int pageIndex;
  final int pageSize;
  final int count;
  final List<T> items;

  const PaginatedResponse({
    required this.pageIndex,
    required this.pageSize,
    required this.count,
    required this.items,
  });

  factory PaginatedResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return PaginatedResponse<T>(
      pageIndex: json['pageIndex'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      count: json['count'] ?? 0,
      items: json['items'] != null
          ? List<T>.from((json['items'] as List).map((x) => fromJsonT(x as Map<String, dynamic>)))
          : [],
    );
  }

  @override
  List<Object> get props => [pageIndex, pageSize, count, items];
}
