import 'package:chidi/forgotPassword.dart';
import 'package:chidi/login.dart';
import 'package:chidi/register.dart';
import 'package:chidi/registerEmail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chidi/myColors.dart' as colors;

class LoginEmail extends StatefulWidget {
  @override
  _LoginEmailState createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                    width: double.infinity,
                    child: Text(
                      "Sign In",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    child: TextField(
                      controller: emailController,
                      // maxLength: 10,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: true,
                      autocorrect: false,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 22, color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Email Address",
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
                      controller: passwordController,
                      // maxLength: 10,
                      autofocus: true,
                      textAlign: TextAlign.left,
                      obscureText: true,
                      style: TextStyle(fontSize: 22, color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Password",
                          counter: Container(),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                      onChanged: (text) {
                        setState(() {});
                      },
                    ),
                  ),
                  Align(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 0),
                      // width: double.infinity,
                      child: FlatButton(
                        child: Text(
                          "Forgot Password?",
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.white54),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()));
                        },
                      ),
                    ),
                    alignment: Alignment.topRight,
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    child: FlatButton(
                      child: Text(
                        "Don't have an account? Sign Up",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterEmail()));
                      },
                    ),
                  ),
                  Container(
                    child: FlatButton(
                      child: Text(
                        "Login with Phone Number",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
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
                          color: Colors.white30,
                        ),
                      ),
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text);
                          Navigator.pop(context);
                        } on FirebaseAuthException catch (e) {
                          switch (e.code) {
                            case "wrong-password":
                              print("Wrong password");
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Incorrect Password"),
                                      content: Text(
                                          "The password you entered does not match the password we have on file for this account. Please try again"),
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
                            case "user-not-found":
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Account not found"),
                                      content: Text(
                                          "The email you entered does not match any account we have on file. Please try again"),
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
                            case "user-disabled":
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("User Disabled"),
                                      content: Text("This account has been disabled. Please try again later"),
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
                            case "invalid-email":
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Invalid Email"),
                                      content: Text("The email you entered is not valid. Please try again"),
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
                            default:
                              print(
                                  "An error ocurred, please try again later.");
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

// Container(
//         child: Column(
//           children: [
//             Container(
//               height: MediaQuery.of(context).size.height / 6,
//             ),
//             Container(
//               child: Text(
//                 "Log In",
//                 style: TextStyle(
//                   fontSize: 48,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
//               margin: EdgeInsets.symmetric(horizontal: 20),
//               child: TextField(
//                 controller: emailController,
//                 textAlign: TextAlign.left,
//                 decoration: InputDecoration(
//                   hintText: "Email",
//                   border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 0)),
//                   focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
//                 ),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
//               margin: EdgeInsets.symmetric(horizontal: 20),
//               child: TextField(
//                 controller: passwordController,
//                 textAlign: TextAlign.left,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   hintText: "Password",
//                   border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 0)),
//                   focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
//                 ),
//               ),
//             ),
//             Positioned(
//               left: 0,
//               right: 0,
//               bottom: 0,
//               // bottom: MediaQuery.of(context).viewInsets.bottom,
//               child: Container(
//               width: double.infinity,
//               margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
//               decoration: BoxDecoration(
//                // border: Border.all(width: 2, color: Colors.white),
//                 borderRadius: BorderRadius.circular(25),
//                 color: Colors.white
//               ),
//               child: FlatButton(
//                 child: Text(
//                   "Log In",
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: colors.blue
//                   )
//                 ),
//                 onPressed: (){},
//               )
//             ),
//             ),

//           ],
//         ),
//       ),
