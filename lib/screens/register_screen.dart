import 'package:flutter/material.dart';
import 'package:vet_app/services/firebase_service.dart';
import 'package:vet_app/screens/menu_screen.dart';
import 'package:vet_app/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog("Сыр сөздөр дал келбейт");
      return;
    }

    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      _showErrorDialog("Бардык талааларды толтуруңуз");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Using phone as email for simplicity
    String email = "${_phoneController.text.replaceAll(' ', '')}@example.com";
    String password = _passwordController.text;

    try {
      final userCredential = await FirebaseService.signUpWithEmailPassword(email, password);
      
      setState(() {
        _isLoading = false;
      });

      if (userCredential != null) {
        // Successfully registered, now navigate to menu screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MenuScreen()),
        );
      } else {
        _showErrorDialog("Катталуу учурунда катачылык");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog("Катталуу учурунда катачылык: $e");
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
              Text('Толук аты жөнү'),
              SizedBox(height: 10),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Толук аты жөнү',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              Text('Телефон номери'),
              SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: '+996 ••• •• ••',
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
              SizedBox(height: 20),
              Text('Сыр сөздү ырастоо'),
              SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
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
              SizedBox(height: 30),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _register,
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
                        'Катталуу', 
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Катталып жатканыңыз менен Биз жөнүндө келишим',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
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