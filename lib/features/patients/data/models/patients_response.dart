import 'package:equatable/equatable.dart';
import 'patient_model.dart';

/// Response model for paginated patients list
/// Handles pagination with pageIndex, pageSize, count, and list of patients
class PatientsResponse extends Equatable {
  final int pageIndex;
  final int pageSize;
  final int count;
  final List<PatientModel> patients;

  const PatientsResponse({
    required this.pageIndex,
    required this.pageSize,
    required this.count,
    required this.patients,
  });

  factory PatientsResponse.fromJson(Map<String, dynamic> json) {
    // API response structure: { isSuccess, responseData: { pageIndex, pageSize, count, items } }
    final responseData = json['responseData'] ?? json;
    
    final pageIndex = responseData['pageIndex'] ?? 1;
    final pageSize = responseData['pageSize'] ?? 10;
    final count = responseData['count'] ?? 0;
    final items = responseData['items'] ?? [];
    
    return PatientsResponse(
      pageIndex: pageIndex is int ? pageIndex : int.tryParse(pageIndex.toString()) ?? 1,
      pageSize: pageSize is int ? pageSize : int.tryParse(pageSize.toString()) ?? 10,
      count: count is int ? count : int.tryParse(count.toString()) ?? 0,
      patients: items is List
          ? List<PatientModel>.from(
              items.map((x) => PatientModel.fromJson(x as Map<String, dynamic>)))
          : [],
    );
  }

  @override
  List<Object> get props => [pageIndex, pageSize, count, patients];
}

