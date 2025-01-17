import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khyber_chat/helpers/helper_function.dart';
import 'package:khyber_chat/services/database_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final TextEditingController _searchController = TextEditingController();
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
   bool _isLoading = false;
   String userName = '';
   bool isJoined = false;
   User? user;

   @override
  void initState() {
    getCurrentUserIdAndName();
    super.initState();
  }
  String getName(String r){
  return r.substring(r.indexOf("_")+1);
}

 String getId(String res){
  return res.substring(0,res.indexOf("_"));
}

  getCurrentUserIdAndName()async{
    await HelperFunction.getUserNameFromSf().then((value){
      setState(() {
        userName = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: const Text('Search'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child:  SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
                child: Row(
                  children: [
                    Expanded(child: TextFormField(controller: _searchController,style: const TextStyle(color: Colors.white),decoration:const InputDecoration(
                           border: InputBorder.none,
                           hintText: "Search Groups...",
                           hintStyle: TextStyle(color: Colors.white,fontSize: 16)
                    ),)),
                    IconButton(onPressed: (){
                      initiateSearchMethod();
                    }, icon: const Icon(Icons.search,color: Colors.white,))
                  ],
                ),
              ),
              _isLoading ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple,),) : groupList(),
            ],
          ),
        ),
      ),
    );
  }
  
  void initiateSearchMethod() async{
    if (_searchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await DatabaseService().searchByName(_searchController.text).then((snapshot){
        setState(() {
          searchSnapshot = snapshot;
          _isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }
  
  groupList() {
    return hasUserSearched ? ListView.builder(
      itemCount: searchSnapshot!.docs.length,
      shrinkWrap: true,
      itemBuilder: (context , index){
      return MyGroupTile(
       userName,
      searchSnapshot!.docs[index]['groupId'],
      searchSnapshot!.docs[index]['groupName'],
      searchSnapshot!.docs[index]['admin'],
      );
    }) : Container();
  }
  
  MyGroupTile(String userName , String groupId , String groupName , String admin) {
    joinedOrNot(userName , groupId , groupName, admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.deepPurple,
        child: Text(groupName.substring(0,1).toUpperCase(),style: const TextStyle(color: Colors.white),),
      ),
      subtitle: Text("Admin: ${getName(admin)}"),
     title: Text(groupName,style: const TextStyle(fontWeight: FontWeight.bold),),
     trailing: InkWell(
      onTap: (){

      },
      child: isJoined ? Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
          border: Border.all(color: Colors.white,width: 1)
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
        child: const Text("Joined",style: TextStyle(color: Colors.white),),
      ) : Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.deepPurple,

        ),
        padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
        child: const Text('Join Now',style: TextStyle(color: Colors.white),),
      ),
     ),
    );
  }
  
  void joinedOrNot(String userName, String groupId, String groupName, String admin) async{
    await DatabaseService(uid: user!.uid).isUserJoined(groupName, groupId, userName).then((value){
      setState(() {
        isJoined = value;
      });
    });

  }
}