import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khyber_chat/pages/home_page.dart';
import 'package:khyber_chat/services/database_service.dart';
import 'package:khyber_chat/widgets/widgets.dart';

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

 String getId(String res){
  return res.substring(0,res.indexOf("_"));
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
          IconButton(onPressed: () {
           popUpDialog(context);
          }, icon: const Icon(Icons.exit_to_app))
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
   void popUpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          contentPadding: const EdgeInsets.all(20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             const Text(
                      'Are You Sure You Want To Exit!',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
              
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: ()async {
                     await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).toggleGroupJoin(widget.groupId, getName(widget.adminName), widget.groupName).whenComplete((){
                      nextScreen(context, const HomePage());
                     });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: const Text(
                      'Ok',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
                    title: Text(getId(snapshot.data['members'][index])),
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
