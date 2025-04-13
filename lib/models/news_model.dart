import 'package:cloud_firestore/cloud_firestore.dart';  // Добавляем импорт

class NewsModel {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final DateTime publishedDate;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.publishedDate,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      publishedDate: json['publishedDate'] != null
          ? (json['publishedDate'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'publishedDate': publishedDate,
    };
  }
}