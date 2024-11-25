import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/list_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final username = snapshot.data!.getString('currentUsername') ?? '';
              return Text('Welcome, $username');
            }
            return Text('Welcome');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),
        children: [
          _buildMenuItem(context, 'News', 'articles'),
          _buildMenuItem(context, 'Blogs', 'blogs'),
          _buildMenuItem(context, 'Reports', 'reports'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, String endpoint) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListScreen(title: title, endpoint: endpoint),
            ),
          );
        },
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}