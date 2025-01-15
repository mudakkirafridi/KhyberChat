import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String groupId, groupName , userName;
  const ChatPage({super.key, required this.groupId, required this.groupName, required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

    final TextEditingController _controller = TextEditingController();
  List<String> messages = [];

  // Method to send a message
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add(_controller.text);
        _controller.clear(); // Clear the text field after sending the message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Chats Of ${widget.groupName.toUpperCase()}'),
        backgroundColor: Colors.deepPurple, // Matching color from previous example
      ),
      body: Column(
        children: [
          // Chat message list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      messages[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Chat input section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Text field for input
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 6,
                          offset:const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration:const InputDecoration(
                        hintText: 'Type a message...',
                        contentPadding:  EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                
                // Send button
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.deepPurple),
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