import 'package:Tau/Sign/Auth.dart';
import 'package:Tau/other/dataController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Profile/AltProfile.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();

  QuerySnapshot snapshotData;
  bool isExcecuted = false;
  @override
  Widget build(BuildContext context) {
    Widget searchedData() {
      return ListView.builder(
        itemCount: snapshotData.docs.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              if (snapshotData.docs[index].data()["uid"] !=
                  Provider.of<CurrentUser>(context, listen: false).getUid) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AltProfile(
                              userUid: snapshotData.docs[index].data()["uid"],
                            )));
              }
            },
            child: ListTile(
              leading: Container(
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 0.8,
                      color: Color(0xFF7A9BEE),
                    )),
                child: Container(
                  height: 27,
                  width: 27,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(
                          snapshotData.docs[index].data()['avatar']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              title: Transform(
                transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
                child: Row(
                  children: [
                    Text(snapshotData.docs[index].data()['surename']),
                    SizedBox(width: 4),
                    Text(snapshotData.docs[index].data()['name']),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          width: 250,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextFormField(
            controller: searchController,
            cursorColor: Color(0xFF7A9BEE),
            decoration: InputDecoration(
              hintText: "Поиск пользователей",
              hintStyle:
                  GoogleFonts.montserrat(fontSize: 14, color: Colors.grey[400]),
              contentPadding: EdgeInsets.only(
                left: 10,
                bottom: 10,
              ),
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
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
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.arrow_left,
            color: Colors.black,
            size: 18,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          GetBuilder<DataController>(
            init: DataController(),
            builder: (val) {
              return IconButton(
                icon: Icon(
                  CupertinoIcons.search,
                  color: Colors.black,
                  size: 18,
                ),
                onPressed: () {
                  val.queryData(searchController.text).then((value) {
                    snapshotData = value;
                    setState(() {
                      isExcecuted = true;
                    });
                  });
                },
              );
            },
          ),
        ],
      ),
      body: isExcecuted ? searchedData() : Container(),
    );
  }
}
