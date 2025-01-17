import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khyber_chat/pages/group_info.dart';
import 'package:khyber_chat/services/database_service.dart';
import 'package:khyber_chat/widgets/message_tile.dart';
import 'package:khyber_chat/widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  final String groupId, groupName, userName;
  const ChatPage(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});

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

  getChatAndAdmin() async {
    DatabaseService().getChats(widget.groupId).then((value) {
      chats = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats Of ${widget.groupName.toUpperCase()}'),
        backgroundColor:
            Colors.deepPurple, // Matching color from previous example
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    GroupInfo(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      adminName: '',
                    ));
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: Stack(
        children: [
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[700],
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.type_specimen,
                          color: Colors.deepPurple),
                      hintText: 'Type Message..',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding:const EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  )),
                  SizedBox(
                      height: 50,
                      width: 50,
                      child: IconButton(
                          onPressed: () {
                            sendMessage();
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ))),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
        stream: chats,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        message: snapshot.data!.docs[index]['message'],
                        sender: snapshot.data!.docs[index]['sender'],
                        sendByMe: widget.userName ==
                            snapshot.data!.docs[index]['sender']);
                  })
              : Container();
        });
  }

  void sendMessage() {
    if (_controller.text.isNotEmpty) {
      Map<String , dynamic> chatMessageMap = {
        "message": _controller.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        _controller.clear();
      });
    }
  }
}
