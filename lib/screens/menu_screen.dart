import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final String title;
  final IconData icon;

  CategoryPage({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(title, style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Color(0xFF4CAF50)),
            SizedBox(height: 20),
            Text(
              'Категория: $title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Бул бөлүмдө маалымат жакында кошулат',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Меню', style: TextStyle(color: Colors.black)),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.person_outline, color: Colors.grey),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuItem(context, 'Биз жөнүндө', Icons.description),
                  _buildMenuItem(context, 'Тоют', Icons.grass),
                  _buildMenuItem(context, 'Уруктандыруу', Icons.favorite),
                  _buildMenuItem(context, 'Оору', Icons.medical_services),
                  _buildMenuItem(context, 'Бодо мал', Icons.pets),
                  _buildMenuItem(context, 'Кой эчкилер', Icons.pets),
                  _buildMenuItem(context, 'Жылкылар', Icons.pets),
                  _buildMenuItem(context, 'Тоок', Icons.pets),
                ],
              ),
            ),
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData iconData) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryPage(title: title, icon: iconData),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF4CAF50),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, color: Colors.white, size: 40),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.description, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.phone, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}