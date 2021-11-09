import 'package:chidi/home.dart';
import 'package:chidi/login_register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e){
      print(e);
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_error){
      return MaterialApp(home: Scaffold(body: Center(child: Text("ERROR"),),),);
    }
    if(!_initialized){
      return MaterialApp(home: Scaffold(body: Center(child: CupertinoActivityIndicator(),),),);
    }
    return MaterialApp(
      title: 'Chidi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          color: Colors.black,
         // titleTextStyle: TextStyle(color: Colors.white),
        ),
        brightness: Brightness.dark
      ),
      home: MyHomePage(title: 'Chidi'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool signedIn = false;

  @override
  Widget build(BuildContext context) {

    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
        if(signedIn != false){
          setState(() {
            signedIn = false;
          });
        }
      } else {
        print('User is signed in!');
        if(signedIn != true){
          setState(() {
            signedIn = true;
          });
          // FirebaseFirestore.instance.collection("users").doc(user.uid).get().then((DocumentSnapshot documentSnapshot) {
          //   if (documentSnapshot.exists) {
          //     print('Document exists on the database');
          //     // setState(() {
          //     //   signedIn = true;
          //     // });
          //   } else {
          //     print("Error: user document doesnt exist");
          //     // try {
          //     //   FirebaseAuth.instance.signOut();
          //     // } catch (e) {
          //     //   print(e);
          //     // }
          //   }
          // }, onError: (Object error){
          //   print("ERROR ERROR ERROR");
          // });
          
        }
      }
    });

    if(signedIn){
      return Home();
    } else{
      return LoginRegister();
    }
    
  }
}
