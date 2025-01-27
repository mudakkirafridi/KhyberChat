import 'package:flutter/material.dart';
import 'package:khyber_chat/pages/chat_page.dart';
import 'package:khyber_chat/widgets/widgets.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const GroupTile({super.key, required this.userName, required this.groupId, required this.groupName});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        nextScreen(context,  ChatPage(groupId: widget.groupId,groupName: widget.groupName,userName: widget.userName,));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10 , horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.deepPurple,
            child: Text(widget.groupName.substring(0,1).toUpperCase(),textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            
      
          ),
          title: Text(widget.groupName,style: const TextStyle(fontWeight: FontWeight.bold , color: Colors.white),),
          subtitle: Text('Join The Conversation As ${widget.userName}',style: const TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}