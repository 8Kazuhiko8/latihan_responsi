import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article.dart';
import '../services/api_service.dart';

class DetailScreen extends StatefulWidget {
  final String endpoint;
  final int id;

  DetailScreen({required this.endpoint, required this.id});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final ApiService _apiService = ApiService();
  late Future<Article> _futureItem;

  @override
  void initState() {
    super.initState();
    _futureItem = _apiService.getItemDetail(widget.endpoint, widget.id);
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details')),
      body: FutureBuilder<Article>(
        future: _futureItem,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final item = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.imageUrl.isNotEmpty)
                    Center(
                      child: Image.network(
                        item.imageUrl,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.error, size: 100),
                      ),
                    ),
                  SizedBox(height: 16),
                  Text(
                    item.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Published: ${item.publishedAt.substring(0, 10)}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  Text(
                    item.summary,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final item = await _futureItem;
          _launchUrl(item.url);
        },
        child: Icon(Icons.open_in_browser),
        tooltip: 'Open in browser',
      ),
    );
  }
}