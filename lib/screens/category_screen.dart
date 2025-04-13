import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final String title;
  final String iconPath;

  const CategoryScreen({
    super.key,
    required this.title,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF4CAF50)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(title, style: TextStyle(color: Colors.black, fontSize: 20)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Color(0xFF4CAF50),
              radius: 18,
              child: Image.asset('assets/cow_icon.png', width: 24, height: 24),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: Image.asset(
                iconPath,
                color: Color(0xFF4CAF50),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Категория: $title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Бул бөлүмдө маалымат жакында кошулат',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
