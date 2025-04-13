import 'package:flutter/material.dart';
import 'package:vet_app/screens/category_screens/about_us_screen.dart';
import 'package:vet_app/screens/category_screens/toyut_screen.dart';
import 'package:vet_app/screens/profile_screen.dart';

class CategoryPage extends StatelessWidget {
  final String title;
  final String iconPath;

  const CategoryPage({super.key, required this.title, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF4CAF50)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF4CAF50),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(
                  'assets/cow_icon.png', // Ensure path is correct
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              color: Color(0xFF4CAF50),
              width: 80,
              height: 80,
            ),
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
  final List<Map<String, String>> categories = [
  {'title': 'Биз жөнүндө', 'icon': 'assets/info.png'},
  {'title': 'Тоют', 'icon': 'assets/grass.png'},
  {'title': 'Уруктандыруу', 'icon': 'assets/male.png'},
  {'title': 'Оору', 'icon': 'assets/vaccines.png'},
  {'title': 'Бодо мал', 'icon': 'assets/cow.png'},
  {'title': 'Кой эчкилер', 'icon': 'assets/goat.png'},
  {'title': 'Жылкылар', 'icon': 'assets/horse.png'},
  {'title': 'Тоок', 'icon': 'assets/chicken.png'},
];

  MenuScreen({super.key});

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
        title: Text(
          'Меню',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF4CAF50),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(
                  'assets/cow_icon.png',
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 30,  
                    childAspectRatio: 0.9,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return _buildMenuItem(
                      context,
                      categories[index]['title']!,
                      categories[index]['icon']!,
                    );
                  },
                ),
              ),
            ),
            _buildBottomNavigationBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, String iconPath) {
    return GestureDetector(
      onTap: () {
        if (title == 'Биз жөнүндө') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AboutUsScreen()),
          );
        } else if (title == 'Тоют') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ToyutScreen()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryPage(title: title, iconPath: iconPath),
            ),
          );
        }
      },
      child: Container(
        width: 135,
        height: 135,
        decoration: BoxDecoration(
          color: Color(0xFF00A651),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              margin: EdgeInsets.only(top: 12),
              child: Image.asset(
                iconPath,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.home_outlined,
              color: Color(0xFF4CAF50),
              size: 32,
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigate to news or articles page
            },
            child: Icon(
              Icons.article_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            child: Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}