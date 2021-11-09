import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneVer extends StatefulWidget {

  String id;

  PhoneVer(this.id);

  @override
  _PhoneVerState createState() => _PhoneVerState();
}

class _PhoneVerState extends State<PhoneVer> {
  TextEditingController textEditingController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
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
                    "My code is",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: textEditingController,
                    // maxLength: 10,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28),
                    decoration: InputDecoration(
                      counter: Container(),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.lightBlue))
                    ),
                    onChanged: (text){
                      setState(() {
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "",
                    style: TextStyle(
                      color: Colors.grey
                    ),
                  ),
                ),
                ],
              ),
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.only(bottom: 20),
                child: FlatButton(
                  disabledColor: Colors.grey,
                  color: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    //side: BorderSide(color: Colors.white, width: 2)
                  ),
                  child: Text(
                    "CONTINUE",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: textEditingController.text.length == 0 ? null : () async {

                    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: widget.id, smsCode: textEditingController.text);

                    try {
                      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);                  
                    } catch (e) {
                      print(e);
                    }
                    
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}