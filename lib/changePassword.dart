import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chidi/myColors.dart' as colors;

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.red,
      appBar: AppBar(
        title: Text("Change Password"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    child: TextField(
                      controller: currentPasswordController,
                      // maxLength: 10,
                      autofocus: true,
                      autocorrect: false,
                      obscureText: true,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 22, color: Colors.white),
                      decoration: InputDecoration(
                          labelText: "Current password",
                          labelStyle: TextStyle(color: Colors.white),
                          counter: Container(),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                      onChanged: (text) {
                        setState(() {});
                      },
                    ),
                  ),
                  Container(
                    child: TextField(
                      controller: newPasswordController,
                      // maxLength: 10,
                      textAlign: TextAlign.left,
                      obscureText: true,
                      style: TextStyle(fontSize: 22, color: Colors.white),
                      decoration: InputDecoration(
                          labelText: "New Password",
                          labelStyle: TextStyle(color: Colors.white),
                          counter: Container(),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                      onChanged: (text) {
                        setState(() {});
                      },
                    ),
                  ),
                  
                ],
              ),
              Column(
                children: [
                  
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(bottom: 20),
                    child: FlatButton(
                      disabledColor: Colors.grey,
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(color: Colors.white, width: 2)),
                      child: Text(
                        "CONTINUE",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance.currentUser.reauthenticateWithCredential(EmailAuthProvider.credential(email: FirebaseAuth.instance.currentUser.email, password: currentPasswordController.text));
                          await FirebaseAuth.instance.currentUser.updatePassword(newPasswordController.text);
                          Navigator.pop(context);
                        } on FirebaseAuthException catch (e){
                          switch(e.code){
                            case "wrong-password":
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Incorrect Password"),
                                      content: Text("The password you entered does not match the password we have on file for this account. Please try again"),
                                      actions: [
                                        FlatButton(
                                          child: Text("Ok"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    );
                                  });
                              break;
                            case "weak-password":
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Weak Password"),
                                      content: Text("The password you entered is too weak. Please try again"),
                                      actions: [
                                        FlatButton(
                                          child: Text("Ok"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    );
                                  });
                              break;
                          }
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}