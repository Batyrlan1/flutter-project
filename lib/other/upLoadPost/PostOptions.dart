import 'package:Tau/Sign/Auth.dart';
import 'package:Tau/Sign/Firebaseoperations.dart';
import 'package:Tau/other/Profile/AltProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PostFunctions with ChangeNotifier {
  showPostOptions(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xff757575),
            height: 70,
            child: Container(
              padding: EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  MaterialButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Удалить эту идею?",
                                  style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400)),
                              actions: [
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Нет",
                                      style: GoogleFonts.roboto(
                                          color: Colors.blueAccent,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400)),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    Provider.of<FirebaseOperations>(context,
                                            listen: false)
                                        .deleteUserData(postId, "Posts")
                                        .whenComplete(() {
                                      Provider.of<FirebaseOperations>(context,
                                              listen: false)
                                          .deleteUserPostData(context, postId);
                                    }).whenComplete(() {
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: Text("Да",
                                      style: GoogleFonts.roboto(
                                          color: Colors.red,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400)),
                                ),
                              ],
                            );
                          });
                    },
                    child: Text("Удалить идею",
                        style: GoogleFonts.roboto(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                  ),
                ],
              )),
            ),
          );
        });
  }

  Future addLike(BuildContext context, String postId, String subDocId) async {
    return FirebaseFirestore.instance
        .collection("Posts")
        .doc(postId)
        .collection("likes")
        .doc(subDocId)
        .set({
      "likes": FieldValue.increment(1),
      "name": Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      "Uid": Provider.of<CurrentUser>(context, listen: false).getUid,
      "avatar": Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserAvatar,
      "Surename": Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserSurename,
      "Time": Timestamp.now(),
    });
  }

  Future addComent(BuildContext context, String postId, String comment) async {
    return FirebaseFirestore.instance
        .collection("Posts")
        .doc(postId)
        .collection("comments")
        .doc(comment)
        .set({
      "comment": comment,
      "name": Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      "Uid": Provider.of<CurrentUser>(context, listen: false).getUid,
      "avatar": Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserAvatar,
      "Surename": Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserSurename,
      "Time": Timestamp.now(),
    });
  }

  showLikessSheet(BuildContext context, String postId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0.5,
              leading: IconButton(
                  icon: Icon(CupertinoIcons.arrow_left),
                  color: Colors.black,
                  iconSize: 20,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              centerTitle: true,
              title: Text(
                "Понравилось",
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: MediaQuery.of(context).size.width,
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Posts")
                              .doc(postId)
                              .collection("likes")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.black54),
                                ),
                              );
                            } else {
                              return new ListView(
                                  children: snapshot.data.docs
                                      .map((DocumentSnapshot documentSnapshot) {
                                return Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      child: ListTile(
                                        leading: GestureDetector(
                                          onTap: () {
                                            if (documentSnapshot
                                                    .data()["Uid"] !=
                                                Provider.of<CurrentUser>(
                                                        context,
                                                        listen: false)
                                                    .getUid) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AltProfile(
                                                            userUid:
                                                                documentSnapshot
                                                                        .data()[
                                                                    "Uid"],
                                                          )));
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  width: 1,
                                                  color: Color(0xFF7A9BEE),
                                                )),
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.044,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.082,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      documentSnapshot
                                                          .data()['avatar']),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        title: Transform(
                                          transform: Matrix4.translationValues(
                                              -8.0, 0.0, 0.0),
                                          child: Row(children: [
                                            Text(
                                              documentSnapshot
                                                  .data()['Surename'],
                                              style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              documentSnapshot.data()['name'],
                                              style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList());
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
