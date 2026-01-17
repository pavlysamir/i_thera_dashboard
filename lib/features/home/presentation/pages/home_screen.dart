import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_thera_dashboard/core/theme/app_colors.dart';
import '../../../../core/di/service_locator.dart';
import '../../manager/home_cubit.dart';
import '../../manager/home_state.dart';
import '../../data/models/doctor_model.dart';
import '../../../patients/data/models/patient_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeCubit>()..loadData(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA), // Light grey background
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Top Bar: Filter Buttons & Search
                const _TopBar(),
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
                    child: BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        if (state is HomeLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          );
                        } else if (state is HomeError) {
                          return Center(child: Text('Error: ${state.message}'));
                        } else if (state is HomeLoaded) {
                          return Column(
                            children: [
                              // Table
                              Expanded(
                                child: state.currentTab == HomeTab.doctors
                                    ? _DoctorsTable(
                                        doctors: state.doctors?.items ?? [],
                                      )
                                    : _PatientsTable(
                                        patients:
                                            state.patients?.patients ?? [],
                                      ),
                              ),
                              const SizedBox(height: 16),
                              // Pagination
                              _PaginationControls(
                                currentPage: state.currentPage,
                                totalCount: state.totalCount,
                                pageSize: state.pageSize,
                              ),
                            ],
                          );
                        }
                        return const Center(child: Text('Please wait...'));
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

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // Read currentTab directly from Cubit to persist state across Loading/Error
        HomeTab currentTab = context.read<HomeCubit>().currentTab;

        return Row(
          children: [
            // Toggle Buttons
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                children: [
                  _TabButton(
                    title: 'الدكاترة', // Doctors
                    isActive: currentTab == HomeTab.doctors,
                    onTap: () =>
                        context.read<HomeCubit>().changeTab(HomeTab.doctors),
                  ),
                  _TabButton(
                    title: 'المرضى', // Patients
                    isActive: currentTab == HomeTab.patients,
                    onTap: () =>
                        context.read<HomeCubit>().changeTab(HomeTab.patients),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Search Bar
            SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'بحث', // Search
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
            const SizedBox(width: 16),
            // Header Icons (Notification / Settings)
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.notifications_none, color: Colors.blue),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.settings, color: Colors.blue),
            ),
          ],
        );
      },
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.blue,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }
}

class _DoctorsTable extends StatelessWidget {
  final List<DoctorModel> doctors;

  const _DoctorsTable({required this.doctors});

  @override
  Widget build(BuildContext context) {
    if (doctors.isEmpty) {
      return const Center(child: Text("لا يوجد بيانات")); // No data
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
            ), // Light blue header
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
                  'الرصيد',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: Color(0xFF1E88E5),
                  ),
                ),
              ),
            ],
            rows: doctors.map((doctor) {
              // Formatting date briefly
              final dateCreated = doctor.createdOn.isEmpty
                  ? '-'
                  : doctor.createdOn.split('T').first;
              return DataRow(
                cells: [
                  DataCell(
                    TextButton(
                      onPressed: () {
                        // Navigate to details
                      },
                      child: Text(
                        '${doctor.id}',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      doctor.userName,
                      style: const TextStyle(fontFamily: 'Cairo'),
                    ),
                  ),
                  DataCell(Text(dateCreated)),
                  DataCell(Text(doctor.phoneNumber)),
                  DataCell(Text(doctor.email)),
                  DataCell(
                    Text(
                      doctor.gender == 1 ? 'ذكر' : 'أنثي',
                      style: const TextStyle(fontFamily: 'Cairo'),
                    ),
                  ), // Assuming 1=Male
                  DataCell(Text(doctor.cityName)),
                  DataCell(Text('${doctor.walletBalance}')),

                  /// Region not in model provided, leaving empty
                ],
              );
            }).toList(),
          ),
        ),
      ),
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
        child: Text('لا يوجد بيانات', style: TextStyle(fontFamily: 'Cairo')),
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
            headingRowColor: WidgetStateProperty.all(const Color(0xFFE3F2FD)),
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
        // First page button
        IconButton(
          onPressed: currentPage > 1
              ? () => context.read<HomeCubit>().changePage(1)
              : null,
          icon: const Icon(Icons.first_page, size: 16),
        ),
        // Previous page button
        IconButton(
          onPressed: currentPage > 1
              ? () => context.read<HomeCubit>().changePage(currentPage - 1)
              : null,
          icon: const Icon(Icons.arrow_back_ios, size: 16),
        ),

        // Simple pagination logic: show active page and maybe neighbors.
        // For full "1 2 3 ... 10" logic, it's more complex. Implementing simpler version
        // showing basic range or just generic buttons for now as requested "like image".
        // The image shows [ < ] [ 1 ] [ 2 ] [ 3 ] ... [ > ]
        ...List.generate(totalPages, (index) {
          final page = index + 1;
          // To prevent overflow if too many pages, limit show
          if (totalPages > 10 &&
              (page > 3 && page < totalPages - 2 && (page != currentPage))) {
            if (page == 4) return const Text(' ... ');
            return const SizedBox.shrink();
          }

          final isActive = page == currentPage;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () => context.read<HomeCubit>().changePage(page),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF0D47A1)
                      : Colors.transparent, // Dark blue for active
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

        // Next page button
        IconButton(
          onPressed: currentPage < totalPages
              ? () => context.read<HomeCubit>().changePage(currentPage + 1)
              : null,
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
        // Last page button
        IconButton(
          onPressed: currentPage < totalPages
              ? () => context.read<HomeCubit>().changePage(totalPages)
              : null,
          icon: const Icon(Icons.last_page, size: 16),
        ),
        const SizedBox(width: 16),
        Text(
          'Displaying ${(currentPage - 1) * pageSize + 1}-${(currentPage * pageSize).clamp(0, totalCount)} of $totalCount records',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(width: 16),
        // All button
        OutlinedButton(
          onPressed: () {
            // Show all records (optional feature)
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Text('All'),
        ),
      ],
    );
  }
}
