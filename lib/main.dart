import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vet_app/screens/flash_screen.dart';
import 'package:vet_app/screens/login_screen.dart';
import 'package:vet_app/screens/register_screen.dart';
import 'package:vet_app/screens/menu_screen.dart';
import 'package:vet_app/screens/forgot_password_screen.dart';
import 'package:vet_app/screens/change_password_screen.dart';
import 'package:vet_app/screens/profile_screen.dart';
import 'package:vet_app/screens/category_screens/about_us_screen.dart';
import 'package:vet_app/screens/category_screens/toyut_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
        appId: dotenv.env['FIREBASE_APP_ID'] ?? '',
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
        projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '',
      ),
    );
    print('Firebase initialized successfully with credentials from .env file');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  // Force sign out any current user at app startup for testing
  try {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      print('Signing out user at startup: ${currentUser.email}');
      await FirebaseAuth.instance.signOut();
      print('User signed out successfully at app startup');
    }
  } catch (e) {
    print('Error signing out at startup: $e');
  }

  runApp(VetMobileApp());
}

class VetMobileApp extends StatelessWidget {
  const VetMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vet Mobile App',
      theme: ThemeData(
        primaryColor: Color(0xFF4CAF50),
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF4CAF50)),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF4CAF50)),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => FlashScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/menu': (context) => MenuScreen(),
        '/forgot_password': (context) => ForgotPasswordScreen(),
        '/change_password': (context) => ChangePasswordScreen(),
        '/profile': (context) => ProfileScreen(),
        '/about_us': (context) => AboutUsScreen(),
        '/toyut': (context) => ToyutScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}