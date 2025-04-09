import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vet_app/services/firebase_service.dart';
import 'package:vet_app/screens/welcom_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initializeFirebase();
  
  // Force sign out any current user at app startup for testing
  try {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      print('Signing out user at startup: ${currentUser.email}');
      await FirebaseService.signOut();
      print('User signed out successfully at app startup');
    }
  } catch (e) {
    print('Error signing out at startup: $e');
  }
  
  runApp(VetMobileApp());
}

class VetMobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vet Mobile App',
      theme: ThemeData(
        primaryColor: Color(0xFF4CAF50),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF4CAF50),
          secondary: Color(0xFF8BC34A),
        ),
      ),
      home: WelcomeScreen(),
    );
  }
}