import 'package:Tau/Sign/Auth.dart';
import 'package:Tau/other/Profile/AltProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatRoomPage extends StatefulWidget {
  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          title: Text(
            "Уведомления",
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.4,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Feed")
                .doc(Provider.of<CurrentUser>(context, listen: false).getUid)
                .collection("FeedItems")
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
                return load(context, snapshot);
              }
            },
          ),
        ),
      ),
    );
  }
}

Widget load(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  return ListView(
      children: snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
    return Column(
      children: [
        Container(
          child: ListTile(
            onTap: () {
              if (documentSnapshot.data()["Uid"] !=
                  Provider.of<CurrentUser>(context, listen: false).getUid) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AltProfile(
                              userUid: documentSnapshot.data()["Uid"],
                            )));
              }
            },
            leading: Container(
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
                    image: NetworkImage(documentSnapshot.data()['Avatar']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            title: Transform(
              transform: Matrix4.translationValues(-15.0, 0.0, 0.0),
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
                  documentSnapshot.data()['Name'],
                  style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
              ]),
            ),
            subtitle: Transform(
              transform: Matrix4.translationValues(-15.0, -10.0, 0.0),
              child: Text(
                "Нравится ваша идея",
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 9,
                ),
              ),
            ),
            trailing: Container(
              height: MediaQuery.of(context).size.height * 0.044,
              width: MediaQuery.of(context).size.width * 0.082,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(documentSnapshot.data()['Image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }).toList());
}
