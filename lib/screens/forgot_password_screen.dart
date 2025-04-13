import 'package:flutter/material.dart';
import 'package:vet_app/screens/forgot_password_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendResetCode() async {
    if (_phoneController.text.isEmpty) {
      _showErrorDialog("Телефон номериңизди киргизиңиз");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate network call
      await Future.delayed(Duration(seconds: 1));
      
      // For demo purposes, we'll just navigate to the verification screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotPasswordVerificationScreen(
            phoneNumber: _phoneController.text,
          ),
        ),
      );
    } catch (e) {
      _showErrorDialog("Сыр сөздү калыбына келтирүү учурунда катачылык");
    } finally {
      setState(() {
        _isLoading = false;
      });
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
            child: Text("Жабуу", style: TextStyle(color: Color(0xFF4CAF50))),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.0),
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
                      child: Image.asset('assets/cow_icon.png', width: 30, height: 30),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Center(
                  child: Text(
                    'Сыр сөздү калыбына келтирүү',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Сиздин түпнуска катталган телефон номериңизге сыр сөздү калыбына келтирүү кодун жөнөтөбүз.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF4CAF50).withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: '996XXXXXXXXX',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                SizedBox(height: 24),
                _isLoading
                    ? Center(child: CircularProgressIndicator(color: Color(0xFF4CAF50)))
                    : ElevatedButton(
                        onPressed: _sendResetCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4CAF50),
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          'Жөнөтүү',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Артка кайтуу',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
