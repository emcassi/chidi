import 'package:chidi/changeEmail.dart';
import 'package:chidi/changePassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chidi/myColors.dart' as colors;

class ProfileSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.red,
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.info),
              title: Text("About"),
              onTap: (){
                showAboutDialog(
                  context: context,
                 applicationVersion: "0.0.1", 
                 applicationIcon: Image.asset("assets/images/logo.png", width: 50, height: 50,),
                 applicationLegalese: "©2021 Alex Wayne");
              },
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text("Change Email"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeEmail()));
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text("Change Password"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Sign Out"),
              onTap: (){
                try{
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  Navigator.pop(context);
                } catch(e){
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}