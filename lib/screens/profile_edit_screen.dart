import 'package:flutter/material.dart';

class ProfileEditScreen extends StatefulWidget {
  final Map<String, String> userData;

  const ProfileEditScreen({super.key, required this.userData});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData['name']);
    _emailController = TextEditingController(text: widget.userData['email']);
    _phoneController = TextEditingController(text: widget.userData['phone']);
    _locationController = TextEditingController(
      text: widget.userData['location'],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      _showErrorDialog("Аты-жөнүңүз жана телефон номериңиз талап кылынат");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate network call
      await Future.delayed(Duration(seconds: 1));

      // Update userData map with new values
      Map<String, String> updatedUserData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'location': _locationController.text,
      };

      // Return to previous screen with updated data
      Navigator.pop(context, updatedUserData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Профиль жаңыртылды"),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
    } catch (e) {
      _showErrorDialog("Профилди жаңыртуу учурунда катачылык");
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
                child: Text(
                  "Жабуу",
                  style: TextStyle(color: Color(0xFF4CAF50)),
                ),
              ),
            ],
          ),
    );
  }

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
          'Профилди өзгөртүү',
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
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile image edit
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      'assets/profile_placeholder.png',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Show image picker
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Form fields
              _buildTextField(
                label: 'Аты-жөнү',
                controller: _nameController,
                icon: Icons.person_outline,
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: 'Email',
                controller: _emailController,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: 'Телефон',
                controller: _phoneController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: 'Дарек',
                controller: _locationController,
                icon: Icons.location_on_outlined,
              ),
              SizedBox(height: 30),
              // Save button
              _isLoading
                  ? CircularProgressIndicator(color: Color(0xFF4CAF50))
                  : ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Сактоо',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Color(0xFF4CAF50)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF4CAF50)),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
