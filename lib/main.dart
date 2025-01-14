import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:khyber_chat/firebase_options.dart';
import 'package:khyber_chat/helpers/helper_function.dart';
import 'package:khyber_chat/pages/auth/login_page.dart';
import 'package:khyber_chat/pages/home_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  @override
  void initState() {
    getUserLoggedInStatus();
    super.initState();
  }

  getUserLoggedInStatus()async{
    await HelperFunction.getUserLoggedInStatus().then((value){
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme:const AppBarTheme(
          foregroundColor: Colors.white
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _isSignedIn ?  const HomePage() : const HomePage(),
    );
  }
}
