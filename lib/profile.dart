import 'package:chidi/gridPost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chidi/settings.dart';
import 'package:chidi/myColors.dart' as colors;

class Profile extends StatelessWidget {
  SliverGridDelegate gridDelegate =
      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3);
  List<GridPost> posts;
  bool gettingPosts = false;

  Future<QuerySnapshot> getPosts() {
    gettingPosts = true;
    String uid = FirebaseAuth.instance.currentUser.uid;
    posts = [];
    return FirebaseFirestore.instance
        .collection("posts")
        .where("user", isEqualTo: uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileSettings()));
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: getPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              snapshot.data.docs.forEach((DocumentSnapshot doc) {
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
                posts.add(GridPost(
                  id: doc.id,
                  imageUrls: urls,
                  liked: doc.data()["liked"],
                  likedImg1: doc.data()["photo1"],
                  likedImg2: doc.data()["photo2"],
                  details: doc.data()["details"],
                ));
              });
              return SafeArea(
                              child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20, top: 10),
                            child: Text("Posts",
                                style: TextStyle(fontSize: 24),
                                textAlign: TextAlign.left)),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),
                        
                        GridView.builder(
                          gridDelegate: gridDelegate,
                          shrinkWrap: true,
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            return posts[index];
                          },
                        )
                      ],
                    )),
              );
            }
            if (snapshot.hasError) {
              return Container(
                height: double.infinity,
                width: double.infinity,
                child: Center(
                  child: Text(
                      "There was an error loading your posts. Please try again later"),
                ),
              );
            }
            return Container(
              height: double.infinity,
              width: double.infinity,
              child: Center(child: CupertinoActivityIndicator()),
            );
          }),
    );
  }
}
