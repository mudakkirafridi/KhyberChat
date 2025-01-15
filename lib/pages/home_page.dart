// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khyber_chat/helpers/helper_function.dart';
import 'package:khyber_chat/pages/auth/login_page.dart';
import 'package:khyber_chat/pages/profile_page.dart';
import 'package:khyber_chat/pages/search_page.dart';
import 'package:khyber_chat/services/auth_services.dart';
import 'package:khyber_chat/services/database_service.dart';
import 'package:khyber_chat/widgets/group_tile.dart';
import 'package:khyber_chat/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _groupNameController = TextEditingController();
  String userName = '';
  String email = '';
  final AuthServices _authServices = AuthServices();
  Stream? group;
  bool _isLoading = false;
  String groupName = '';

  @override
  void initState() {
    gettingUserData();
    super.initState();
  }

  getId(String res){
    return res.substring(0,res.indexOf("_"));
  }

  getName(String res){
    return res.substring(res.indexOf("_")+1);
  }
  
  gettingUserData() async {
    await HelperFunction.getUserEmailFromSf().then((value) {
      setState(() {
        email = value ?? 'null';
      });
    });
    await HelperFunction.getUserNameFromSf().then((value) {
      setState(() {
        userName = value ?? 'null';
      });
    });
    // getting the list of snapshot in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroup()
        .then((value) {
      setState(() {
        group = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: const Text('Groups'),
        actions: [
          IconButton(
              onPressed: () {
                _authServices.signOut().then((value) {
                  nextScreen(context, const LoginPage());
                });
              },
              icon: const Icon(Icons.logout)),
          IconButton(
              onPressed: () {
                nextScreen(context, const SearchPage());
              },
              icon: const Icon(Icons.search))
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: <Widget>[
              // Drawer Header with Avatar and Name
              DrawerHeader(
                decoration: const BoxDecoration(),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          NetworkImage('https://via.placeholder.com/150'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Menu Items
              ListTile(
                leading: const Icon(Icons.group, color: Colors.white),
                title: const Text(
                  'Groups',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  // Add your onTap functionality here
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text(
                  'Profile',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  // Add your onTap functionality here
                  nextScreen(
                      context,
                      ProfilePage(
                        name: userName,
                        email: email,
                      ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  // Add your onTap functionality here
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Are You Sure You Want To Exist'),
                          actions: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.cancel)),
                            IconButton(
                                onPressed: () {
                                  _authServices.signOut().whenComplete(() {
                                    nextScreen(context, const LoginPage());
                                  });
                                },
                                icon: const Icon(Icons.done))
                          ],
                        );
                      });
                },
              ),
            ],
          ),
        ),
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
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                groupList(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: () {
            popUpDialog(context);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }

  groupList() {
    return StreamBuilder(
      stream: group,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context,index){
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                return GroupTile(userName: snapshot.data["fullName"], groupId: getId(snapshot.data['groups'][reverseIndex]), groupName: getName(snapshot.data['groups'][reverseIndex]));
              });
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }


  // groupList() {
  //   return StreamBuilder(
  //     stream: group, // Stream<T> type
  //     builder: (BuildContext context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const CircularProgressIndicator(); // Loading state
  //       } else if (snapshot.hasError) {
  //         return Text('Error: ${snapshot.error}'); // Error state
  //       } else if (snapshot.hasData) {
  //         if (snapshot.data['group'] != null) {
  //           if (snapshot.data['group'].length != 0) {
  //             return groupList();
  //           } else {
  //             return noGroupWidget();
  //           }
  //         } else {
  //           return noGroupWidget();
  //         }
  //       }
  //       return const SizedBox(
  //         child: Center(
  //           child: Text('default return'),
  //         ),
  //       ); // Default return statement
  //     },
  //   );
  // }

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
              _isLoading == true
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple,
                      ),
                    )
                  : const Text(
                      'Create a group',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
              const SizedBox(height: 20),
              TextField(
                onChanged: (val) {
                  setState(() {
                    groupName = val;
                  });
                },
                controller: _groupNameController,
                decoration: InputDecoration(
                  hintText: 'Group Name',
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Colors.deepPurple),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Colors.deepPurple),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        const BorderSide(color: Colors.deepPurple, width: 2),
                  ),
                ),
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
                    onPressed: () {
                      if (groupName != "") {
                        setState(() {
                          _isLoading = true;
                        });

                        DatabaseService(
                                uid: FirebaseAuth.instance.currentUser!.uid)
                            .createGroup(
                                userName,
                                FirebaseAuth.instance.currentUser!.uid,
                                groupName).whenComplete((){
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Navigator.of(context).pop();
                                  showSnackbar(context, Colors.green, "Group Created Successfully");
                                });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: const Text(
                      'Create',
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

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                popUpDialog(context);
              },
              child: Icon(
                Icons.add_circle,
                size: 75,
                color: Colors.grey[700],
              )),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'You Have Not Joined Any Group!',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
