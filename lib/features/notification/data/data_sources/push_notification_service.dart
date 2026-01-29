import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:i_thera_dashboard/core/network/api_endpoints.dart';

class PushNotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Dio _dio = Dio();

  // TODO: Replace with your actual FCM Server Key from Firebase Console -> Project Settings -> Cloud Messaging
  static const String _serverKey = 'YOUR_FCM_SERVER_KEY_HERE';

  Future<void> sendNotificationToDoctor(
    int? notificationType,
    int? doctorId,
    int? notificationId,
  ) async {
    try {
      if (doctorId == null) {
        log('Error: Doctor ID is null in notification');
        return;
      }

      // 1. Get FCM Token from Firestore
      final String? fcmToken = await _getDoctorFcmToken(doctorId!);

      if (fcmToken == null || fcmToken.isEmpty) {
        log('Error: FCM token not found for doctor $doctorId');
        return;
      }

      // 2. Prepare Notification Content based on type
      String title = 'New Notification';
      String body = 'You have a new update';

      switch (notificationType) {
        case -1: // Request for doctor join
          title = 'تحديث طلب الانضمام';
          body = 'تم رفض طلبك للانضمام';
          break;
        case 0: // Request for doctor join
          title = 'تحديث طلب الانضمام';
          body = 'تم قبول طلبك للانضمام بنجاح🎉';
          break;
        case 1: // Add money
          title = 'تحديث المحفظة';
          body = 'تم اضافه المبلغ بنجاح الي محفظتك';
          break;
        case 3: // Return money
          title = 'تحديث المحفظة';
          body = 'تم استرداد المبلغ بنجاح';
          break;
        default:
          // Keep default generic message
          break;
      }

      // 3. Send FCM Notification
      await _sendFcmMessage(
        token: fcmToken,
        title: title,
        body: body,
        data: {
          'type': notificationType.toString(),
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': notificationId.toString(),
        },
      );

      log('Notification sent successfully to token: $fcmToken');
    } catch (e) {
      log('Error sending notification: $e');
    }
  }

  Future<String?> _getDoctorFcmToken(int doctorId) async {
    try {
      // Access collection 'users', document 'doctorId' (assuming doctorId is used as document ID string)
      // Note: Verify if doctorId matches the document ID format exactly (e.g. is it just the string of the int?)
      final docSnapshot = await _firestore
          .collection('users')
          .doc(doctorId.toString())
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data.containsKey('fcmToken')) {
          return data['fcmToken'] as String?;
        }
      }
      return null;
    } catch (e) {
      log('Error fetching FCM token from Firestore: $e');
      return null;
    }
  }

  Future<void> _sendFcmMessage({
    required String token,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$_serverKey',
    };

    final payload = {
      'to': token,
      'notification': {'title': title, 'body': body, 'sound': 'default'},
      'data': data,
    };

    try {
      final response = await _dio.post(
        ApiEndpoints.fcmSend,
        options: Options(headers: headers),
        data: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        log('FCM response: ${response.data}');
      } else {
        log(
          'FCM call failed: ${response.statusCode} - ${response.statusMessage}',
        );
      }
    } catch (e) {
      log('Dio error calling FCM: $e');
      rethrow;
    }
  }
}
