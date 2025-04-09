import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vet_app/services/firestore_service.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = true;
  Map<String, dynamic>? _aboutData;

  @override
  void initState() {
    super.initState();
    _loadAboutData();
  }

  Future<void> _loadAboutData() async {
    try {
      final data = await _firestoreService.getCategoryData('about_us');
      setState(() {
        _aboutData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading about us data: $e');
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
        title: Text('Биз жөнүндө', style: TextStyle(color: Colors.black)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_aboutData != null && _aboutData!['imageUrl'] != null)
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(_aboutData!['imageUrl']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                  SizedBox(height: 20),
                  Text(
                    _aboutData != null && _aboutData!['title'] != null
                        ? _aboutData!['title']
                        : 'Биз жөнүндө',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _aboutData != null && _aboutData!['description'] != null
                        ? _aboutData!['description']
                        : 'Бул бөлүмдө маалымат жакында кошулат. Биздин ветеринардык клиника жөнүндө жана кызматтарыбыз жөнүндө маалымат.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  if (_aboutData != null && _aboutData!['contactInfo'] != null)
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Байланыш маалыматы',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(_aboutData!['contactInfo']),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
