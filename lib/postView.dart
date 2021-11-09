import 'package:chidi/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class PostView extends StatefulWidget {
  String id;

  List<Image> images = [
    Image.asset("assets/images/sb.jpg"),
    Image.asset("assets/images/pring.jpg")
  ];

  String details = "New profile pic for my insta asdf fas fi  asdf asdf sd";

  VoidCallback next;

  PostView({this.id, this.images, this.details, this.next});

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  int index = 0;

  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width,
            child: PageView(
              controller: controller,
              scrollDirection: Axis.horizontal,
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width,
                        child: PinchZoom(
                          image: Image(
                            image: widget.images[0].image,
                            fit: BoxFit.fitWidth,
                          ),
                          maxScale: 5,
                          zoomedBackgroundColor: Colors.black45,
                        ),
                        
                        ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10, right: 10),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          color: Colors.red,
                          icon: Icon(Icons.favorite),
                          iconSize: 30,
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("posts")
                                .doc(widget.id)
                                .update({
                              "photo1": FieldValue.increment(1)
                            }).then((asd) {
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .update({
                                "liked": FieldValue.arrayUnion([widget.id])
                              }).then((_) {
                                widget.next();
                              });
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width,
                        child: PinchZoom(
                          image: Image(
                            image: widget.images[1].image,
                            fit: BoxFit.fitWidth,
                          ),
                          maxScale: 5,
                          zoomedBackgroundColor: Colors.black45,
                        ),),
                    Container(
                      margin: EdgeInsets.only(bottom: 10, right: 10),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          color: Colors.red,
                          icon: Icon(Icons.favorite),
                          iconSize: 30,
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("posts")
                                .doc(widget.id)
                                .update({
                              "photo2": FieldValue.increment(1)
                            }).then((_) {
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .update({
                                "liked": FieldValue.arrayUnion([widget.id])
                              }).then((_) {
                                widget.next();
                              });
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ],
              onPageChanged: (index) {
                setState(() {
                  print(index);
                  this.index = index;
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: index == 0
                      ? BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.red, width: 5))
                      : BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.transparent, width: 5)),
                  child: GestureDetector(
                    child: CircleAvatar(
                      backgroundImage: widget.images[0].image,
                      radius: 50,
                    ),
                    onTap: () {
                      controller.animateToPage(0,
                          curve: Curves.linear,
                          duration: Duration(milliseconds: 200));
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: index == 1
                      ? BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.red, width: 5))
                      : BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.transparent, width: 5)),
                  child: GestureDetector(
                    child: CircleAvatar(
                      backgroundImage: widget.images[1].image,
                      radius: 50,
                    ),
                    onTap: () {
                      controller.animateToPage(1,
                          curve: Curves.linear,
                          duration: Duration(milliseconds: 200));
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
                child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.details,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            )),
          )
        ],
      ),
    );
  }
}
