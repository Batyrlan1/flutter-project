import 'package:Tau/Sign/Auth.dart';
import 'package:Tau/Sign/Firebaseoperations.dart';
import 'package:Tau/other/Climb/Searchloc.dart';
import 'package:Tau/pages/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class CreateClimb extends StatefulWidget {
  final String address;
  CreateClimb({this.address});
  @override
  _CreateClimbState createState() => _CreateClimbState(address);
}

class _CreateClimbState extends State<CreateClimb> {
  DateTime _dateTime = DateTime.now();

  final String address;

  _CreateClimbState(this.address);

  Future _selectDate(BuildContext context) async {
    DateTime _dateTimePicker = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2020),
        lastDate: DateTime(2090),
        initialDatePickerMode: DatePickerMode.day,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(
              primaryColor: Color(0xFF7A9BEE),
              accentColor: Color(0xFF7A9BEE),
            ),
            child: child,
          );
        });
    if (_dateTimePicker != null && _dateTimePicker != _dateTime) {
      setState(() {
        _dateTime = _dateTimePicker;
      });
    }
  }

  var climbName = '';
  List<String> categories = [
    "Спорт",
    "Творчество",
    "Образование",
    "Благотворительность",
    "Кулинария",
    "Отдых",
    "Животное",
    "Другое",
  ];

  var place = '';
  var quontaty = '';
  String climbCategory;
  var time = "";
  var comment = "";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String formated = new DateFormat("dd-MM-yyyy").format(_dateTime);
    void _trySubmit() async {
      final isValid = _formKey.currentState.validate();
      FocusScope.of(context).unfocus();

      if (isValid) {
        _formKey.currentState.save();

        String climbId = Uuid().v4();
        await FirebaseFirestore.instance.collection("Climb").doc(climbId).set({
          "Climb": climbName,
          "Category": climbCategory,
          "Date": formated,
          "Time": time,
          "City": address,
          "Place": place,
          "Comment": comment,
          "Quontaty": quontaty,
          "ClimbCreated": Timestamp.now(),
          "ClimbId": climbId,
          "Uid": Provider.of<CurrentUser>(context, listen: false).getUid,
          "Name": Provider.of<FirebaseOperations>(context, listen: false)
              .getInitUserName,
          "Avatar": Provider.of<FirebaseOperations>(context, listen: false)
              .getInitUserAvatar,
          "Surename": Provider.of<FirebaseOperations>(context, listen: false)
              .getInitUserSurename,
        });
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(Provider.of<CurrentUser>(context, listen: false).getUid)
            .collection("Climb")
            .doc(climbId)
            .set({
          "Climb": climbName,
          "Category": climbCategory,
          "Date": formated,
          "Time": time,
          "City": address,
          "Place": place,
          "Comment": comment,
          "Quontaty": quontaty,
          "ClimbCreated": Timestamp.now(),
          "ClimbId": climbId,
          "Uid": Provider.of<CurrentUser>(context, listen: false).getUid,
          "Name": Provider.of<FirebaseOperations>(context, listen: false)
              .getInitUserName,
          "Avatar": Provider.of<FirebaseOperations>(context, listen: false)
              .getInitUserAvatar,
          "Surename": Provider.of<FirebaseOperations>(context, listen: false)
              .getInitUserSurename,
        }).whenComplete(() {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        });
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            centerTitle: true,
            title: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(
                        Provider.of<CurrentUser>(context, listen: false).getUid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.black54),
                      ),
                    );
                  } else {
                    return Text(
                      snapshot.data.data()['name'],
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    );
                  }
                }),
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(
                CupertinoIcons.arrow_left,
                color: Colors.black,
                size: 19,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 35, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Организуйте climb по вашим интересам ",
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ]),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "и находите единомышленников ",
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ]),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Город",
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.062,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.15),
                              offset: Offset(6, 2),
                              blurRadius: 6.0,
                              spreadRadius: 3.0,
                            ),
                            BoxShadow(
                              color: Color.fromRGBO(255, 255, 255, 0.15),
                              offset: Offset(-6, -2),
                              blurRadius: 6.0,
                              spreadRadius: 3.0,
                            ),
                          ]),
                      child: TextFormField(
                        onChanged: (value) {
                          value = address;
                        },
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Searchloc()));
                        },
                        cursorColor: Color(0xFF7A9BEE),
                        decoration: InputDecoration(
                          hintText: address == null
                              ? "Выберите город"
                              : "${address.toString()}",
                          hintStyle: GoogleFonts.montserrat(fontSize: 14),
                          contentPadding: EdgeInsets.only(
                            left: 10,
                            bottom: 10,
                          ),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
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
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Название",
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.062,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.15),
                              offset: Offset(6, 2),
                              blurRadius: 6.0,
                              spreadRadius: 3.0,
                            ),
                            BoxShadow(
                              color: Color.fromRGBO(255, 255, 255, 0.15),
                              offset: Offset(-6, -2),
                              blurRadius: 6.0,
                              spreadRadius: 3.0,
                            ),
                          ]),
                      child: TextFormField(
                        cursorColor: Color(0xFF7A9BEE),
                        key: ValueKey("Climbname"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Название не должно быть пустым";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            climbName = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Название",
                          hintStyle: GoogleFonts.montserrat(
                            fontSize: 14,
                          ),
                          contentPadding: EdgeInsets.only(
                            left: 10,
                            bottom: 10,
                          ),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
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
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Категория",
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.062,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.15),
                                offset: Offset(6, 2),
                                blurRadius: 6.0,
                                spreadRadius: 3.0,
                              ),
                              BoxShadow(
                                color: Color.fromRGBO(255, 255, 255, 0.15),
                                offset: Offset(-6, -2),
                                blurRadius: 6.0,
                                spreadRadius: 3.0,
                              ),
                            ]),
                        child: DropdownButtonFormField<String>(
                          icon: Icon(CupertinoIcons.chevron_down),
                          iconSize: 14,
                          iconEnabledColor: Colors.white,
                          value: climbCategory,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: "Категория",
                            hintStyle: GoogleFonts.montserrat(
                              fontSize: 14,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 10,
                              bottom: 10,
                            ),
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(
                                color: Color(0xFF7A9BEE),
                              ),
                            ),
                          ),
                          items: categories.map((value) {
                            return DropdownMenuItem(
                                value: value, child: Text(value));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              climbCategory = value;
                            });
                          },
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Дата и время",
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.062,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.15),
                                  offset: Offset(6, 2),
                                  blurRadius: 6.0,
                                  spreadRadius: 3.0,
                                ),
                                BoxShadow(
                                  color: Color.fromRGBO(255, 255, 255, 0.15),
                                  offset: Offset(-6, -2),
                                  blurRadius: 6.0,
                                  spreadRadius: 3.0,
                                ),
                              ]),
                          child: TextFormField(
                            onTap: () {
                              setState(() {
                                _selectDate(context);
                              });
                            },
                            readOnly: true,
                            cursorColor: Color(0xFF7A9BEE),
                            decoration: InputDecoration(
                              hintText: "${formated.toString()}",
                              hintStyle: GoogleFonts.montserrat(
                                fontSize: 14,
                              ),
                              contentPadding: EdgeInsets.only(
                                left: 10,
                                bottom: 10,
                              ),
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
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
                        Padding(
                          padding: const EdgeInsets.only(left: 36),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.height * 0.062,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.15),
                                    offset: Offset(6, 2),
                                    blurRadius: 6.0,
                                    spreadRadius: 3.0,
                                  ),
                                  BoxShadow(
                                    color: Color.fromRGBO(255, 255, 255, 0.15),
                                    offset: Offset(-6, -2),
                                    blurRadius: 6.0,
                                    spreadRadius: 3.0,
                                  ),
                                ]),
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Название не должно быть пустым";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  time = value;
                                });
                              },
                              cursorColor: Color(0xFF7A9BEE),
                              decoration: InputDecoration(
                                hintText: "00:00",
                                hintStyle: GoogleFonts.montserrat(
                                  fontSize: 14,
                                ),
                                contentPadding: EdgeInsets.only(
                                  left: 10,
                                  bottom: 10,
                                ),
                                border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
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
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Место",
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.062,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.15),
                              offset: Offset(6, 2),
                              blurRadius: 6.0,
                              spreadRadius: 3.0,
                            ),
                            BoxShadow(
                              color: Color.fromRGBO(255, 255, 255, 0.15),
                              offset: Offset(-6, -2),
                              blurRadius: 6.0,
                              spreadRadius: 3.0,
                            ),
                          ]),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Название не должно быть пустым";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            place = value;
                          });
                        },
                        cursorColor: Color(0xFF7A9BEE),
                        decoration: InputDecoration(
                          hintText: "Место встречи",
                          hintStyle: GoogleFonts.montserrat(
                            fontSize: 14,
                          ),
                          contentPadding: EdgeInsets.only(
                            left: 10,
                            bottom: 10,
                          ),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
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
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Примечание и кол-во ( включая вас )",
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.062,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.15),
                                  offset: Offset(6, 2),
                                  blurRadius: 6.0,
                                  spreadRadius: 3.0,
                                ),
                                BoxShadow(
                                  color: Color.fromRGBO(255, 255, 255, 0.15),
                                  offset: Offset(-6, -2),
                                  blurRadius: 6.0,
                                  spreadRadius: 3.0,
                                ),
                              ]),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Название не должно быть пустым";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                comment = value;
                              });
                            },
                            cursorColor: Color(0xFF7A9BEE),
                            decoration: InputDecoration(
                              hintText: "Примечание",
                              hintStyle: GoogleFonts.montserrat(
                                fontSize: 14,
                              ),
                              contentPadding: EdgeInsets.only(
                                left: 10,
                                bottom: 10,
                              ),
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
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
                        Padding(
                          padding: const EdgeInsets.only(left: 36),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.height * 0.062,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.15),
                                    offset: Offset(6, 2),
                                    blurRadius: 6.0,
                                    spreadRadius: 3.0,
                                  ),
                                  BoxShadow(
                                    color: Color.fromRGBO(255, 255, 255, 0.15),
                                    offset: Offset(-6, -2),
                                    blurRadius: 6.0,
                                    spreadRadius: 3.0,
                                  ),
                                ]),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Название не должно быть пустым";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  quontaty = value;
                                });
                              },
                              cursorColor: Color(0xFF7A9BEE),
                              decoration: InputDecoration(
                                hintText: "Кол-во",
                                hintStyle: GoogleFonts.montserrat(
                                  fontSize: 14,
                                ),
                                contentPadding: EdgeInsets.only(
                                  left: 10,
                                  bottom: 10,
                                ),
                                border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
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
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.062,
                      child: Material(
                        borderRadius: BorderRadius.circular(15),
                        shadowColor: Colors.blueAccent,
                        color: Color(0xFF7A9BEE),
                        elevation: 7.0,
                        child: FlatButton(
                          onPressed: () async {
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .initUserData(context)
                                .whenComplete(() {
                              _trySubmit();
                            });
                          },
                          child: Center(
                            child: Text(
                              "Создать climb",
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
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
        ),
      ),
    );
  }
}
