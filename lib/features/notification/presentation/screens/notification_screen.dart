import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_thera_dashboard/core/di/service_locator.dart';
import 'package:i_thera_dashboard/features/notification/data/models/notification_model.dart';
import 'package:i_thera_dashboard/features/notification/managers/cubit/notification_cubit.dart';
import 'package:i_thera_dashboard/features/notification/managers/cubit/notification_state.dart';
import 'package:i_thera_dashboard/features/notification/managers/doctor_details_cubit/doctor_details_cubit.dart';
import 'package:i_thera_dashboard/features/notification/managers/wallet_request_cubit/cubit/wallet_request_cubit.dart';
import 'package:i_thera_dashboard/features/notification/presentation/screens/doctors_details_screen.dart';
import 'package:i_thera_dashboard/features/notification/presentation/screens/wallet_request_screen.dart';
import 'package:i_thera_dashboard/features/notification/presentation/widgets/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'الإشعارات',
          style: TextStyle(
            color: Color(0xFF1E88E5),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF1E88E5)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationsError) {
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
                      context.read<NotificationsCubit>().loadNotifications();
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is NotificationsLoaded) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return const Center(
                child: Text(
                  'لا توجد إشعارات',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return NotificationItem(
                  notification: notifications[index],
                  onTap: () {
                    // Handle notification tap
                    _handleNotificationTap(notifications[index]);
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  // Update the _handleNotificationTap method in notifications_screen.dart
  void _handleNotificationTap(NotificationModel notification) async {
    switch (notification.type) {
      case 0: // Join request
        if (notification.doctorId != null) {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => DoctorDetailCubit(
                  notificationsRepository: sl(),
                  pushNotificationService: sl(),
                ),
                child: DoctorDetailScreen(doctorId: notification.doctorId!),
              ),
            ),
          );

          if (result == true && mounted) {
            context.read<NotificationsCubit>().loadNotifications();
          }
        }
        break;

      case 1: // Payment request (add money)
      case 3: // Refund request
        if (notification.doctorId != null &&
            notification.walletRequestId != null) {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => WalletRequestCubit(
                  notificationsRepository: sl(),
                  pushNotificationService: sl(),
                ),
                child: WalletRequestScreen(
                  doctorId: notification.doctorId!,
                  walletRequestId: notification.walletRequestId!,
                ),
              ),
            ),
          );

          if (result == true && mounted) {
            context.read<NotificationsCubit>().loadNotifications();
          }
        }
        break;

      default:
        break;
    }
  }
}
