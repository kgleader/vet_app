import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class MenuCategory extends Equatable {
  final String id;
  final String title;
  final String iconPath;

  const MenuCategory({
    required this.id,
    required this.title,
    required this.iconPath,
  });

  @override
  List<Object> get props => [id, title, iconPath];
}
