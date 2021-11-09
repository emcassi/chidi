import 'package:chidi/postView.dart';
import 'package:chidi/profilePost.dart';
import 'package:flutter/material.dart';

class GridPost extends StatelessWidget {
  String id;
  int likedImg1;
  int likedImg2;
  String details;
  List<dynamic> liked;
  List<String> imageUrls;

  GridPost({this.id, this.likedImg1, this.likedImg2, this.liked, this.details, this.imageUrls});

  @override
  Widget build(BuildContext context) {

    List<Image> imgs = [];
    imageUrls.forEach((image){
      imgs.add(Image.network(image, fit: BoxFit.fitWidth,));
    });

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePost(id: id, details: details, images: imgs, likedImg1: likedImg1, likedImg2: likedImg2,)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        alignment: Alignment.bottomRight,
        decoration: BoxDecoration(
          image: likedImg1 >= likedImg2 ? DecorationImage(image: imgs[0].image, fit: BoxFit.fitWidth) : DecorationImage(image: imgs[1].image, fit: BoxFit.fitWidth)
        ),
        child: Container(
              width: MediaQuery.of(context).size.width / 9, 
              height: MediaQuery.of(context).size.width / 9,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle
              ),
              child: Center(child: Text("${likedImg1 + likedImg2}", style: TextStyle(color: Colors.red),)),
            ),
      ),
    );
  }
}
