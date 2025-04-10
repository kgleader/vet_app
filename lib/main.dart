import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vet_app/screens/welcom_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBYG2XMN3GZpRCW8CnO_FYpiVQhQmh-wRo",
        appId: "1:844985684683:android:fc45a7b4b835f0db9c26f0",
        messagingSenderId: "844985684683",
        projectId: "vet-app-38590",
        storageBucket: "vet-app-38590.appspot.com",
      ),
    );
    print('Firebase initialized successfully with explicit options');
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vet Mobile App',
      theme: ThemeData(
        primaryColor: Color(0xFF4CAF50),
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF4CAF50)),
        useMaterial3: true,
      ),
      home: WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}