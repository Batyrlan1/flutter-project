import 'package:Tau/Sign/Auth.dart';
import 'package:Tau/Sign/Firebaseoperations.dart';
import 'package:Tau/other/Profile/AltProfile.dart';
import 'package:Tau/other/Search.dart';
import 'package:Tau/other/upLoadPost/PostOptions.dart';
import 'package:Tau/other/upLoadPost/Uploadview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:provider/provider.dart';

class BlogPage extends StatefulWidget {
  BlogPage({Key key}) : super(key: key);

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.plus_bubble,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => UploadView()));
          },
        ),
        actions: [
          IconButton(
              icon: Icon(
                CupertinoIcons.search,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Search()));
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Posts")
                .orderBy("Time", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.black54),
                  ),
                );
              } else {
                return loadPosts(context, snapshot);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget loadPosts(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
        children: snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            child: ListTile(
                leading: GestureDetector(
                  onTap: () {
                    if (documentSnapshot.data()["Uid"] !=
                        Provider.of<CurrentUser>(context, listen: false)
                            .getUid) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AltProfile(
                                    userUid: documentSnapshot.data()["Uid"],
                                  )));
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 0.8,
                          color: Color(0xFF7A9BEE),
                        )),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.044,
                      width: MediaQuery.of(context).size.width * 0.082,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image:
                              NetworkImage(documentSnapshot.data()['avatar']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                title: Transform(
                  transform: Matrix4.translationValues(-16.0, 0.0, 0.0),
                  child: Row(children: [
                    Text(
                      documentSnapshot.data()['Surename'],
                      style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 3,
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
                trailing:
                    Provider.of<CurrentUser>(context, listen: false).getUid ==
                            documentSnapshot.data()["Uid"]
                        ? GestureDetector(
                            onTap: () {
                              Provider.of<PostFunctions>(context, listen: false)
                                  .showPostOptions(
                                context,
                                documentSnapshot.data()['PostId'],
                              );
                            },
                            child: Icon(
                              CupertinoIcons.ellipsis,
                              size: 20,
                              color: Colors.black,
                            ),
                          )
                        : Container(
                            width: 0,
                            height: 0,
                          )),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 10),
            child: ExpandableText(
              documentSnapshot.data()['Caption'],
              style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
              expandText: "Подробнее",
              linkStyle: GoogleFonts.roboto(
                  color: Color(0xFF7A9BEE),
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
              maxLines: 3,
            ),
          ),
          GestureDetector(
            onDoubleTap: () {
              Provider.of<FirebaseOperations>(context, listen: false)
                  .initUserData(context)
                  .whenComplete(() {
                Provider.of<PostFunctions>(context, listen: false)
                    .addLike(context, documentSnapshot.data()['PostId'],
                        Provider.of<CurrentUser>(context, listen: false).getUid)
                    .whenComplete(() {
                  return FirebaseFirestore.instance
                      .collection("Feed")
                      .doc(documentSnapshot.data()['Uid'])
                      .collection("FeedItems")
                      .doc(documentSnapshot.data()['PostId'])
                      .set({
                    "Type": "like",
                    "Name":
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getInitUserName,
                    "Uid":
                        Provider.of<CurrentUser>(context, listen: false).getUid,
                    "Avatar":
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getInitUserAvatar,
                    "Surename":
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getInitUserSurename,
                    "Image": documentSnapshot.data()['PostImage'],
                    "Time": Timestamp.now(),
                    "PostId": documentSnapshot.data()['PostId'],
                  });
                });
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.56,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    documentSnapshot.data()['PostImage'],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onLongPress: () {
                        Provider.of<PostFunctions>(context, listen: false)
                            .showLikessSheet(
                          context,
                          documentSnapshot.data()['PostId'],
                        );
                      },
                      onTap: () {
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .initUserData(context)
                            .whenComplete(() {
                          Provider.of<PostFunctions>(context, listen: false)
                              .addLike(
                                  context,
                                  documentSnapshot.data()['PostId'],
                                  Provider.of<CurrentUser>(context,
                                          listen: false)
                                      .getUid)
                              .whenComplete(() {
                            return FirebaseFirestore.instance
                                .collection("Feed")
                                .doc(documentSnapshot.data()['Uid'])
                                .collection("FeedItems")
                                .doc(documentSnapshot.data()['PostId'])
                                .set({
                              "Type": "like",
                              "Name": Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .getInitUserName,
                              "Uid": Provider.of<CurrentUser>(context,
                                      listen: false)
                                  .getUid,
                              "Avatar": Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .getInitUserAvatar,
                              "Surename": Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getInitUserSurename,
                              "Image": documentSnapshot.data()['PostImage'],
                              "Time": Timestamp.now(),
                              "PostId": documentSnapshot.data()['PostId'],
                            });
                          });
                        });
                      },
                      child: Icon(CupertinoIcons.heart),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Posts")
                            .doc(documentSnapshot.data()["PostId"])
                            .collection("likes")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsets.only(top: 5, left: 2),
                              child: Text(
                                snapshot.data.docs.length.toString(),
                                style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            );
                          }
                        }),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    showCommentsSheet(
                      context,
                      documentSnapshot,
                      documentSnapshot.data()['PostId'],
                    );
                  },
                  child: Icon(
                    CupertinoIcons.chat_bubble,
                    size: 23,
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Posts")
                        .doc(documentSnapshot.data()["PostId"])
                        .collection("comments")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.only(top: 5, left: 2),
                          child: Text(
                            snapshot.data.docs.length.toString(),
                            style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        );
                      }
                    }),
              ],
            ),
          ]),
          SizedBox(
            height: 20,
          ),
        ],
      );
    }).toList());
  }

  showCommentsSheet(
      BuildContext context, DocumentSnapshot snapshot, String docId) {
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
                "Комментарий",
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
                              .doc(docId)
                              .collection("comments")
                              .orderBy("Time")
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
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      ListTile(
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
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Text(
                                            documentSnapshot.data()['comment'],
                                            style: GoogleFonts.roboto(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList());
                            }
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    endIndent: 10,
                    indent: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: TextField(
                          controller: commentController,
                          textCapitalization: TextCapitalization.sentences,
                          autocorrect: false,
                          style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w300),
                          maxLengthEnforced: true,
                          decoration: InputDecoration(
                            hintText: "Добавить комментарии",
                            hintStyle: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w300),
                            isDense: true,
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 3),
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: GestureDetector(
                          child: Icon(
                            Icons.send_outlined,
                            size: 22,
                            color: Color(0xFF7A9BEE),
                          ),
                          onTap: () {
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .initUserData(context)
                                .whenComplete(() {
                              Provider.of<PostFunctions>(context, listen: false)
                                  .addComent(context, snapshot.data()['PostId'],
                                      commentController.text);
                            }).whenComplete(() async {
                              commentController.clear();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
