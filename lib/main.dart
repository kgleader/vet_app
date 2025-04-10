import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:vet_app/screens/welcom_screen.dart';
import 'package:vet_app/screens/flash_screen.dart';
import 'package:vet_app/screens/login_screen.dart';
import 'package:vet_app/screens/register_screen.dart';
import 'package:vet_app/screens/menu_screen.dart';
import 'package:vet_app/screens/forgot_password_screen.dart';
import 'package:vet_app/screens/forgot_password_verification_screen.dart';
import 'package:vet_app/screens/change_password_screen.dart';
import 'package:vet_app/screens/profile_screen.dart';
import 'package:vet_app/screens/profile_edit_screen.dart';
import 'package:vet_app/screens/category_screens/about_us_screen.dart';
import 'package:vet_app/screens/category_screens/toyut_screen.dart';

// Global flag for auth state
bool isAuthenticated = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables from .env file
  await dotenv.load();
  
  // We'll skip Firebase initialization for now to test UI
  print('Firebase initialization skipped for UI testing');
  
  runApp(VetMobileApp());
}

class VetMobileApp extends StatelessWidget {
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
        '/welcome': (context) => WelcomeScreen(),
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