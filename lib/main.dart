import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_thera_dashboard/core/helpers/simple_bloc_observer.dart';
import 'package:i_thera_dashboard/firebase_options.dart';
import 'core/cashe/cache_helper.dart';
import 'core/di/service_locator.dart' as di;
import 'core/network/dio_helper.dart';
import 'features/auth/presentation/pages/login_page.dart';
// import 'firebase_options.dart'; // Uncomment when firebase_options.dart is generated

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Initialize Networking
  DioHelper.init();

  // Initialize Cache
  await CacheHelper.init();

  // Initialize Dependency Injection
  await di.init();

  // Initialize Firebase
  // For Web, options are required. Providing a robust try-catch block or placeholder.
  try {
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    // For now, assume user needs to run flutterfire configure.
    // We will initialize it without options if possible (works on mobile sometimes) or commented out.
    // The user requirement says "Configure Firebase for Web".
    // Since I cannot generate the config keys, I'll leave the call but commented with instructions.

    // Placeholder for FCM
    // final fcm = FirebaseMessaging.instance;
    // await fcm.requestPermission();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'i-Thera Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Cairo', // Assuming Cairo font based on Arabic design
      ),
      home: const LoginPage(),
    );
  }
}
