import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vet_app/blocs/news_bloc.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late NewsBloc _newsBloc;

  @override
  void initState() {
    super.initState();
    _newsBloc = NewsBloc();
    _newsBloc.add(FetchNews());
  }

  @override
  void dispose() {
    _newsBloc.close();
    super.dispose();
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
        title: Text('Жаңылыктар', style: TextStyle(color: Colors.black)),
      ),
      body: BlocProvider(
        create: (context) => _newsBloc,
        child: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state is NewsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is NewsLoaded) {
              return _buildNewsList(state.news);
            } else if (state is NewsError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text('Жаңылыктарды жүктөңүз'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildNewsList(List<Map<String, dynamic>> newsList) {
    if (newsList.isEmpty) {
      return Center(child: Text('Жаңылыктар жок'));
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        final news = newsList[index];
        return Card(
          elevation: 3,
          margin: EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (news['imageUrl'] != null)
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    news['imageUrl'],
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: Colors.grey[300],
                        child: Icon(Icons.image_not_supported, size: 50),
                      );
                    },
                  ),
                ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news['title'] ?? 'Аталышы жок',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      news['content'] ?? 'Мазмуну жок',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (news['publishedDate'] != null)
                          Text(
                            _formatDate(news['publishedDate']),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        TextButton(
                          onPressed: () {
                            // Navigate to news detail page
                          },
                          child: Text('Толук окуу'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(dynamic date) {
    try {
      if (date is DateTime) {
        return '${date.day}.${date.month}.${date.year}';
      }
      // Handle Timestamp from Firestore
      return 'Дата';
    } catch (e) {
      return 'Дата';
    }
  }
}
