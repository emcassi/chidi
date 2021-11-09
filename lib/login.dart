import 'package:chidi/loginEmail.dart';
import 'package:chidi/phoneVer.dart';
import 'package:chidi/register.dart';
import 'package:chidi/registerEmail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chidi/myColors.dart' as colors;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.red,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: colors.red,
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
                    child: Text(
                      "My number is",
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Container(
                    child: TextField(
                      controller: textEditingController,
                      // maxLength: 10,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, color: Colors.white),
                      decoration: InputDecoration(
                          counter: Container(),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                      onChanged: (text) {
                        setState(() {});
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "We will send a text with a verification code. Message and data rates may apply.",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    child: FlatButton(
                      child: Text(
                        "Sign in with Email",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => LoginEmail()));
                      },
                    ),
                  ),
                  Container(
                    child: FlatButton(
                      child: Text(
                        "Don't have an account? Sign up",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Register()));
                      },
                    ),
                  ),
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
                      onPressed: textEditingController.text.length == 0
                          ? null
                          : () async {
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: "+1" + textEditingController.text,
                                verificationCompleted:
                                    (PhoneAuthCredential credential) {
                                  FirebaseAuth.instance
                                      .signInWithCredential(credential)
                                      .then((cred) {
                                    print("VERIFIED");
                                  });
                                  print("GOT IT ");
                                },
                                verificationFailed: (exception) {
                                  if (exception.code ==
                                      'invalid-phone-number') {
                                    print("Invalid Phone number");
                                  }
                                  print(exception);
                                },
                                codeSent: (id, token) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PhoneVer(id)));
                                },
                                codeAutoRetrievalTimeout: (verificationId) {},
                              );
                            },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
