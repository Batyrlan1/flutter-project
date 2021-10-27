import 'package:Tau/Sign/Auth.dart';
import 'package:Tau/Sign/Firebaseoperations.dart';
import 'package:Tau/other/Profile/Alternateprofile.dart';
import 'package:Tau/other/upLoadPost/PostOptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AltProfile extends StatefulWidget {
  final String userUid;
  AltProfile({@required this.userUid});

  @override
  _AltProfileState createState() => _AltProfileState();
}

class _AltProfileState extends State<AltProfile> {
  bool follow = false;
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkIfFollowinClimb();
  }

  checkIfFollowinClimb() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(Provider.of<CurrentUser>(context, listen: false).getUid)
        .collection("following")
        .doc(
          widget.userUid,
        )
        .get();

    setState(() {
      follow = doc.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          Provider.of<AlternateProfile>(context, listen: false).appBar(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width,
          child: ListView(children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(widget.userUid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.black54),
                    ),
                  );
                } else {
                  return Stack(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 12,
                              spreadRadius: 7,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        width: 0.8,
                                        color: Color(0xFF7A9BEE),
                                      )),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.12,
                                    width: MediaQuery.of(context).size.width *
                                        0.22,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            snapshot.data.data()['avatar']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                        top: 5,
                                      ),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  snapshot.data
                                                      .data()['surename'],
                                                  style: GoogleFonts.roboto(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  snapshot.data.data()['name'],
                                                  style: GoogleFonts.roboto(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    snapshot.data.data()['Bio'],
                                                    style: GoogleFonts.roboto(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Container(
                                                child: (() {
                                              if (follow) {
                                                return Container(
                                                  padding: EdgeInsets.only(
                                                      right: 20),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.04,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.55,
                                                  child: Material(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    shadowColor:
                                                        Colors.blueAccent,
                                                    color: Color(0xFF7A9BEE),
                                                    elevation: 7.0,
                                                    child: FlatButton(
                                                      onPressed: () async {
                                                        Provider.of<FirebaseOperations>(
                                                                context,
                                                                listen: false)
                                                            .initUserData(
                                                                context)
                                                            .whenComplete(() {
                                                          Provider.of<FirebaseOperations>(
                                                                  context,
                                                                  listen: false)
                                                              .deletefollowUser(
                                                            widget.userUid,
                                                            Provider.of<CurrentUser>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .getUid,
                                                            Provider.of<CurrentUser>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .getUid,
                                                            widget.userUid,
                                                          );
                                                        });
                                                        setState(() {
                                                          follow = false;
                                                        });
                                                      },
                                                      child: Center(
                                                        child: Text(
                                                          "Отписаться",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else if (!follow) {
                                                return Container(
                                                  padding: EdgeInsets.only(
                                                      right: 20),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.04,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.55,
                                                  child: Material(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    shadowColor:
                                                        Colors.blueAccent,
                                                    color: Color(0xFF7A9BEE),
                                                    elevation: 7.0,
                                                    child: FlatButton(
                                                      onPressed: () async {
                                                        Provider.of<FirebaseOperations>(
                                                                context,
                                                                listen: false)
                                                            .initUserData(
                                                                context)
                                                            .whenComplete(() {
                                                          Provider.of<FirebaseOperations>(
                                                                  context,
                                                                  listen: false)
                                                              .followUser(
                                                                  widget
                                                                      .userUid,
                                                                  Provider.of<CurrentUser>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .getUid,
                                                                  {
                                                                    "Uid": Provider.of<CurrentUser>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .getUid,
                                                                    "name": Provider.of<FirebaseOperations>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .getInitUserName,
                                                                    "avatar": Provider.of<FirebaseOperations>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .getInitUserAvatar,
                                                                    "Surename": Provider.of<FirebaseOperations>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .getInitUserSurename,
                                                                    "Time":
                                                                        Timestamp
                                                                            .now(),
                                                                  },
                                                                  Provider.of<CurrentUser>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .getUid,
                                                                  widget
                                                                      .userUid,
                                                                  {
                                                                    "name": snapshot
                                                                            .data
                                                                            .data()[
                                                                        "name"],
                                                                    "surename":
                                                                        snapshot
                                                                            .data
                                                                            .data()['surename'],
                                                                    "avatar": snapshot
                                                                            .data
                                                                            .data()[
                                                                        'avatar'],
                                                                    "uid": snapshot
                                                                            .data
                                                                            .data()[
                                                                        "uid"],
                                                                    " time":
                                                                        Timestamp
                                                                            .now(),
                                                                  });
                                                        });
                                                        setState(() {
                                                          follow = true;
                                                        });
                                                      },
                                                      child: Center(
                                                        child: Text(
                                                          'Подписаться',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            }()))
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 14, right: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("Users")
                                            .doc(snapshot.data.data()["uid"])
                                            .collection("Posts")
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child: Container(
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                          Colors.transparent),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Text(
                                              snapshot.data.docs.length
                                                  .toString(),
                                              style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            );
                                          }
                                        }),
                                    Text(
                                      "Публикации",
                                      style: GoogleFonts.roboto(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    checkFollowingSheet(context, snapshot);
                                  },
                                  child: Column(
                                    children: [
                                      StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("Users")
                                              .doc(snapshot.data.data()["uid"])
                                              .collection("following")
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                child: Container(
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            Colors.transparent),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Text(
                                                snapshot.data.docs.length
                                                    .toString(),
                                                style: GoogleFonts.roboto(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              );
                                            }
                                          }),
                                      Text(
                                        "Подписки",
                                        style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    checkFollowerSheet(context, snapshot);
                                  },
                                  child: Column(
                                    children: [
                                      StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("Users")
                                              .doc(snapshot.data.data()["uid"])
                                              .collection("followers")
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                child: Container(
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            Colors.transparent),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Text(
                                                snapshot.data.docs.length
                                                    .toString(),
                                                style: GoogleFonts.roboto(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              );
                                            }
                                          }),
                                      Text("Подписчики",
                                          style: GoogleFonts.roboto(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              buildProfilePosts(context, snapshot)
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ]),
        ),
      ),
    );
  }

  buildProfilePosts(BuildContext context, dynamic snapshot) {
    return Column(children: [
      StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(snapshot.data.data()["uid"])
              .collection("Posts")
              .orderBy("Time", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.black54),
                  ),
                ),
              );
            } else {
              return Column(
                  children: snapshot.data.docs
                      .map((DocumentSnapshot documentSnapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.black54),
                      ),
                    ),
                  );
                } else {
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
                                    Provider.of<CurrentUser>(context,
                                            listen: false)
                                        .getUid) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AltProfile(
                                                userUid: documentSnapshot
                                                    .data()["Uid"],
                                              )));
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      width: 0.5,
                                      color: Color(0xFF7A9BEE),
                                    )),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  width:
                                      MediaQuery.of(context).size.width * 0.07,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          documentSnapshot.data()['avatar']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            title: Transform(
                              transform:
                                  Matrix4.translationValues(-18.0, 0.0, 0.0),
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
                                Provider.of<CurrentUser>(context, listen: false)
                                            .getUid ==
                                        documentSnapshot.data()["Uid"]
                                    ? GestureDetector(
                                        onTap: () {
                                          Provider.of<PostFunctions>(context,
                                                  listen: false)
                                              .showPostOptions(
                                            context,
                                            documentSnapshot.data()['PostId'],
                                          );
                                        },
                                        child: Icon(
                                          CupertinoIcons.ellipsis,
                                          size: 17,
                                          color: Colors.black,
                                        ),
                                      )
                                    : Container(
                                        width: 0,
                                        height: 0,
                                      )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 8, bottom: 10),
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
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .initUserData(context)
                              .whenComplete(() {
                            Provider.of<PostFunctions>(context, listen: false)
                                .addLike(
                              context,
                              documentSnapshot.data()['PostId'],
                              Provider.of<CurrentUser>(context, listen: false)
                                  .getUid,
                            )
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
                                "Avatar": Provider.of<FirebaseOperations>(
                                        context,
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
                                    Provider.of<PostFunctions>(context,
                                            listen: false)
                                        .showLikessSheet(
                                      context,
                                      documentSnapshot.data()['PostId'],
                                    );
                                  },
                                  onTap: () {
                                    Provider.of<FirebaseOperations>(context,
                                            listen: false)
                                        .initUserData(context)
                                        .whenComplete(() {
                                      Provider.of<PostFunctions>(context,
                                              listen: false)
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
                                            .doc(documentSnapshot
                                                .data()['PostId'])
                                            .set({
                                          "Type": "like",
                                          "Name":
                                              Provider.of<FirebaseOperations>(
                                                      context,
                                                      listen: false)
                                                  .getInitUserName,
                                          "Uid": Provider.of<CurrentUser>(
                                                  context,
                                                  listen: false)
                                              .getUid,
                                          "Avatar":
                                              Provider.of<FirebaseOperations>(
                                                      context,
                                                      listen: false)
                                                  .getInitUserAvatar,
                                          "Surename":
                                              Provider.of<FirebaseOperations>(
                                                      context,
                                                      listen: false)
                                                  .getInitUserSurename,
                                          "Image": documentSnapshot
                                              .data()['PostImage'],
                                          "Time": Timestamp.now(),
                                          "PostId":
                                              documentSnapshot.data()['PostId'],
                                        });
                                      });
                                    });
                                  },
                                  child: Icon(
                                    CupertinoIcons.heart,
                                    size: 23,
                                  ),
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
                                            valueColor: AlwaysStoppedAnimation(
                                                Colors.white),
                                          ),
                                        );
                                      } else {
                                        return Padding(
                                          padding:
                                              EdgeInsets.only(top: 5, left: 2),
                                          child: Text(
                                            snapshot.data.docs.length
                                                .toString(),
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
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.black54),
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
                }
              }).toList());
            }
          }),
    ]);
  }

  checkFollowerSheet(BuildContext context, dynamic snapshot) {
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
                "Подписчики",
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            body: Container(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(snapshot.data.data()["uid"])
                      .collection("followers")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Container(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                      );
                    } else {
                      return ListView(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot documentSnapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Container(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.black54),
                              ),
                            ),
                          );
                        } else {
                          return ListTile(
                            onTap: () {
                              if (documentSnapshot.data()["uid"] !=
                                  Provider.of<CurrentUser>(context,
                                          listen: false)
                                      .getUid) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AltProfile(
                                              userUid: documentSnapshot
                                                  .data()["Uid"],
                                            )));
                              }
                            },
                            leading: Container(
                              padding: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xFF7A9BEE),
                                  )),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.044,
                                width:
                                    MediaQuery.of(context).size.width * 0.082,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        documentSnapshot.data()['avatar']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            title: Transform(
                              transform:
                                  Matrix4.translationValues(-8.0, 0.0, 0.0),
                              child: Row(children: [
                                Text(
                                  documentSnapshot.data()['Surename'],
                                  style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  documentSnapshot.data()['name'],
                                  style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ]),
                            ),
                          );
                        }
                      }).toList());
                    }
                  }),
            ),
          );
        });
  }

  checkFollowingSheet(BuildContext context, dynamic snapshot) {
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
                "Подписки",
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            body: Container(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(snapshot.data.data()["uid"])
                      .collection("following")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Container(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.black54),
                          ),
                        ),
                      );
                    } else {
                      return ListView(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot documentSnapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Container(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.black54),
                              ),
                            ),
                          );
                        } else {
                          return ListTile(
                            onTap: () {
                              if (documentSnapshot.data()["Uid"] !=
                                  Provider.of<CurrentUser>(context,
                                          listen: false)
                                      .getUid) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AltProfile(
                                              userUid: documentSnapshot
                                                  .data()["uid"],
                                            )));
                              }
                            },
                            leading: Container(
                              padding: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xFF7A9BEE),
                                  )),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.044,
                                width:
                                    MediaQuery.of(context).size.width * 0.082,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        documentSnapshot.data()['avatar']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            title: Transform(
                              transform:
                                  Matrix4.translationValues(-8.0, 0.0, 0.0),
                              child: Row(children: [
                                Text(
                                  documentSnapshot.data()['surename'],
                                  style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  documentSnapshot.data()['name'],
                                  style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ]),
                            ),
                          );
                        }
                      }).toList());
                    }
                  }),
            ),
          );
        });
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
