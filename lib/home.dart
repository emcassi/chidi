import 'package:chidi/addPost.dart';
import 'package:chidi/postView.dart';
import 'package:chidi/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  bool gettingPosts = false;
  List<PostView> posts = [];
  PageController pageController = PageController();

  void nextPage() {
    print("INDEX: $index LENGTH ${posts.length}");
    index++;
    pageController.nextPage(
        curve: Curves.linear, duration: Duration(milliseconds: 200));
    if(index == posts.length - 1){
      setState(() {
        
      });
    }
  }

  Future<QuerySnapshot> getPosts() async {
    gettingPosts = true;
    String uid = FirebaseAuth.instance.currentUser.uid;
    posts = [];
    List<dynamic> likedPosts = [""];
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    likedPosts = doc.data()["liked"];
    print("LIKed: $likedPosts");
    return FirebaseFirestore.instance
        .collection("posts")
        .where("__name__", whereNotIn: (likedPosts))
        .limit(100)
        .get();
  }

  @override
  void initState() {
    // getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (posts.length == 0 && !gettingPosts) {
      //getPosts();
    }

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Chidi"),
          centerTitle: true,
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => AddPost()));
              },
            )
          ],
        ),
        body: FutureBuilder(
          future: getPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              snapshot.data.docs.forEach((doc) {
                print(doc.data());
                print(
                    "URL: ${(doc.data()["images"] as Map<String, dynamic>)[0]}");
                List<String> urls = [];
                (doc.data()["images"] as Map<String, dynamic>)
                    .forEach((key, value) {
                  urls.add(value);
                  print("VALUE: $value");
                });
                print("DOC: ${doc.id}");
                posts.add(PostView(
                  id: doc.id,
                  images: [
                    Image.network(
                      urls[0],
                      fit: BoxFit.fitWidth,
                    ),
                    Image.network(
                      urls[1],
                      fit: BoxFit.fitWidth,
                    )
                  ],
                  details: doc.data()["details"],
                  next: nextPage,
                ));
              });

              print("INDEX: $index POSTS LENGTH: ${posts.length}");
              if (index >= posts.length) {
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No Posts", style: TextStyle(fontSize: 24),),
                        RaisedButton(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: Text("Reload"),
                          onPressed: (){
                            index = 0;
                            setState(() {
                              
                            });
                          },
                        )
                      ],
                    )
                );
              }
              return Container(
                child: PageView(
                  controller: pageController,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  children: posts,
                ),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(
                child: Text("ERROR"),
              );
            } else {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
          },
        ));
  }
}
