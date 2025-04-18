import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String boardId;
  final String boardName;

  ChatScreen({required this.boardId, required this.boardName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();

  // Method to send messages
  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final currentUser = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('boards')
          .doc(widget.boardId)
          .collection('messages')
          .add({
        'message': _messageController.text,
        'username': currentUser!.email,
        'datetime': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.boardName),
      ),
      body: Column(
        children: [
          // Display chat messages using StreamBuilder
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('boards')
                  .doc(widget.boardId)
                  .collection('messages')
                  .orderBy('datetime', descending: true)
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (chatSnapshot.hasError) {
                  return Center(child: Text('Error: ${chatSnapshot.error}'));
                }

                final messages = chatSnapshot.data!.docs;

                return ListView.builder(
                  reverse: true, // To show new messages at the bottom
                  itemCount: messages.length,
                  itemBuilder: (ctx, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(message['username']),
                      subtitle: Text(message['message']),
                      trailing: Text(message['datetime'].toDate().toString()),
                    );
                  },
                );
              },
            ),
          ),

          // Text input field for new message
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Enter message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}