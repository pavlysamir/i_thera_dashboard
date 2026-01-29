import 'package:flutter/material.dart';
import 'package:i_thera_dashboard/features/notification/data/models/doctor_details_model.dart';

class DoctorInfoCard extends StatelessWidget {
  final DoctorDetailModel doctor;

  const DoctorInfoCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side - Information Grid
            Expanded(
              child: Column(
                children: [
                  // Row 1
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          'عدد اللقاءات',
                          '${doctor.cancelledBookings}',
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem('النوع', doctor.genderText),
                      ),
                      Expanded(child: _buildInfoItem('الاسم', doctor.userName)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Row 2
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          'عدد الحالات المكتملة',
                          '${doctor.completedBookings}',
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem('المدينة', doctor.cityName),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          'رقم الموبيل',
                          doctor.phoneNumber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Row 3
                  Row(
                    children: [
                      Expanded(
                        child: _buildRatingItem(
                          'التقييم',
                          doctor.averageRating,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          'المنطقة',
                          doctor.specializationsText,
                        ),
                      ),
                      Expanded(child: _buildInfoItem('الايميل', doctor.email)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Row 4
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      Expanded(
                        child: _buildInfoItem(
                          'التخصص',
                          doctor.specializationsText,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          'الرقم التعريفي',
                          '243',
                          isLink: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            // Right side - Profile Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 250,
                height: 300,
                color: Colors.blue,
                child: doctor.hasImage
                    ? Image.network(
                        doctor.doctorImage ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildDefaultAvatar(),
                      )
                    : _buildDefaultAvatar(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.blue.shade300,
      child: const Center(
        child: Icon(Icons.person, size: 100, color: Colors.white),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {bool isLink = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isLink ? Colors.blue : Colors.black87,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildRatingItem(String label, num rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '(${rating.toStringAsFixed(1)})',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(width: 4),
            ...List.generate(
              5,
              (index) => const Icon(Icons.star, color: Colors.amber, size: 18),
            ),
          ],
        ),
      ],
    );
  }
}
