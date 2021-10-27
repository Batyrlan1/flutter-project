import 'package:Tau/Sign/Auth.dart';
import 'package:Tau/Sign/Firebaseoperations.dart';
import 'package:Tau/other/Climb/FollowClimb.dart';
import 'package:Tau/other/Climb/Meethelp.dart';
import 'package:Tau/other/Climb/Myclimbs.dart';
import 'package:Tau/other/Climb/climb.dart';
import 'package:Tau/other/Climb/geolocation.dart';
import 'package:Tau/other/Climb/places.dart';
import 'package:Tau/other/Profile/AltProfile.dart';
import 'package:Tau/other/dataController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MeetPage extends StatefulWidget {
  final String address;

  MeetPage({
    this.address,
  });

  @override
  _MeetPageState createState() => _MeetPageState(address);
}

var filterHeight = 0.0;
String climbId;

QuerySnapshot snapshotData;
bool isExcecuted = false;

ScrollController _scrollController = ScrollController();

class _MeetPageState extends State<MeetPage> {
  @override
  final String address;

  _MeetPageState(this.address);

  @override
  Widget build(BuildContext context) {
    Widget searchedData() {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.678,
        child: ListView(
            children:
                snapshotData.docs.map((DocumentSnapshot documentSnapshot) {
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
                                            builder: (context) => AltProfile(
                                                  userUid: documentSnapshot
                                                      .data()["Uid"],
                                                )));
                                  }
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.046,
                                  width:
                                      MediaQuery.of(context).size.width * 0.084,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          documentSnapshot.data()['Avatar']),
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
                                  height: MediaQuery.of(context).size.height *
                                      0.068,
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
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
                      height: 310,
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
                              width: MediaQuery.of(context).size.width * 0.75,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.15),
                                      offset: Offset(6, 2),
                                      blurRadius: 6.0,
                                      spreadRadius: 1.0,
                                    ),
                                    BoxShadow(
                                      color:
                                          Color.fromRGBO(255, 255, 255, 0.15),
                                      offset: Offset(-6, -2),
                                      blurRadius: 6.0,
                                      spreadRadius: 1.0,
                                    ),
                                  ]),
                              child: GestureDetector(
                                onTap: () {
                                  checkFollowerSheet(context, documentSnapshot);
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
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Colors.white),
                                            ),
                                          );
                                        } else {
                                          return new ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: snapshot.data.docs.map(
                                                  (DocumentSnapshot
                                                      documentSnapshot) {
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
                                                  return Row(
                                                    children: [
                                                      Container(
                                                        width: 28,
                                                        height: 28,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(25),
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                documentSnapshot
                                                                        .data()[
                                                                    'avatar']),
                                                            fit: BoxFit.cover,
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
                                  Provider.of<MeetHelp>(context, listen: false)
                                      .showClimbCommentsSheet(
                                          context,
                                          documentSnapshot,
                                          documentSnapshot.data()["ClimbId"]);
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.112,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.2),
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
                                    .doc(documentSnapshot.data()["ClimbId"])
                                    .collection("comments")
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
                                      padding: EdgeInsets.only(top: 5, left: 2),
                                      child: Text(
                                        snapshot.data.docs.length.toString(),
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
                              width: MediaQuery.of(context).size.width * 0.56,
                              height: MediaQuery.of(context).size.height * 0.1,
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
                              top: 255,
                              left: 40,
                              child: (() {
                                if (Provider.of<CurrentUser>(context,
                                            listen: false)
                                        .getUid ==
                                    documentSnapshot.data()["Uid"]) {
                                  return Container(
                                    height: 0,
                                    width: 0,
                                  );
                                } else {
                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: 35,
                                    child: Material(
                                      borderRadius: BorderRadius.circular(15),
                                      shadowColor: Colors.blueAccent,
                                      color: Color(0xFF7A9BEE),
                                      elevation: 7.0,
                                      child: FlatButton(
                                        onPressed: () async {
                                          Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false)
                                              .initUserData(context)
                                              .whenComplete(() {
                                            Provider.of<FirebaseOperations>(
                                                    context,
                                                    listen: false)
                                                .deleteFollowClimb(
                                                    context,
                                                    documentSnapshot
                                                        .data()['ClimbId'],
                                                    Provider.of<CurrentUser>(
                                                            context,
                                                            listen: false)
                                                        .getUid);
                                          });
                                        },
                                        child: Center(
                                          child: Text(
                                            "Отписаться",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }())),
                          Positioned(
                              top: 255,
                              right: 40,
                              child: (() {
                                if (Provider.of<CurrentUser>(context,
                                            listen: false)
                                        .getUid ==
                                    documentSnapshot.data()["Uid"]) {
                                  return Container(
                                    height: 0,
                                    width: 0,
                                  );
                                } else {
                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: 35,
                                    child: Material(
                                      borderRadius: BorderRadius.circular(15),
                                      shadowColor: Colors.blueAccent,
                                      color: Color(0xFF7A9BEE),
                                      elevation: 7.0,
                                      child: FlatButton(
                                        onPressed: () async {
                                          Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false)
                                              .initUserData(context)
                                              .whenComplete(() {
                                            Provider.of<FirebaseOperations>(
                                                    context,
                                                    listen: false)
                                                .followClimb(
                                                    context,
                                                    documentSnapshot
                                                        .data()['ClimbId'],
                                                    Provider.of<CurrentUser>(
                                                            context,
                                                            listen: false)
                                                        .getUid);
                                          }).whenComplete(() async {
                                            await FirebaseFirestore.instance
                                                .collection("Users")
                                                .doc(Provider.of<CurrentUser>(
                                                        context,
                                                        listen: false)
                                                    .getUid)
                                                .collection("FollowClimb")
                                                .doc(
                                                  documentSnapshot
                                                      .data()['ClimbId'],
                                                )
                                                .set({
                                              "Climb": documentSnapshot
                                                  .data()['Climb'],
                                              "Category": documentSnapshot
                                                  .data()['Category'],
                                              "Date": documentSnapshot
                                                  .data()['Date'],
                                              "Time": documentSnapshot
                                                  .data()['Time'],
                                              "City": documentSnapshot
                                                  .data()['City'],
                                              "Place": documentSnapshot
                                                  .data()['Place'],
                                              "Comment": documentSnapshot
                                                  .data()['Comment'],
                                              "Quontaty": documentSnapshot
                                                  .data()['Quontaty'],
                                              "ClimbCreated": Timestamp.now(),
                                              "ClimbId": documentSnapshot
                                                  .data()['ClimbId'],
                                              "Uid": documentSnapshot
                                                  .data()['Uid'],
                                              "Name": documentSnapshot
                                                  .data()['Name'],
                                              "Avatar": documentSnapshot
                                                  .data()['Avatar'],
                                              "Surename": documentSnapshot
                                                  .data()['Surename'],
                                            });
                                          });
                                        },
                                        child: Center(
                                          child: Text(
                                            "Я с вами",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }())),
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
                                        .doc(documentSnapshot.data()["ClimbId"])
                                        .collection("followers")
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
                                        return Text(
                                          snapshot.data.docs.length.toString(),
                                          style: GoogleFonts.montserrat(
                                              color: Colors.grey[400],
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
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
        }).toList()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.bars,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return bottomSheetClimb(context);
                });
          },
        ),
        actions: [
          IconButton(
              icon: Icon(
                CupertinoIcons.plus_app,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateClimb()));
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Material(
                color: Colors.white,
                elevation: 3.0,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.28,
                  height: MediaQuery.of(context).size.height * 0.038,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Myclimb()));
                    },
                    child: Center(
                      child: Text(
                        "Мой Climb",
                        style: GoogleFonts.montserrat(
                            fontSize: 8,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.white,
                elevation: 3.0,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.28,
                  height: MediaQuery.of(context).size.height * 0.038,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FollowClimb()));
                    },
                    child: Center(
                      child: Text(
                        "Мои встречи",
                        style: GoogleFonts.montserrat(
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: RaisedButton(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Выберите свой город",
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                onPressed: () {
                  setState(() {
                    filterHeight = (filterHeight == 0.0
                        ? MediaQuery.of(context).size.height * 0.5
                        : 0.0);
                  });
                },
              ),
            ),
            AnimatedContainer(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 5),
                        SearchInjector(
                          child: SafeArea(
                            child: Consumer<LocationApi>(
                              builder: (_, api, child) => SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Material(
                                      elevation: 1.0,
                                      borderRadius: BorderRadius.circular(15),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.75,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.062,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: TextFormField(
                                          controller: api.adressController,
                                          onChanged: api.handleSearch,
                                          cursorColor: Color(0xFF7A9BEE),
                                          decoration: InputDecoration(
                                            suffixIcon: Icon(
                                                CupertinoIcons.search,
                                                size: 18),
                                            hintStyle: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                color: Colors.black),
                                            contentPadding: EdgeInsets.only(
                                              left: 10,
                                              top: 7,
                                            ),
                                            border: InputBorder.none,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0)),
                                              borderSide: BorderSide(
                                                color: Color(0xFF7A9BEE),
                                              ),
                                            ),
                                          ),
                                          style: GoogleFonts.montserrat(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.27,
                                      color: Colors.white54,
                                      child: StreamBuilder<List<Place>>(
                                          stream: api.controllerOut,
                                          builder: (context, snapshot) {
                                            if (snapshot.data == null) {
                                              return Center(
                                                child: Text(
                                                  "Город не найден",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                              );
                                            }
                                            final data = snapshot.data;
                                            return Scrollbar(
                                              controller: _scrollController,
                                              child: SingleChildScrollView(
                                                controller: _scrollController,
                                                child: Container(
                                                  child: Builder(
                                                      builder: (context) {
                                                    return Column(
                                                      children: List.generate(
                                                        data.length,
                                                        (index) {
                                                          final place =
                                                              data[index];
                                                          return ListTile(
                                                            onTap: () {
                                                              api.adressController
                                                                      .text =
                                                                  "${place.locality}";
                                                            },
                                                            title: Text(
                                                                "${place.locality}"),
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                    SizedBox(height: 5),
                                    GetBuilder<DataClimbController>(
                                      init: DataClimbController(),
                                      builder: (val) {
                                        return Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.27,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.038,
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            shadowColor: Colors.blueAccent,
                                            color: Color(0xFF7A9BEE),
                                            elevation: 7.0,
                                            child: FlatButton(
                                              onPressed: () {
                                                val
                                                    .queryData(api
                                                        .adressController.text)
                                                    .then((value) {
                                                  snapshotData = value;
                                                  setState(() {
                                                    isExcecuted = true;
                                                  });
                                                }).whenComplete(() {
                                                  api.adressController.clear();
                                                }).whenComplete(() {
                                                  setState(() {
                                                    filterHeight =
                                                        (filterHeight == 0.0
                                                            ? 300.0
                                                            : 0.0);
                                                  });
                                                }).whenComplete(() {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                });
                                              },
                                              child: Center(
                                                child: Text(
                                                  "Выбрать",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.82,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Если в вашем городе ничего не найдено, ",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                          Text(
                                            "вы сами можете создать cвой climb ",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              duration: const Duration(milliseconds: 400),
              curve: Curves.fastOutSlowIn,
              height: filterHeight,
            ),
            SizedBox(height: 5),
            isExcecuted
                ? searchedData()
                : Container(
                    height: MediaQuery.of(context).size.height * 0.678,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Climb")
                          .orderBy("ClimbCreated", descending: true)
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                GestureDetector(
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
                                                              builder:
                                                                  (context) =>
                                                                      AltProfile(
                                                                        userUid:
                                                                            documentSnapshot.data()["Uid"],
                                                                      )));
                                                    }
                                                  },
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.046,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.084,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            documentSnapshot
                                                                    .data()[
                                                                'Avatar']),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  documentSnapshot
                                                      .data()['Name'],
                                                  style: GoogleFonts.montserrat(
                                                      color: Colors.grey[400],
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height: 40,
                                              child: Center(
                                                child: Text(
                                                  documentSnapshot
                                                      .data()['Climb'],
                                                  style: GoogleFonts.montserrat(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                            Provider.of<CurrentUser>(context,
                                                            listen: false)
                                                        .getUid ==
                                                    documentSnapshot
                                                        .data()["Uid"]
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        left: 25),
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.068,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        showModalBottomSheet(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return bottomSheet(
                                                                context,
                                                                documentSnapshot
                                                                        .data()[
                                                                    'ClimbId'],
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 310,
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
                                                    fontWeight:
                                                        FontWeight.w400),
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
                                                    fontWeight:
                                                        FontWeight.w400),
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
                                                    fontWeight:
                                                        FontWeight.w400),
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
                                                    fontWeight:
                                                        FontWeight.w400),
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
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            Positioned(
                                              left: 16,
                                              top: 78,
                                              child: Text(
                                                documentSnapshot
                                                    .data()['Place'],
                                                style: GoogleFonts.montserrat(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w400),
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
                                                    fontWeight:
                                                        FontWeight.w400),
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
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            Positioned(
                                              left: 15,
                                              top: 190,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.75,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 0.15),
                                                        offset: Offset(6, 2),
                                                        blurRadius: 6.0,
                                                        spreadRadius: 1.0,
                                                      ),
                                                      BoxShadow(
                                                        color: Color.fromRGBO(
                                                            255,
                                                            255,
                                                            255,
                                                            0.15),
                                                        offset: Offset(-6, -2),
                                                        blurRadius: 6.0,
                                                        spreadRadius: 1.0,
                                                      ),
                                                    ]),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    checkFollowerSheet(context,
                                                        documentSnapshot);
                                                  },
                                                  child: Container(
                                                    child: StreamBuilder<
                                                            QuerySnapshot>(
                                                        stream: FirebaseFirestore
                                                            .instance
                                                            .collection("Climb")
                                                            .doc(
                                                                documentSnapshot
                                                                        .data()[
                                                                    "ClimbId"])
                                                            .collection(
                                                                "followers")
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
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
                                                            return new ListView(
                                                                scrollDirection:
                                                                    Axis
                                                                        .horizontal,
                                                                children: snapshot
                                                                    .data.docs
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
                                                                            AlwaysStoppedAnimation(Colors.white),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    return Row(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              28,
                                                                          height:
                                                                              28,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(25),
                                                                            image:
                                                                                DecorationImage(
                                                                              image: NetworkImage(documentSnapshot.data()['avatar']),
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                8),
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
                                                    Provider.of<MeetHelp>(
                                                            context,
                                                            listen: false)
                                                        .showClimbCommentsSheet(
                                                            context,
                                                            documentSnapshot,
                                                            documentSnapshot
                                                                    .data()[
                                                                "ClimbId"]);
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.112,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    0.2),
                                                            offset:
                                                                Offset(6, 2),
                                                            blurRadius: 6.0,
                                                            spreadRadius: 1.0,
                                                          ),
                                                          BoxShadow(
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    0.2),
                                                            offset:
                                                                Offset(-6, -2),
                                                            blurRadius: 6.0,
                                                            spreadRadius: 1.0,
                                                          ),
                                                        ]),
                                                    child: Container(
                                                      width: 18,
                                                      height: 18,
                                                      child: Icon(
                                                        CupertinoIcons
                                                            .bubble_left,
                                                        color: Colors.grey[800],
                                                        size: 18,
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                            Positioned(
                                              right: 14,
                                              top: 220,
                                              child: StreamBuilder<
                                                      QuerySnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection("Climb")
                                                      .doc(documentSnapshot
                                                          .data()["ClimbId"])
                                                      .collection("comments")
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation(
                                                                  Colors.white),
                                                        ),
                                                      );
                                                    } else {
                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                left: 2),
                                                        child: Text(
                                                          snapshot
                                                              .data.docs.length
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  color: Colors
                                                                          .grey[
                                                                      400],
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
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
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            Positioned(
                                              left: 16,
                                              top: 130,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.56,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.1,
                                                child: Text(
                                                  documentSnapshot
                                                      .data()['Comment'],
                                                  style: GoogleFonts.montserrat(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                                top: 255,
                                                left: 40,
                                                child: (() {
                                                  if (Provider.of<CurrentUser>(
                                                              context,
                                                              listen: false)
                                                          .getUid ==
                                                      documentSnapshot
                                                          .data()["Uid"]) {
                                                    return Container(
                                                      height: 0,
                                                      width: 0,
                                                    );
                                                  } else {
                                                    return Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                      height: 35,
                                                      child: Material(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        shadowColor:
                                                            Colors.blueAccent,
                                                        color:
                                                            Color(0xFF7A9BEE),
                                                        elevation: 7.0,
                                                        child: FlatButton(
                                                          onPressed: () async {
                                                            Provider.of<FirebaseOperations>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .initUserData(
                                                                    context)
                                                                .whenComplete(
                                                                    () {
                                                              Provider.of<FirebaseOperations>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .deleteFollowClimb(
                                                                      context,
                                                                      documentSnapshot
                                                                              .data()[
                                                                          'ClimbId'],
                                                                      Provider.of<CurrentUser>(
                                                                              context,
                                                                              listen: false)
                                                                          .getUid);
                                                            });
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              "Отписаться",
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }())),
                                            Positioned(
                                                top: 255,
                                                right: 40,
                                                child: (() {
                                                  if (Provider.of<CurrentUser>(
                                                              context,
                                                              listen: false)
                                                          .getUid ==
                                                      documentSnapshot
                                                          .data()["Uid"]) {
                                                    return Container(
                                                      height: 0,
                                                      width: 0,
                                                    );
                                                  } else {
                                                    return Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                      height: 35,
                                                      child: Material(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        shadowColor:
                                                            Colors.blueAccent,
                                                        color:
                                                            Color(0xFF7A9BEE),
                                                        elevation: 7.0,
                                                        child: FlatButton(
                                                          onPressed: () async {
                                                            Provider.of<FirebaseOperations>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .initUserData(
                                                                    context)
                                                                .whenComplete(
                                                                    () {
                                                              Provider.of<FirebaseOperations>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .followClimb(
                                                                      context,
                                                                      documentSnapshot
                                                                              .data()[
                                                                          'ClimbId'],
                                                                      Provider.of<CurrentUser>(
                                                                              context,
                                                                              listen: false)
                                                                          .getUid);
                                                            }).whenComplete(
                                                                    () async {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "Users")
                                                                  .doc(Provider.of<
                                                                              CurrentUser>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .getUid)
                                                                  .collection(
                                                                      "FollowClimb")
                                                                  .doc(
                                                                    documentSnapshot
                                                                            .data()[
                                                                        'ClimbId'],
                                                                  )
                                                                  .set({
                                                                "Climb": documentSnapshot
                                                                        .data()[
                                                                    'Climb'],
                                                                "Category": documentSnapshot
                                                                        .data()[
                                                                    'Category'],
                                                                "Date": documentSnapshot
                                                                        .data()[
                                                                    'Date'],
                                                                "Time": documentSnapshot
                                                                        .data()[
                                                                    'Time'],
                                                                "City": documentSnapshot
                                                                        .data()[
                                                                    'City'],
                                                                "Place": documentSnapshot
                                                                        .data()[
                                                                    'Place'],
                                                                "Comment": documentSnapshot
                                                                        .data()[
                                                                    'Comment'],
                                                                "Quontaty": documentSnapshot
                                                                        .data()[
                                                                    'Quontaty'],
                                                                "ClimbCreated":
                                                                    Timestamp
                                                                        .now(),
                                                                "ClimbId": documentSnapshot
                                                                        .data()[
                                                                    'ClimbId'],
                                                                "Uid": documentSnapshot
                                                                        .data()[
                                                                    'Uid'],
                                                                "Name": documentSnapshot
                                                                        .data()[
                                                                    'Name'],
                                                                "Avatar": documentSnapshot
                                                                        .data()[
                                                                    'Avatar'],
                                                                "Surename": documentSnapshot
                                                                        .data()[
                                                                    'Surename'],
                                                              });
                                                            });
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              "Я с вами",
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }())),
                                            Positioned(
                                              right: 24,
                                              top: 120,
                                              child: Text(
                                                "Доступное кол-во ",
                                                style: GoogleFonts.montserrat(
                                                    color: Colors.grey[400],
                                                    fontSize: 9,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            Positioned(
                                              right: 74,
                                              top: 133,
                                              child: Row(
                                                children: [
                                                  StreamBuilder<QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection("Climb")
                                                          .doc(documentSnapshot
                                                                  .data()[
                                                              "ClimbId"])
                                                          .collection(
                                                              "followers")
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
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
                                                          return Text(
                                                            snapshot.data.docs
                                                                .length
                                                                .toString(),
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                    color: Colors
                                                                            .grey[
                                                                        400],
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                          );
                                                        }
                                                      }),
                                                  Text(
                                                    "/",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            color: Colors
                                                                .grey[400],
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  ),
                                                  Text(
                                                    documentSnapshot
                                                        .data()['Quontaty'],
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            color: Colors
                                                                .grey[400],
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
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
          ],
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
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Myclimb()));
                },
                child: Text('Мой Climb',
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 16,
                    )),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FollowClimb()));
                },
                child: Text('Мои встречи',
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

class SearchInjector extends StatelessWidget {
  final Widget child;

  const SearchInjector({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocationApi(),
      child: child,
    );
  }
}
