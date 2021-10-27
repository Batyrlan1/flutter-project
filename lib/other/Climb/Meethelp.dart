import 'package:Tau/Sign/Auth.dart';
import 'package:Tau/Sign/Firebaseoperations.dart';
import 'package:Tau/other/Profile/AltProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MeetHelp with ChangeNotifier {
  TextEditingController commentController = TextEditingController();

  Future addComent(BuildContext context, String climbId) async {
    return FirebaseFirestore.instance
        .collection("Climb")
        .doc(climbId)
        .collection("comments")
        .doc(commentController.text)
        .set({
      "Comment": commentController.text,
      "Name": Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      "Uid": Provider.of<CurrentUser>(context, listen: false).getUid,
      "Avatar": Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserAvatar,
      "Surename": Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserSurename,
      "Time": Timestamp.now(),
    });
  }

  showClimbCommentsSheet(
      BuildContext context, DocumentSnapshot snapshot, String climbId) {
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
                "Дисскусия",
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
                              .collection("Climb")
                              .doc(climbId)
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
                                                          .data()['Avatar']),
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
                                              documentSnapshot.data()['Name'],
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
                                            documentSnapshot.data()['Comment'],
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
                    height: 20,
                  ),
                  Divider(
                    endIndent: 10,
                    indent: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
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
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
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
                                addComent(
                                  context,
                                  snapshot.data()['ClimbId'],
                                );
                              }).whenComplete(() {
                                commentController.clear();
                                notifyListeners();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
