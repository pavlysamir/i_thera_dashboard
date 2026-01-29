import 'package:flutter/material.dart';
import 'package:i_thera_dashboard/features/doctor_details/managers/cubit/doctor_details_cubit.dart';
import 'package:i_thera_dashboard/features/notification/data/models/doctor_details_model.dart';

/// Widget for the Suspension (الوقف) section
class SuspensionSection extends StatefulWidget {
  final DoctorDetailModel doctor;

  const SuspensionSection({super.key, required this.doctor});

  @override
  State<SuspensionSection> createState() => _SuspensionSectionState();
}

class _SuspensionSectionState extends State<SuspensionSection> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الوقف',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _noteController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'اضافة',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.doctor.isApproved
                      ? Colors.red
                      : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  final isApproving = !widget.doctor.isApproved;
                  DoctorDetailsCubit.get(context).approveOrDisapprove(
                    doctorId: widget.doctor.id,
                    userId: widget.doctor.id,
                    role: 1,
                    isApproved: isApproving,
                  );
                },
                child: Text(
                  widget.doctor.isApproved ? 'وقف' : 'تفعيل',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
