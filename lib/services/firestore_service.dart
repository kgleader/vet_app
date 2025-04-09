import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // News Collection
  Future<List<Map<String, dynamic>>> getNews() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('news').get();
      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    } catch (e) {
      print('Error fetching news: $e');
      return [];
    }
  }

  // Category Data Collection
  Future<Map<String, dynamic>?> getCategoryData(String categoryName) async {
    try {
      final DocumentSnapshot snapshot = await _firestore
          .collection('categories')
          .doc(categoryName)
          .get();

      if (snapshot.exists) {
        return {
          'id': snapshot.id,
          ...snapshot.data() as Map<String, dynamic>,
        };
      }
      return null;
    } catch (e) {
      print('Error fetching category data: $e');
      return null;
    }
  }

  // Veterinarians Collection
  Future<List<Map<String, dynamic>>> getVeterinarians() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('veterinarians').get();
      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    } catch (e) {
      print('Error fetching veterinarians: $e');
      return [];
    }
  }

  // Send Message to Veterinarian
  Future<bool> sendMessageToVet(Map<String, dynamic> messageData) async {
    try {
      await _firestore.collection('vet_messages').add(messageData);
      return true;
    } catch (e) {
      print('Error sending message: $e');
      return false;
    }
  }
}
