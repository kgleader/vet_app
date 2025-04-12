import 'package:flutter/material.dart';
import 'package:vet_app/screens/profile_edit_screen.dart';

class ProfileScreen extends StatelessWidget {
  // Sample user data - in a real app, this would come from a user profile service
  final Map<String, String> userData = {
    'name': 'Алдияров Мыйзам Тургуналиевич',
    'email': 'aldiyarov@gmail.com',
    'phone': '0770699999',
    'location': 'Бишкек',
  };

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
          'Профайл', 
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header with avatar
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/profile_placeholder.png'),
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    userData['name']!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'ID: 00000',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            // Contact information
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoItem(
                    icon: Icons.email_outlined,
                    label: userData['email']!,
                  ),
                  SizedBox(height: 16),
                  _buildInfoItem(
                    icon: Icons.phone_outlined,
                    label: userData['phone']!,
                  ),
                  SizedBox(height: 16),
                  _buildInfoItem(
                    icon: Icons.location_on_outlined,
                    label: userData['location']!,
                  ),
                  SizedBox(height: 30),
                  // Edit profile button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileEditScreen(userData: userData),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Өзгөртүү',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Green area for additional settings/features
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              color: Color(0xFF4CAF50).withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Башка опциялар',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.notifications_none,
                    title: 'Билдирүүлөр',
                    subtitle: 'Билдирүүлөрдү башкаруу',
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.language,
                    title: 'Тил',
                    subtitle: 'Кыргызча',
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.dark_mode_outlined,
                    title: 'Түнкү режим',
                    subtitle: 'Өчүк',
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.help_outline,
                    title: 'Жардам',
                    subtitle: 'Көп берилген суроолор',
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.info_outline,
                    title: 'Биз жөнүндө',
                    subtitle: 'Тиркеме жөнүндө маалымат',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildInfoItem({required IconData icon, required String label}) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFF4CAF50).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Color(0xFF4CAF50),
            size: 24,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return InkWell(
      onTap: () {
        // Navigate to respective settings screen
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Color(0xFF4CAF50),
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
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
          Icon(
            Icons.home_outlined,
            color: Colors.white,
            size: 26,
          ),
          Icon(
            Icons.article_outlined,
            color: Colors.white,
            size: 26,
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline,
              color: Color(0xFF4CAF50),
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}
