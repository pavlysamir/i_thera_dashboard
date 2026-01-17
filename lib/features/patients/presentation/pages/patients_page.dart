import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_thera_dashboard/core/theme/app_colors.dart';
import '../../../../core/di/service_locator.dart';
import '../../manager/patients_cubit.dart';
import '../../manager/patients_state.dart';
import '../../data/models/patient_model.dart';

class PatientsPage extends StatelessWidget {
  const PatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PatientsCubit>()..getPatients(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header
                const _PatientsHeader(),
                const SizedBox(height: 24),
                // Main Content: Table & Pagination
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: BlocBuilder<PatientsCubit, PatientsState>(
                      builder: (context, state) {
                        if (state is PatientsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          );
                        } else if (state is PatientsError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.red.shade300,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'خطأ: ${state.message}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<PatientsCubit>().getPatients();
                                  },
                                  child: const Text('إعادة المحاولة'),
                                ),
                              ],
                            ),
                          );
                        } else if (state is PatientsSuccess) {
                          return Column(
                            children: [
                              // Table
                              Expanded(
                                child: _PatientsTable(
                                  patients: state.response.patients,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Pagination
                              _PaginationControls(
                                currentPage: state.response.pageIndex,
                                totalCount: state.response.count,
                                pageSize: state.response.pageSize,
                              ),
                            ],
                          );
                        }
                        return const Center(child: Text('يرجى الانتظار...'));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PatientsHeader extends StatelessWidget {
  const _PatientsHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'إدارة المرضى',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
        const Spacer(),
        // Search Bar
        SizedBox(
          width: 300,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'بحث',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PatientsTable extends StatelessWidget {
  final List<PatientModel> patients;

  const _PatientsTable({required this.patients});

  @override
  Widget build(BuildContext context) {
    if (patients.isEmpty) {
      return const Center(
        child: Text(
          'لا يوجد بيانات',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
      );
    }

    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 100,
          ),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              const Color(0xFFE3F2FD),
            ),
            dataRowColor: WidgetStateProperty.all(Colors.white),
            columns: const [
              DataColumn(
                label: Text(
                  'الرقم التعريفي',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: Color(0xFF1E88E5),
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'الأسم',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: Color(0xFF1E88E5),
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'تاريخ الانضمام',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: Color(0xFF1E88E5),
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'رقم الموبيل',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: Color(0xFF1E88E5),
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'الإيميل',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: Color(0xFF1E88E5),
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'النوع',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: Color(0xFF1E88E5),
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'المدينة',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: Color(0xFF1E88E5),
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'المنطقة',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: Color(0xFF1E88E5),
                  ),
                ),
              ),
            ],
            rows: patients.map((patient) {
              // Format date
              final dateCreated = patient.createdOn.isEmpty
                  ? '-'
                  : patient.createdOn.split('T').first;

              return DataRow(
                cells: [
                  DataCell(
                    TextButton(
                      onPressed: () {
                        // Navigate to patient details
                      },
                      child: Text(
                        '${patient.id}',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      patient.userName,
                      style: const TextStyle(fontFamily: 'Cairo'),
                    ),
                  ),
                  DataCell(Text(dateCreated)),
                  DataCell(Text(patient.phoneNumber)),
                  DataCell(Text(patient.email.isEmpty ? '-' : patient.email)),
                  DataCell(
                    Text(
                      patient.gender == 1 ? 'ذكر' : 'أنثي',
                      style: const TextStyle(fontFamily: 'Cairo'),
                    ),
                  ),
                  DataCell(Text(patient.cityName)),
                  DataCell(Text(patient.regionName ?? '-')),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalCount;
  final int pageSize;

  const _PaginationControls({
    required this.currentPage,
    required this.totalCount,
    required this.pageSize,
  });

  @override
  Widget build(BuildContext context) {
    final int totalPages = (totalCount / pageSize).ceil();
    if (totalPages <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: currentPage > 1
              ? () => context.read<PatientsCubit>().previousPage()
              : null,
          icon: const Icon(Icons.arrow_back_ios, size: 16),
        ),
        // Page numbers
        ...List.generate(totalPages, (index) {
          final page = index + 1;
          // Limit display for too many pages
          if (totalPages > 10 &&
              (page > 3 && page < totalPages - 2 && (page != currentPage))) {
            if (page == 4) return const Text(' ... ');
            return const SizedBox.shrink();
          }

          final isActive = page == currentPage;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () => context.read<PatientsCubit>().goToPage(page),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF0D47A1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: isActive
                      ? null
                      : Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: Text(
                    '$page',
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.black,
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
        IconButton(
          onPressed: currentPage < totalPages
              ? () => context.read<PatientsCubit>().nextPage()
              : null,
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
        const SizedBox(width: 16),
        Text(
          'عرض ${(currentPage - 1) * pageSize + 1}-${(currentPage * pageSize).clamp(0, totalCount)} من $totalCount سجل',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}

