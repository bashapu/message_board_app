import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:message_board_app/screens/chat_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Message Boards')),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen()));
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('boards').get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final boards = snapshot.data!.docs;
          return ListView.builder(
            itemCount: boards.length,
            itemBuilder: (ctx, index) {
              final board = boards[index];
              return ListTile(
                leading: Icon(Icons.chat),
                title: Text(board['name']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ChatScreen(
                            boardId: board.id,
                            boardName: board['name'],
                          ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
