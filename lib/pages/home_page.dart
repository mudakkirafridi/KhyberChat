import 'package:flutter/material.dart';
import 'package:khyber_chat/helpers/helper_function.dart';
import 'package:khyber_chat/pages/auth/login_page.dart';
import 'package:khyber_chat/pages/profile_page.dart';
import 'package:khyber_chat/pages/search_page.dart';
import 'package:khyber_chat/services/auth_services.dart';
import 'package:khyber_chat/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = '';
  String email = '';
  final AuthServices _authServices = AuthServices();

  @override
  void initState() {
    gettingUserData();
    super.initState();
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
                _authServices.signOut();
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
                  nextScreen(context,  ProfilePage(name: userName,email: email,));
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
        child: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}
