// lib/features/notifications/presentation/doctor_detail_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_thera_dashboard/features/notification/data/models/doctor_details_model.dart';
import 'package:i_thera_dashboard/features/notification/managers/doctor_details_cubit/doctor_details_cubit.dart';
import 'package:i_thera_dashboard/features/notification/managers/doctor_details_cubit/doctor_details_state.dart';

class DoctorDetailScreen extends StatefulWidget {
  final int doctorId;

  const DoctorDetailScreen({super.key, required this.doctorId});

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<DoctorDetailCubit>().loadDoctorDetails(widget.doctorId);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _showDisapproveDialog(DoctorDetailModel doctor) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'سبب الرفض',
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: _noteController,
          maxLines: 5,
          textAlign: TextAlign.right,
          decoration: const InputDecoration(
            hintText: 'اضافة',
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_noteController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('يرجى إدخال سبب الرفض'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              Navigator.pop(dialogContext);
              context.read<DoctorDetailCubit>().disapproveDoctor(
                doctor.id,
                note: _noteController.text.trim(),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('إرسال السبب'),
          ),
        ],
      ),
    );
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
      body: BlocConsumer<DoctorDetailCubit, DoctorDetailState>(
        listener: (context, state) {
          if (state is DoctorApprovalSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.isApproved ? 'تم قبول الطبيب بنجاح' : 'تم رفض الطبيب',
                ),
                backgroundColor: state.isApproved ? Colors.green : Colors.red,
              ),
            );
            Navigator.pop(
              context,
              true,
            ); // Return true to refresh notifications
          }

          if (state is DoctorDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is DoctorDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DoctorDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DoctorDetailCubit>().loadDoctorDetails(
                        widget.doctorId,
                      );
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is DoctorDetailLoaded || state is DoctorApprovalLoading) {
            final doctor = state is DoctorDetailLoaded
                ? state.doctor
                : (state as DoctorApprovalLoading);

            // Get doctor from the previous state if in loading
            DoctorDetailModel? doctorData;
            if (state is DoctorDetailLoaded) {
              doctorData = state.doctor;
            } else {
              // Try to get from bloc
              final previousState = context.read<DoctorDetailCubit>().state;
              if (previousState is DoctorDetailLoaded) {
                doctorData = previousState.doctor;
              }
            }

            if (doctorData == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final isLoading = state is DoctorApprovalLoading;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Doctor Profile Card
                  Container(
                    margin: const EdgeInsets.all(16),
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Doctor Info
                        Expanded(
                          child: Column(
                            children: [
                              _buildInfoRow('الأسم', doctorData.userName),
                              const SizedBox(height: 16),
                              _buildInfoRow('النوع', doctorData.genderText),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                'رقم الموبيل',
                                doctorData.phoneNumber,
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                'رقم الموبيل 2',
                                doctorData.phoneNumber2Display,
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow('المدينة', doctorData.cityName),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                'الإيميل',
                                doctorData.email.isEmpty
                                    ? 'غير محدد'
                                    : doctorData.email,
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                'التخصص',
                                doctorData.specializationsText,
                              ),
                              const SizedBox(height: 16),
                              if (doctorData.idImageURL != null)
                                _buildLinkRow(
                                  'صورة الكارنيه',
                                  doctorData.idImageName ?? 'اسم الصورة',
                                  url: doctorData.idImageURL,
                                ),
                              if (doctorData.idImageURL != null)
                                const SizedBox(height: 16),
                              if (doctorData.resumeURL != null)
                                _buildLinkRow(
                                  'السيرة الذاتية',
                                  doctorData.resumeName ?? 'اسم الفايل',
                                  url: doctorData.resumeURL,
                                ),
                              if (doctorData.resumeURL != null)
                                const SizedBox(height: 16),
                              _buildInfoRow(
                                'المنطقة',
                                doctorData.districtDisplay,
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                'الرقم التعريفي',
                                doctorData.identificationNumber,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),

                        // Doctor Image
                        Container(
                          width: 250,
                          height: 320,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0891B2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child:
                                doctorData.hasImage &&
                                    doctorData.displayImage.isNotEmpty
                                ? Image.network(
                                    doctorData.displayImage,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      print('Web Image error: $error');
                                      return _buildDefaultDoctorImage();
                                    },
                                  )
                                : _buildDefaultDoctorImage(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () => _showDisapproveDialog(doctorData!),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'رفض',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    context
                                        .read<DoctorDetailCubit>()
                                        .approveDoctor(doctorData!.id);
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E88E5),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'قبول',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDefaultDoctorImage() {
    return Center(
      child: Icon(
        Icons.person,
        size: 100,
        color: Colors.white.withOpacity(0.5),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildLinkRow(String label, String linkText, {String? url}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        GestureDetector(
          onTap: url != null
              ? () {
                  // TODO: Open URL - you can use url_launcher package
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Opening: $url')));
                }
              : null,
          child: Text(
            linkText,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E88E5),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
