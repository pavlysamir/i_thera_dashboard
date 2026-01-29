import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_thera_dashboard/features/doctor_details/data/data_sources/doctor_details_remote_data_source.dart';
import 'package:i_thera_dashboard/features/doctor_details/data/repositories/doctor_details_repo_impl.dart';
import 'package:i_thera_dashboard/features/doctor_details/managers/cubit/doctor_details_cubit.dart';
import 'package:i_thera_dashboard/features/doctor_details/managers/cubit/doctor_details_state.dart';
import 'package:i_thera_dashboard/features/doctor_details/presentation/widgets/doctor_info_card.dart';
import 'package:i_thera_dashboard/features/doctor_details/presentation/widgets/suspension_section.dart';
import 'package:i_thera_dashboard/features/doctor_details/presentation/widgets/financial_account_section.dart';
import 'package:i_thera_dashboard/features/doctor_details/presentation/widgets/wallet_section.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final int doctorId;

  const DoctorDetailsScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return DoctorDetailsCubit(
          repository: DoctorDetailsRepositoryImpl(
            remoteDataSource: DoctorDetailsRemoteDataSourceImpl(),
          ),
        )..initDoctorDetails(doctorId);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تفاصيل الطبيب'),
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocConsumer<DoctorDetailsCubit, DoctorDetailsState>(
          listener: (context, state) {
            if (state is DoctorDetailsBalanceAddedSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is DoctorDetailsApproveSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.isApproved ? 'تم تفعيل الطبيب' : 'تم إيقاف الطبيب',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is DoctorDetailsActionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is DoctorDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DoctorDetailsError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is DoctorDetailsLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top section - Doctor Info Card
                    DoctorInfoCard(doctor: state.doctor),
                    const SizedBox(height: 16),
                    // Bottom section - Three columns
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left column - Suspension
                        Expanded(
                          flex: 1,
                          child: SuspensionSection(doctor: state.doctor),
                        ),
                        const SizedBox(width: 16),
                        // Middle column - Financial Account
                        Expanded(
                          flex: 2,
                          child: FinancialAccountSection(
                            doctorId: state.doctor.id,
                            transactions: state.transactions,
                            hasReachedMax: state.hasReachedMax,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Right column - Wallet Info
                        Expanded(
                          flex: 1,
                          child: WalletInfoSection(
                            currentBalance: state.doctor.currentBalance,
                            frozenBalance:
                                state.doctor.frozenBalance ??
                                0, // Replace with actual data from model
                            withdrawnBalance: state
                                .doctor
                                .detectedBalance, // Replace with actual data from model
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
