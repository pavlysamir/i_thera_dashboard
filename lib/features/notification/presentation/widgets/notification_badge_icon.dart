import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_thera_dashboard/core/di/service_locator.dart';
import 'package:i_thera_dashboard/features/notification/managers/cubit/notification_cubit.dart';
import 'package:i_thera_dashboard/features/notification/managers/cubit/notification_state.dart';
import 'package:i_thera_dashboard/features/notification/presentation/screens/notification_screen.dart';

class NotificationBadgeIcon extends StatefulWidget {
  const NotificationBadgeIcon({super.key});

  @override
  State<NotificationBadgeIcon> createState() => _NotificationBadgeIconState();
}

class _NotificationBadgeIconState extends State<NotificationBadgeIcon> {
  late final NotificationsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<NotificationsCubit>();
    _cubit.getUnseenCount();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _openNotificationsScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _cubit,
          child: const NotificationsScreen(),
        ),
      ),
    );

    if (mounted) {
      _cubit.getUnseenCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      bloc: _cubit,
      builder: (context, state) {
        final count = _cubit.unseenCount;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.blue),
                onPressed: _openNotificationsScreen,
              ),
            ),
            if (count > 0)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Center(
                    child: Text(
                      count > 99 ? '99+' : '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
