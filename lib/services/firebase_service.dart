import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  // Email/Password Sign Up
  static Future<UserCredential?> signUpWithEmailPassword(String email, String password) async {
    try {
      // First check if the email is already in use
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      if (methods.isNotEmpty) {
        print('Email already in use: $email');
        return null;
      }
      
      // Create the user with email and password
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update the user profile with display name if needed
      // await userCredential.user?.updateDisplayName(displayName);
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error during sign up: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Unexpected error during sign up: $e');
      return null;
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
    await _googleSignIn.signOut();
    await _auth.signOut();
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
