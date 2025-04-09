import 'package:flutter/material.dart';
import 'package:vet_app/services/firebase_service.dart';
import 'package:vet_app/screens/menu_screen.dart';
import 'package:vet_app/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      _isLoading = true;
    });

    // Using phone as email for simplicity
    String email = "${_phoneController.text.replaceAll(' ', '')}@example.com";
    String password = _passwordController.text;

    print('Login attempt: email=$email');

    try {
      final userCredential = await FirebaseService.signInWithEmailPassword(email, password);
      
      print('Login result: ${userCredential != null ? "Success" : "Failed"}');
      
      setState(() {
        _isLoading = false;
      });

      if (userCredential != null) {
        print('Login successful: navigating to MenuScreen');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MenuScreen()),
        );
      } else {
        print('Login failed: null userCredential');
        _showErrorDialog("Туура эмес номер же сыр сөз");
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException during login: ${e.code} - ${e.message}');
      setState(() {
        _isLoading = false;
      });
      
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "Бул номер табылган жок";
          break;
        case 'wrong-password':
          errorMessage = "Туура эмес сыр сөз";
          break;
        case 'invalid-email':
          errorMessage = "Жараксыз электрондук почта форматы";
          break;
        case 'user-disabled':
          errorMessage = "Бул аккаунт өчүрүлгөн";
          break;
        default:
          errorMessage = "Кирүү учурунда катачылык: ${e.message}";
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      print('Unexpected error during login: $e');
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog("Кирүү учурунда катачылык: $e");
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await FirebaseService.signInWithGoogle();
      
      setState(() {
        _isLoading = false;
      });

      if (userCredential != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MenuScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog("Google менен кирүү учурунда катачылык: $e");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Катачылык"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("Жабуу"),
          )
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
                    radius: 25,
                    backgroundColor: Color(0xFF4CAF50),
                    child: Image.asset('assets/cow_icon.png', width: 35),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Center(
                child: Text(
                  'Өткөрүп жиберүү',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Сиздин номериңиз',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
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
                    hintText: '996627826292',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    prefixIcon: Icon(Icons.phone, color: Colors.grey[400]),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Сыр сөз',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
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
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400]),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: Icon(
                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, 
                        color: Colors.grey[400]
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Сыр сөздү унуттуңузбу?',
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(0, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator(color: Color(0xFF4CAF50)))
                  : ElevatedButton(
                      onPressed: _signInWithEmailAndPassword,
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
                        'Кирүү', 
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey[350],
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Же', 
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey[350],
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Center(
                child: OutlinedButton(
                  onPressed: _signInWithGoogle,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/google_icon.png', height: 24),
                      SizedBox(width: 10),
                      Text('Google', style: TextStyle(color: Colors.black87)),
                    ],
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    side: BorderSide(color: Color(0xFF4CAF50).withOpacity(0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'Аккаунтуңуз жокпу? Ушул ',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    },
                    child: Text(
                      'жерден',
                      style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      ' катталыңыз',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
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