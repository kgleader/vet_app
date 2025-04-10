import 'package:equatable/equatable.dart';

abstract class MenuEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadMenuCategories extends MenuEvent {}

class MenuCategorySelected extends MenuEvent {
  final String categoryId;
  
  MenuCategorySelected(this.categoryId);
  
  @override
  List<Object> get props => [categoryId];
}
