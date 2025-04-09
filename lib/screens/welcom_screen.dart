import 'package:flutter/material.dart';
import 'package:vet_app/screens/login_screen.dart';
import 'package:vet_app/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check if user is signed in
    final currentUser = FirebaseAuth.instance.currentUser;
    final bool isUserSignedIn = currentUser != null;
    
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFF4CAF50),
              child: Image.asset('assets/cow_icon.png', width: 60),
            ),
            SizedBox(height: 40),
            Text(
              'Кош келдиңиз!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4CAF50),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Мал жандыгыңызды асыроону биз менен баштаңыз.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
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
                'Баштоо', 
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // Add debug sign out button if user is signed in
            if (isUserSignedIn)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      print('Signing out current user: ${currentUser.email}');
                      await FirebaseService.signOut();
                      
                      // Show a snackbar to confirm sign-out
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Колдонуучу чыгып кетти'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'OK',
                            textColor: Colors.white,
                            onPressed: () {},
                          ),
                        ),
                      );
                      
                      // Force refresh the page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomeScreen()),
                      );
                      
                      print('Sign out successful');
                    } catch (e) {
                      print('Error signing out: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Катталуу учурунда катачылык: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: Size(double.infinity, 40),
                  ),
                  child: Text('Чыгуу (Sign Out)', style: TextStyle(color: Colors.white)),
                ),
              ),
            Expanded(
              child: Image.asset(
                'assets/cow.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}