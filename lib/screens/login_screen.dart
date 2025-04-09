import 'package:flutter/material.dart';
import 'package:vet_app/services/firebase_service.dart';
import 'package:vet_app/screens/menu_screen.dart';
import 'package:vet_app/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      _isLoading = true;
    });

    // Using phone as email for simplicity
    String email = "${_phoneController.text.replaceAll(' ', '')}@example.com";
    String password = _passwordController.text;

    try {
      final userCredential = await FirebaseService.signInWithEmailPassword(email, password);
      
      setState(() {
        _isLoading = false;
      });

      if (userCredential != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MenuScreen()),
        );
      } else {
        _showErrorDialog("Туура эмес номер же сыр сөз");
      }
    } catch (e) {
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
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Spacer(),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFF4CAF50),
                    child: Image.asset('assets/cow_icon.png', width: 35),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Өтөйгөн жиберүү',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text('Сиздин номериңиз'),
              SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: '+996 779270023',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  prefixIcon: Icon(Icons.phone, color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              Text('Сыр сөз'),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '••••••••••',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.grey),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Сыр сөздү унуттуңузбу?',
                    style: TextStyle(color: Color(0xFF4CAF50)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _signInWithEmailAndPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('Же', style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 20),
              OutlinedButton(
                onPressed: _signInWithGoogle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/google_icon.png', height: 24),
                    SizedBox(width: 10),
                    Text('Google', style: TextStyle(color: Colors.black87)),
                  ],
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Аккаунтуңуз жокпу?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    },
                    child: Text('Катталуу', style: TextStyle(color: Color(0xFF4CAF50))),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  '© Колдонуучу келишим жана шарттары',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}