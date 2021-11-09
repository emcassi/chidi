import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  List<File> files = [];
  List<Image> images = [];

  PageController pageController = PageController();
  TextEditingController textEditingController = TextEditingController();

  File _image;

  final picker = ImagePicker();

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 88,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  Future getImageFromCamera() async {
    try {
      final pickedFile = await picker.getImage(
          source: ImageSource.camera,
          imageQuality: 40,
          maxWidth: MediaQuery.of(context).size.width);

      setState(() {
        if (pickedFile != null) {
          images.add(Image.file(
            File(pickedFile.path),
            fit: BoxFit.fitWidth,
          ));
          files.add(File(pickedFile.path));
          pageController.jumpToPage(images.length - 1);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future getImageFromLibrary() async {
    try {
      final pickedFile = await picker.getImage(
          source: ImageSource.gallery,
          imageQuality: 40,
          maxWidth: MediaQuery.of(context).size.width);

      setState(() {
        if (pickedFile != null) {
         // getimageditor();
          images.add(Image.file(
            File(pickedFile.path),
            fit: BoxFit.fitWidth,
          ));
          files.add(File(pickedFile.path));
          pageController.jumpToPage(images.length - 1);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print(e);
    }
  }


  void pick() {
    showModalBottomSheet(
        context: context,
        elevation: 5,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.white10,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(20), left: Radius.circular(20)),
                border: Border.all(width: 1),
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.black),
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              children: [
                Center(
                  child: Container(child: Icon(Icons.drag_handle)),
                ),
                Container(
                  child: Text(
                    "Pick Your Profile Photo",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(
                  thickness: 0.3,
                  color: Colors.white,
                ),
                ListTile(
                  title: Text("Take Photo"),
                  trailing: Icon(Icons.arrow_right),
                  leading: Icon(CupertinoIcons.camera_fill),
                  onTap: () {
                    getImageFromCamera().then((file) {});
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("Choose from Library"),
                  trailing: Icon(Icons.arrow_right),
                  leading: Icon(Icons.photo),
                  onTap: () {
                    getImageFromLibrary().then((file) {});
                    Navigator.pop(context);
                  },
                ),
                Container(
                    height: 40,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: FlatButton(
                      color: Colors.white24,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text("Cancel",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ))
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
      ),
      backgroundColor: Colors.black,
      body: Container(
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 0.5, color: Colors.white))),
              child: PageView(
                controller: pageController,
                scrollDirection: Axis.horizontal,
                children: images.length == 0
                    ? [
                        Center(
                          child: IconButton(
                            icon: Icon(Icons.photo_camera),
                            onPressed: () {
                              pick();
                            },
                          ),
                        )
                      ]
                    : images,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: images.length == 0
                    ? [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 0.5)),
                          child: GestureDetector(
                            child: CircleAvatar(
                              child: Icon(
                                Icons.add,
                                size: 25,
                              ),
                              radius: 30,
                            ),
                            onTap: () {
                              pick();
                            },
                          ),
                        ),
                      ]
                    : [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            child: CircleAvatar(
                              backgroundImage: images[0].image,
                              radius: 30,
                            ),
                            onTap: () {
                              pageController.animateToPage(0,
                                  curve: Curves.linear,
                                  duration: Duration(milliseconds: 200));
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: images.length == 1
                              ? BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.black, width: 0.5))
                              : BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.black, width: 0.5)),
                          child: GestureDetector(
                            child: images.length == 1
                                ? CircleAvatar(
                                    child: Icon(Icons.add), radius: 50)
                                : CircleAvatar(
                                    backgroundImage: images[1].image,
                                    radius: 30,
                                  ),
                            onTap: () {
                              if (images.length == 1) {
                                pick();
                              } else if (images.length == 2) {
                                pageController.animateToPage(1,
                                    curve: Curves.linear,
                                    duration: Duration(milliseconds: 200));
                              }
                            },
                          ),
                        ),
                      ],
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  maxLength: 1000,
                  maxLines: null,
                  textInputAction: TextInputAction.done,
                  controller: textEditingController,
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "Details",
                  ),
                )),
            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: FlatButton(
                color: Colors.black,
                disabledColor: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: BorderSide(color: Colors.white, width: 2)),
                child: Text(
                  "POST",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: images.length == 2
                    ? () {
                        final collRef =
                            FirebaseFirestore.instance.collection("posts");
                        DocumentReference docReference = collRef.doc();
                        docReference.set({
                          "details": textEditingController.text,
                          "user": FirebaseAuth.instance.currentUser.uid,
                          "photo1": 0,
                          "photo2": 0,
                          "liked": [FirebaseAuth.instance.currentUser.uid],
                          "timedate": Timestamp.now()
                        });
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser.uid)
                            .update({
                          "liked": FieldValue.arrayUnion([docReference.id])
                        }).then((_) {});
                        for (int i = 0; i < images.length; i++) {
                          FirebaseStorage.instance
                              .ref()
                              .child("posts_img")
                              .child(docReference.id + "_$i")
                              .putFile(files[i])
                              .then((snapshot) {
                            snapshot.ref.getDownloadURL().then((url) {
                              docReference.update({"images.$i": url});
                            });
                          });
                        }

                        Navigator.pop(context);
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
