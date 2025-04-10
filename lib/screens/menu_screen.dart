import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryPage extends StatelessWidget {
  final String title;
  final String iconPath;

  CategoryPage({required this.title, required this.iconPath});

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
        title: Text(title, style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              colorFilter: ColorFilter.mode(Color(0xFF4CAF50), BlendMode.srcIn),
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
    {'title': 'Биз жөнүндө', 'icon': 'assets/icons/about_us.svg'},
    {'title': 'Тоют', 'icon': 'assets/icons/grass.svg'},
    {'title': 'Уруктандыруу', 'icon': 'assets/icons/male.svg'},
    {'title': 'Оору', 'icon': 'assets/icons/vaccines.svg'},
    {'title': 'Бодо мал', 'icon': 'assets/icons/cow.svg'},
    {'title': 'Кой эчкилер', 'icon': 'assets/icons/goat.svg'},
    {'title': 'Жылкылар', 'icon': 'assets/icons/horse.svg'},
    {'title': 'Тоок', 'icon': 'assets/icons/chicken.svg'},
  ];

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
            child: CircleAvatar(
              backgroundColor: Color(0xFF4CAF50),
              radius: 18,
              child: Image.asset('assets/cow_icon.png', width: 24, height: 24),
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
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
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
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, String iconPath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryPage(title: title, iconPath: iconPath),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF4CAF50),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                iconPath,
                colorFilter: ColorFilter.mode(Color(0xFF4CAF50), BlendMode.srcIn),
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 80,
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
              size: 26,
            ),
          ),
          Icon(
            Icons.article_outlined,
            color: Colors.white,
            size: 26,
          ),
          Icon(
            Icons.person_outline,
            color: Colors.white,
            size: 26,
          ),
        ],
      ),
    );
  }
}