import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      print('Firebase initialized successfully');
      
      // Print current user if logged in
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        print('User already logged in: ${currentUser.email}');
      } else {
        print('No user currently logged in');
      }
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }

  // Email/Password Sign Up
  static Future<UserCredential> signUpWithEmailPassword(String email, String password) async {
    try {
      print('Starting Firebase registration with email: $email');
      
      // Check if email is valid
      if (!email.contains('@')) {
        print('Invalid email format: $email');
        throw FirebaseAuthException(
          code: 'invalid-email',
          message: 'The email address is badly formatted.',
        );
      }
      
      // Create the user with email and password
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print('User created successfully with uid: ${userCredential.user?.uid}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error during sign up: ${e.code} - ${e.message}');
      rethrow; // Rethrow to handle in UI
    } catch (e) {
      print('Unexpected error during sign up: $e');
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  // Email/Password Sign In
  static Future<UserCredential?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Error during sign in: ${e.message}');
      return null;
    }
  }

  // Google Sign In
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Interactive sign in process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      // User canceled the sign-in flow
      if (googleUser == null) {
        return null;
      }

      // Obtain auth details from request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Create a new credential for Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      print('Error signing in with Google: $e');
      // Return null instead of propagating the error
      return null;
    }
  }

  // Sign Out
  static Future<void> signOut() async {
    try {
      // Sign out from Google if it was used
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
        print('Google sign out successful');
      }
      
      // Sign out from Firebase
      await _auth.signOut();
      print('User signed out successfully.');
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  // Get Current User
  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Update User Profile
  static Future<bool> updateUserProfile({
    required String userId, 
    required String displayName, 
    required String phoneNumber
  }) async {
    try {
      // Store additional user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'displayName': displayName,
        'phoneNumber': phoneNumber,
        'createdAt': DateTime.now(),
      });
      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }
}
