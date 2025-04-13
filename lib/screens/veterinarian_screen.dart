import 'package:flutter/material.dart';
import 'package:vet_app/services/firestore_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class VeterinarianScreen extends StatefulWidget {
  const VeterinarianScreen({super.key});

  @override
  _VeterinarianScreenState createState() => _VeterinarianScreenState();
}

class _VeterinarianScreenState extends State<VeterinarianScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _veterinarians = [];
  
  @override
  void initState() {
    super.initState();
    _loadVeterinarians();
  }

  Future<void> _loadVeterinarians() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final vets = await _firestoreService.getVeterinarians();
      setState(() {
        _veterinarians = vets;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading veterinarians: $e');
    }
  }

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
        title: Text('Ветеринарлар', style: TextStyle(color: Colors.black)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _veterinarians.isEmpty
              ? Center(child: Text('Ветеринарлар табылган жок'))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _veterinarians.length,
                  itemBuilder: (context, index) {
                    final vet = _veterinarians[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VetDetailScreen(vet: vet),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: vet['imageUrl'] != null
                                    ? NetworkImage(vet['imageUrl'])
                                    : null,
                                child: vet['imageUrl'] == null
                                    ? Icon(Icons.person, size: 40)
                                    : null,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      vet['name'] ?? 'Аты жок',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      vet['specialization'] ?? 'Адистиги көрсөтүлгөн эмес',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Тажрыйбасы: ${vet['experience'] ?? 'Көрсөтүлгөн эмес'}',
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class VetDetailScreen extends StatefulWidget {
  final Map<String, dynamic> vet;

  const VetDetailScreen({super.key, required this.vet});

  @override
  _VetDetailScreenState createState() => _VetDetailScreenState();
}

class _VetDetailScreenState extends State<VetDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  File? _selectedImage;
  double _rating = 5.0;
  bool _isSending = false;

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Билдирүү киргизиңиз')),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      // For now, we'll just simulate sending the message
      // In a real app, you would upload the image to Firebase Storage
      // and save the message data to Firestore
      
      final messageData = {
        'vetId': widget.vet['id'],
        'message': _messageController.text,
        'rating': _rating,
        'createdAt': DateTime.now(),
        // In a real app, you would add the uploaded image URL here
      };

      final success = await _firestoreService.sendMessageToVet(messageData);
      
      setState(() {
        _isSending = false;
      });

      if (success) {
        _showSuccessDialog();
        _messageController.clear();
        setState(() {
          _selectedImage = null;
          _rating = 5.0;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Билдирүү жөнөтүү катасы')),
        );
      }
    } catch (e) {
      setState(() {
        _isSending = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Билдирүү жөнөтүү катасы: $e')),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ийгиликтүү!'),
        content: Text('Рахмат, билдирүү кабыл алынды.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Жабуу'),
          ),
        ],
      ),
    );
  }

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
        title: Text(widget.vet['name'] ?? 'Ветеринар', 
                   style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vet Profile Section
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: widget.vet['imageUrl'] != null
                        ? NetworkImage(widget.vet['imageUrl'])
                        : null,
                    child: widget.vet['imageUrl'] == null
                        ? Icon(Icons.person, size: 60)
                        : null,
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.vet['name'] ?? 'Аты жок',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.vet['specialization'] ?? 'Адистиги көрсөтүлгөн эмес',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            
            // Details Section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.work, color: Color(0xFF4CAF50)),
                      SizedBox(width: 8),
                      Text(
                        'Тажрыйбасы: ${widget.vet['experience'] ?? 'Көрсөтүлгөн эмес'}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Color(0xFF4CAF50)),
                      SizedBox(width: 8),
                      Text(
                        widget.vet['phone'] ?? 'Телефон номери жок',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Color(0xFF4CAF50)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.vet['description'] ?? 'Маалымат жок',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            
            // Message Form Section
            Text(
              'Ветеринарга билдирүү',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Билдирүүңүздү жазыңыз...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.all(16),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.image),
                    label: Text('Сүрөт тандоо'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _selectedImage != null
                      ? Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _selectedImage!,
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            IconButton(
                              icon: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 12,
                                child: Icon(Icons.close, size: 16, color: Colors.black),
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedImage = null;
                                });
                              },
                            ),
                          ],
                        )
                      : Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text('Сүрөт тандалган жок'),
                          ),
                        ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Баа',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Slider(
              value: _rating,
              min: 1.0,
              max: 5.0,
              divisions: 4,
              label: _rating.toStringAsFixed(1),
              activeColor: Color(0xFF4CAF50),
              onChanged: (value) {
                setState(() {
                  _rating = value;
                });
              },
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSending ? null : _sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4CAF50),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isSending
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Жиберүү', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
