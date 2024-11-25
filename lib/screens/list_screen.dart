import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';

class ListScreen extends StatefulWidget {
  final String title;
  final String endpoint;

  ListScreen({required this.title, required this.endpoint});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Article>> _futureItems;

  @override
  void initState() {
    super.initState();
    _futureItems = _apiService.getItems(widget.endpoint);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<List<Article>>(
        future: _futureItems,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: item.imageUrl.isNotEmpty
                        ? Image.network(
                      item.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error),
                    )
                        : Icon(Icons.article),
                    title: Text(item.title),
                    subtitle: Text(
                      item.publishedAt.substring(0, 10),
                      style: TextStyle(fontSize: 12),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            endpoint: widget.endpoint,
                            id: item.id,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}