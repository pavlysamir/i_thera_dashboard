import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_thera_dashboard/features/patients/data/models/patient_model.dart';
import 'package:i_thera_dashboard/features/patients/manager/patient_detail_cubit.dart';
import 'package:i_thera_dashboard/features/patients/manager/patient_detail_state.dart';

class PatientDetailsScreen extends StatefulWidget {
  final PatientModel patient;

  const PatientDetailsScreen({super.key, required this.patient});

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF1E88E5)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<PatientDetailCubit, PatientDetailState>(
        listener: (context, state) {
          if (state is PatientApprovalSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إيقاف المريض بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true); // Return true to refresh
          } else if (state is PatientDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is PatientApprovalLoading;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side: Stop Action
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'الوقف',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const Divider(height: 32),
                          TextField(
                            controller: _noteController,
                            maxLines: 5,
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              hintText: 'اضافة',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Cairo',
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (_noteController.text.trim().isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'يرجى إدخال سبب الوقف',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }
                                      context
                                          .read<PatientDetailCubit>()
                                          .suspendPatient(
                                            widget.patient.id,
                                            note: _noteController.text.trim(),
                                          );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF44336), 
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'وقف',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 24),

                  // Right Side: Patient Info
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoItem(
                                  'الرقم التعريفي',
                                  widget.patient.id.toString(),
                                  isLink: true,
                                ),
                              ),
                              Expanded(
                                child: _buildInfoItem(
                                  'الأسم',
                                  widget.patient.userName,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoItem(
                                  'النوع',
                                  widget.patient.gender == 1 ? 'ذكر' : 'أنثى',
                                ),
                              ),
                              Expanded(
                                child: _buildInfoItem(
                                  'المنطقة',
                                  widget.patient.regionName ?? 'غير محدد',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoItem(
                                  'المدينة',
                                  widget.patient.cityName,
                                ),
                              ),
                              Expanded(
                                child: _buildInfoItem(
                                  'رقم الموبيل',
                                  widget.patient.phoneNumber,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Email takes full width
                          _buildInfoItem(
                            'الأيميل',
                            widget.patient.email.isNotEmpty
                                ? widget.patient.email
                                : 'غير محدد',
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoItem(
                                  'عدد الحالات المكتملة',
                                  widget.patient.completedBookings.toString(),
                                ),
                              ),
                              Expanded(
                                child: _buildInfoItem(
                                  'عدد الإلغاءات',
                                  widget.patient.cancelledBookings.toString(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {bool isLink = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
            color: isLink ? const Color(0xFF1E88E5) : Colors.black87,
            decoration: isLink ? TextDecoration.underline : null,
          ),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
