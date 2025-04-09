import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

// Events
abstract class NewsEvent {}

class FetchNews extends NewsEvent {}

// States
abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<Map<String, dynamic>> news;
  
  NewsLoaded(this.news);
}

class NewsError extends NewsState {
  final String message;
  
  NewsError(this.message);
}

// BLoC
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  NewsBloc() : super(NewsInitial()) {
    on<FetchNews>(_onFetchNews);
  }
  
  Future<void> _onFetchNews(FetchNews event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    try {
      // Fetch news from Firestore
      final QuerySnapshot snapshot = await _firestore.collection('news').get();
      final List<Map<String, dynamic>> newsList = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
          
      emit(NewsLoaded(newsList));
    } catch (e) {
      emit(NewsError('Жаңылыктарды жүктөө учурунда ката: $e'));
    }
  }
}
