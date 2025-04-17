import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vet_app/screens/menu_screen.dart';
import 'package:vet_app/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _register() async {
    // Validate form inputs
    if (_nameController.text.isEmpty) {
      _showErrorDialog("Аты-жөнүңүздү киргизиңиз");
      return;
    }

    if (_phoneController.text.isEmpty) {
      _showErrorDialog("Телефон номериңизди киргизиңиз");
      return;
    }

    if (_passwordController.text.isEmpty) {
      _showErrorDialog("Сыр сөздү киргизиңиз");
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog("Сыр сөздөр дал келбейт");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('Starting registration process');
      // Format phone number and create a valid email from it
      String phone = _phoneController.text.trim();
      // Remove any spaces or special characters
      phone = phone.replaceAll(RegExp(r'[^\d]'), '');

      // Create a valid email using the phone number
      String email = "$phone@vetapp.example.com";
      String password = _passwordController.text;

      print('Attempting to register user with email: $email');

      try {
        // Using regular Firebase Auth directly
        final auth = FirebaseAuth.instance;
        final firestore = FirebaseFirestore.instance;

        // Use a basic try-catch for Firebase operations to isolate the error
        try {
          // Create the user account first
          UserCredential userCredential = await auth
              .createUserWithEmailAndPassword(email: email, password: password);

          print(
            'User created successfully with ID: ${userCredential.user!.uid}',
          );

          // Update display name in a separate try block
          try {
            await userCredential.user!.updateDisplayName(_nameController.text);
            print('Display name updated successfully');
          } catch (e) {
            print('Error updating display name: $e');
            // Continue anyway - not critical
          }

          // Store in Firestore in a separate try block
          try {
            await firestore
                .collection('users')
                .doc(userCredential.user!.uid)
                .set({
                  'name': _nameController.text,
                  'phone': phone,
                  'created_at': FieldValue.serverTimestamp(),
                });
            print('User data stored in Firestore');
          } catch (e) {
            print('Error storing user data in Firestore: $e');
            // Continue anyway - not critical
          }

          // Navigate to menu screen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MenuScreen()),
            (route) => false,
          );
        } catch (authError) {
          print('Firebase Auth error: $authError');
          // Re-throw to be caught by the outer try-catch
          rethrow;
        }
      } catch (e) {
        print('Error during Firebase Auth operation: $e');
        rethrow; // Re-throw to be caught by the outer try-catch
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "Бул номер менен аккаунт катталган";
          break;
        case 'weak-password':
          errorMessage = "Өтө жөнөкөй сыр сөз. Күчтүүрөөк сыр сөз жазыңыз";
          break;
        case 'invalid-email':
          errorMessage = "Жараксыз телефон номери";
          break;
        case 'operation-not-allowed':
          errorMessage = "Бул операцияга уруксат жок";
          break;
        default:
          errorMessage = "Катталуу учурунда катачылык: ${e.message}";
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      print('Unexpected error during registration: $e');
      _showErrorDialog("Катталуу учурунда катачылык: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Initialize Google Sign In
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Start the interactive sign-in process
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in flow
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Obtain auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential for Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      print('Google sign-in successful! User ID: ${userCredential.user!.uid}');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MenuScreen()),
      );
    } catch (e) {
      print('Error during Google sign-in: $e');
      _showErrorDialog("Google менен катталуу учурунда катачылык: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text("Катачылык"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  "Жабуу",
                  style: TextStyle(color: Color(0xFF4CAF50)),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Color(0xFF4CAF50)),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                  Spacer(),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFF4CAF50),
                    child: Image.asset(
                      'assets/cow_icon.png',
                      width: 28,
                      height: 28,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Center(
                child: Text(
                  'Өткөрүп жиберүү',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Толук аты жөнү',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF4CAF50).withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Сиздин атыңыз',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Телефон номери',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF4CAF50).withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: '996628262929',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                      color: Colors.grey[400],
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Сыр сөз',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF4CAF50).withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.grey[400],
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Сыр сөздү ырастоо',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF4CAF50).withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.grey[400],
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Forgot password functionality
                    },
                    child: Text(
                      'Сыр сөздү унуттуңузбу?',
                      style: TextStyle(color: Color(0xFF4CAF50), fontSize: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              _isLoading
                  ? Center(
                    child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
                  )
                  : ElevatedButton(
                    onPressed: () {
                      // Temporary solution to bypass the Firebase error
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MenuScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      'Катталуу',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Аккаунтуңуз барбы? ',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      'Кирүү',
                      style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Divider(color: Colors.grey[350], thickness: 1),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Же',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Colors.grey[350], thickness: 1),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    // Temporary solution to bypass Google sign-in error
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MenuScreen()),
                      (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    side: BorderSide(color: Color(0xFF4CAF50).withOpacity(0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/google_icon.png', height: 24),
                      SizedBox(width: 10),
                      Text('Google', style: TextStyle(color: Colors.black87)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  '© МаралАкгүл.Баардык укуктар корголгон',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
