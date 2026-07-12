import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:i_thera_dashboard/core/network/api_endpoints.dart';
import 'package:i_thera_dashboard/core/network/dio_helper.dart';

class PushNotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendNotificationToDoctor(
    int? notificationType,
    int? doctorId,
    int? notificationId, {
    int? approvalStatus,
  }) async {
    try {
      if (doctorId == null) {
        log('Error: Doctor ID is null in notification');
        return;
      }

      // 1. Get FCM Token from Firestore
      final String? fcmToken = await _getDoctorFcmToken(doctorId);

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
          body =
              '\nالآن يمكنك تسجيل الدخول فى اى وقت ☺️\nتم قبول طلبك للأنضمام بنجاح ✅';
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

      // 3. Send Notification using new API
      await _sendNotificationUsingApi(
        token: fcmToken,
        title: title,
        body: body,
        approvalStatus: approvalStatus,
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

  Future<void> _sendNotificationUsingApi({
    required String token,
    required String title,
    required String body,
    int? approvalStatus,
  }) async {
    final payload = {
      "title": title,
      "body": body,
      "deviceToken": token,
      "approvalStatus": approvalStatus,
    };

    try {
      final response = await DioHelper.postData(
        url: ApiEndpoints.sendNotificationAsync,
        data: payload,
      );

      if (response.statusCode == 200) {
        log('Notification API response: ${response.data}');
      } else {
        log(
          'Notification API call failed: ${response.statusCode} - ${response.statusMessage}',
        );
      }
    } catch (e) {
      log('Error calling Notification API: $e');
      rethrow;
    }
  }
}
