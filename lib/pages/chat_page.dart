import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khyber_chat/pages/group_info.dart';
import 'package:khyber_chat/services/database_service.dart';
import 'package:khyber_chat/widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  final String groupId, groupName , userName;
  const ChatPage({super.key, required this.groupId, required this.groupName, required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String admin = '';
  Stream<QuerySnapshot>? chats;
    final TextEditingController _controller = TextEditingController();

    @override
  void initState() {
  getChatAndAdmin();
    super.initState();
  }

  getChatAndAdmin()async{
   DatabaseService().getChats(widget.groupId).then((value){
    chats = value;
   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Chats Of ${widget.groupName.toUpperCase()}'),
        backgroundColor: Colors.deepPurple, // Matching color from previous example
        actions: [
          IconButton(onPressed: (){
            nextScreen(context, GroupInfo(groupId: widget.groupId,groupName: widget.groupName,adminName: '',));
          }, icon: const Icon(Icons.info))
        ],
      ),
      body: Column(
        children: [
          // Chat message list
         
          
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
                  onPressed: null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}