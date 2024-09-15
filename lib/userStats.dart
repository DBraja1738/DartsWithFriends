import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserStatsScreen extends StatelessWidget {
  final String email;

  UserStatsScreen({required this.email});

  Future<Map<String, dynamic>> getUserStats(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return userData;
      } else {
        throw Exception('No user found with that email.');
      }
    } catch (e) {
      print('Error fetching user stats: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Statistics'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getUserStats(email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var data = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: $email'),
                  SizedBox(height: 10),
                  Text('Wins: ${data['wins'] ?? 'No data'}'),
                  SizedBox(height: 10),
                  Text('Number of Games: ${data['numberOfGames'] ?? 'No data'}'),
                  SizedBox(height: 10),
                  Text('Winrate: ${data['winrate'] ?? 'No data'}'),
                ],
              ),
            );
          } else {
            return Center(child: Text('No statistics found.'));
          }
        },
      ),
    );
  }
}
