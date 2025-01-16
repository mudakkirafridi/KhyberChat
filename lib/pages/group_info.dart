import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khyber_chat/services/database_service.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  const GroupInfo(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.adminName});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
String getName(String r){
  return r.substring(r.indexOf("_")+1);
}
  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((value) {
      setState(() {
        members = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Group Info'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.deepPurple.withOpacity(.2)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.deepPurple,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Group: ${widget.groupName}",style: const TextStyle(fontWeight: FontWeight.bold),),
                      const SizedBox(height: 5,),
                      Text('Admin: ${getName(widget.adminName)}')
                    ],
                  )
                ],
              ),
            ),
            membersList(),
          ],
        ),
      ),
    );
  }
  
  membersList() {
    return StreamBuilder(stream: members, builder: (context,snapshot){
      if (snapshot.hasData) {
        if (snapshot.data["members"] != null) {
          if (snapshot.data['members'] != 0) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data['members'].length,
              itemBuilder: (context , index){
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5 , vertical: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.deepPurple,
                      child: Text(getName(snapshot.data['members'][index]).substring(0,1).toUpperCase(),style: const TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                    title: Text(getName(snapshot.data['members'][index])),
                  ),
                );
            });
          } else {
              return const Center(child: Text('NO Members'),);
          }
        } else {
          return const Center(child: Text('NO Members'),);
        }
      } else {
        return const Center(child: CircularProgressIndicator(color: Colors.deepPurple,),);
      }
    });
  }
}
