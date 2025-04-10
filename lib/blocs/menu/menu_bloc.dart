import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vet_app/blocs/menu/menu_event.dart';
import 'package:vet_app/blocs/menu/menu_state.dart';
import 'package:vet_app/models/menu_category.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(MenuInitial()) {
    on<LoadMenuCategories>(_onLoadMenuCategories);
    on<MenuCategorySelected>(_onMenuCategorySelected);
  }

  void _onLoadMenuCategories(LoadMenuCategories event, Emitter<MenuState> emit) {
    emit(MenuLoading());
    try {
      // In a real app, this data would come from a repository
      final categories = [
        MenuCategory(
          id: 'about_us',
          title: 'Биз жөнүндө',
          iconPath: 'assets/icons/about_us.svg',
        ),
        MenuCategory(
          id: 'feed',
          title: 'Тоют',
          iconPath: 'assets/icons/grass.svg',
        ),
        MenuCategory(
          id: 'breeding',
          title: 'Уруктандыруу',
          iconPath: 'assets/icons/male.svg',
        ),
        MenuCategory(
          id: 'disease',
          title: 'Оору',
          iconPath: 'assets/icons/vaccines.svg',
        ),
        MenuCategory(
          id: 'cattle',
          title: 'Бодо мал',
          iconPath: 'assets/icons/cow.svg',
        ),
        MenuCategory(
          id: 'sheep_goats',
          title: 'Кой эчкилер',
          iconPath: 'assets/icons/goat.svg',
        ),
        MenuCategory(
          id: 'horses',
          title: 'Жылкылар',
          iconPath: 'assets/icons/horse.svg',
        ),
        MenuCategory(
          id: 'poultry',
          title: 'Тоок',
          iconPath: 'assets/icons/chicken.svg',
        ),
      ];
      emit(MenuLoaded(categories));
    } catch (e) {
      emit(MenuError(e.toString()));
    }
  }

  void _onMenuCategorySelected(MenuCategorySelected event, Emitter<MenuState> emit) {
    // In a real app, this would navigate to the category screen or fetch category data
    print('Category selected: ${event.categoryId}');
  }
}
