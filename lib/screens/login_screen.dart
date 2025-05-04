import 'package:flutter/material.dart';
import 'package:vet_app/screens/menu_screen.dart';
import 'package:vet_app/screens/register_screen.dart';
import 'package:vet_app/screens/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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

    // Temporary solution to bypass Firebase login issues
    try {
      // Simulate loading
      await Future.delayed(Duration(seconds: 1));

      print('Bypassing Firebase login for testing');

      // Navigate to menu screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MenuScreen()),
      );
    } catch (e) {
      print('Error during login bypass: $e');
      _showErrorDialog("Кирүү учурунда катачылык: $e");
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

    // Temporary solution to bypass Firebase Google login issues
    try {
      // Simulate loading
      await Future.delayed(Duration(seconds: 1));

      print('Bypassing Google sign-in for testing');

      // Navigate to menu screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MenuScreen()),
      );
    } catch (e) {
      print('Error during Google sign-in bypass: $e');
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog("Google менен кирүү учурунда катачылык: $e");
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
                child: Text("Жабуу"),
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
                    hintText: '996770707070',
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
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(0, 30),
                  ),
                  child: Text(
                    'Сыр сөздү унуттуңузбу?',
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(
                    child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
                  )
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
              SizedBox(height: 30),
              Center(
                child: OutlinedButton(
                  onPressed: _signInWithGoogle,
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
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
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
              SizedBox(height: 60),
              Center(
                child: Text(
                  '© МаралАкгүл.Баардык укуктар корголгон',
                  style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
