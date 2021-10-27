import 'package:Tau/Sign/Auth.dart';
import 'package:Tau/Sign/Firebaseoperations.dart';
import 'package:Tau/other/Climb/Meethelp.dart';
import 'package:Tau/other/Profile/AltProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Myclimb extends StatefulWidget {
  Myclimb({Key key}) : super(key: key);

  @override
  _MyclimbState createState() => _MyclimbState();
}

class _MyclimbState extends State<Myclimb> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "Мой Climb",
          style: GoogleFonts.montserrat(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
        ),
        leading: IconButton(
            icon: Icon(
              CupertinoIcons.arrow_left,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(Provider.of<CurrentUser>(context, listen: false).getUid)
              .collection("Climb")
              .orderBy("ClimbCreated", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.black54),
                ),
              );
            } else {
              return ListView(
                  children: snapshot.data.docs
                      .map((DocumentSnapshot documentSnapshot) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Material(
                          color: Colors.white,
                          elevation: 0.5,
                          child: Container(
                            padding: EdgeInsets.only(left: 15),
                            height: 75,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (documentSnapshot.data()["Uid"] !=
                                            Provider.of<CurrentUser>(context,
                                                    listen: false)
                                                .getUid) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AltProfile(
                                                        userUid:
                                                            documentSnapshot
                                                                .data()["Uid"],
                                                      )));
                                        }
                                      },
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.046,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.084,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(13),
                                          image: DecorationImage(
                                            image: NetworkImage(documentSnapshot
                                                .data()['Avatar']),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      documentSnapshot.data()['Name'],
                                      style: GoogleFonts.montserrat(
                                          color: Colors.grey[400],
                                          fontSize: 9,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      documentSnapshot.data()['Climb'],
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                                Provider.of<CurrentUser>(context, listen: false)
                                            .getUid ==
                                        documentSnapshot.data()["Uid"]
                                    ? Container(
                                        margin: EdgeInsets.only(left: 25),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.068,
                                        child: GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return bottomSheet(
                                                    context,
                                                    documentSnapshot
                                                        .data()['ClimbId'],
                                                  );
                                                });
                                          },
                                          child: Icon(
                                            Icons.more_horiz,
                                            size: 22,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 0,
                                        width: 0,
                                      ),
                              ],
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.white,
                          elevation: 0.5,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 16,
                                  top: 10,
                                  child: Text(
                                    "Город",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.grey[400],
                                        fontSize: 9,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Positioned(
                                  left: 16,
                                  top: 23,
                                  child: Text(
                                    documentSnapshot.data()['City'],
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Positioned(
                                  right: 80,
                                  top: 10,
                                  child: Text(
                                    "Дата",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.grey[400],
                                        fontSize: 9,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Positioned(
                                  right: 23,
                                  top: 23,
                                  child: Text(
                                    documentSnapshot.data()['Date'],
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Positioned(
                                  left: 16,
                                  top: 65,
                                  child: Text(
                                    "Место встречи",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.grey[400],
                                        fontSize: 9,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Positioned(
                                  left: 16,
                                  top: 78,
                                  child: Text(
                                    documentSnapshot.data()['Place'],
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Positioned(
                                  right: 74,
                                  top: 65,
                                  child: Text(
                                    "Время",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.grey[400],
                                        fontSize: 9,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Positioned(
                                  right: 64,
                                  top: 78,
                                  child: Text(
                                    documentSnapshot.data()['Time'],
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Positioned(
                                  left: 15,
                                  top: 190,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.15),
                                            offset: Offset(6, 2),
                                            blurRadius: 6.0,
                                            spreadRadius: 1.0,
                                          ),
                                          BoxShadow(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 0.15),
                                            offset: Offset(-6, -2),
                                            blurRadius: 6.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ]),
                                    child: GestureDetector(
                                      onTap: () {
                                        checkFollowerSheet(
                                            context, documentSnapshot);
                                      },
                                      child: Container(
                                        child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection("Climb")
                                                .doc(documentSnapshot
                                                    .data()["ClimbId"])
                                                .collection("followers")
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            Colors.white),
                                                  ),
                                                );
                                              } else {
                                                return new ListView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    children: snapshot.data.docs
                                                        .map((DocumentSnapshot
                                                            documentSnapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation(
                                                                    Colors
                                                                        .white),
                                                          ),
                                                        );
                                                      } else {
                                                        return Row(
                                                          children: [
                                                            Container(
                                                              width: 28,
                                                              height: 28,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                image:
                                                                    DecorationImage(
                                                                  image: NetworkImage(
                                                                      documentSnapshot
                                                                              .data()[
                                                                          'avatar']),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 8),
                                                          ],
                                                        );
                                                      }
                                                    }).toList());
                                              }
                                            }),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    right: 20,
                                    top: 190,
                                    child: GestureDetector(
                                      onTap: () {
                                        Provider.of<MeetHelp>(context,
                                                listen: false)
                                            .showClimbCommentsSheet(
                                                context,
                                                documentSnapshot,
                                                documentSnapshot
                                                    .data()["ClimbId"]);
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.112,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.2),
                                                offset: Offset(6, 2),
                                                blurRadius: 6.0,
                                                spreadRadius: 1.0,
                                              ),
                                              BoxShadow(
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 0.2),
                                                offset: Offset(-6, -2),
                                                blurRadius: 6.0,
                                                spreadRadius: 1.0,
                                              ),
                                            ]),
                                        child: Container(
                                          width: 18,
                                          height: 18,
                                          child: Icon(
                                            CupertinoIcons.bubble_left,
                                            color: Colors.grey[800],
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    )),
                                Positioned(
                                  right: 14,
                                  top: 220,
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection("Climb")
                                          .doc(documentSnapshot
                                              .data()["ClimbId"])
                                          .collection("comments")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Colors.white),
                                            ),
                                          );
                                        } else {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                top: 5, left: 2),
                                            child: Text(
                                              snapshot.data.docs.length
                                                  .toString(),
                                              style: GoogleFonts.roboto(
                                                  color: Colors.grey[400],
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          );
                                        }
                                      }),
                                ),
                                Positioned(
                                  left: 16,
                                  top: 120,
                                  child: Text(
                                    "Примечание",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.grey[400],
                                        fontSize: 9,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Positioned(
                                  left: 16,
                                  top: 130,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.56,
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: Text(
                                      documentSnapshot.data()['Comment'],
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 24,
                                  top: 120,
                                  child: Text(
                                    "Доступное кол-во ",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.grey[400],
                                        fontSize: 9,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Positioned(
                                  right: 74,
                                  top: 133,
                                  child: Row(
                                    children: [
                                      StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("Climb")
                                              .doc(documentSnapshot
                                                  .data()["ClimbId"])
                                              .collection("followers")
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                          Colors.white),
                                                ),
                                              );
                                            } else {
                                              return Text(
                                                snapshot.data.docs.length
                                                    .toString(),
                                                style: GoogleFonts.montserrat(
                                                    color: Colors.grey[400],
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              );
                                            }
                                          }),
                                      Text(
                                        "/",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.grey[400],
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        documentSnapshot.data()['Quontaty'],
                                        style: GoogleFonts.montserrat(
                                            color: Colors.grey[400],
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }).toList());
            }
          },
        ),
      ),
    );
  }

  checkFollowerSheet(BuildContext context, dynamic documentSnapshot) {
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
                      .collection("Climb")
                      .doc(documentSnapshot.data()["ClimbId"])
                      .collection("followers")
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
                                  Matrix4.translationValues(-10.0, 0.0, 0.0),
                              child: Row(children: [
                                Text(
                                  documentSnapshot.data()['Surename'],
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
                          );
                        }
                      }).toList());
                    }
                  }),
            ),
          );
        });
  }

  bottomSheet(BuildContext context, String climbId) {
    return Container(
      color: Color(0xff757575),
      height: 160,
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Свойства",
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Divider(
                color: Colors.black54,
                height: 1,
                indent: 20,
                endIndent: 20,
              ),
              FlatButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Вы действительно хотите удалить climb?",
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
                                    .deleteUserClimbData(context, climbId)
                                    .whenComplete(() {
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
                child: Text('Удалить climb',
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 14,
                    )),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Отмена',
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 14,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bottomSheetClimb(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      height: 215,
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Ваши действия",
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Divider(
                color: Colors.black,
                indent: 20,
                endIndent: 20,
              ),
              FlatButton(
                onPressed: () {},
                child: Text('Climbs',
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 16,
                    )),
              ),
              FlatButton(
                onPressed: () {},
                child: Text('Я иду',
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 16,
                    )),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Закрыть',
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 16,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
