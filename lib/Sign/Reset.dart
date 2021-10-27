import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  TextEditingController _emailController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          title: Text(
            "Восстановить пароль",
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
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
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                SizedBox(
                  width: 40,
                ),
                Text(
                  "Почта",
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
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
              child: TextField(
                cursorColor: Color(0xFF7A9BEE),
                controller: _emailController,
                decoration: InputDecoration(
                  hintStyle: GoogleFonts.montserrat(
                    fontSize: 14,
                  ),
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
            SizedBox(height: 40),
            Container(
              width: 160,
              height: 30,
              child: Material(
                borderRadius: BorderRadius.circular(20),
                shadowColor: Colors.blueAccent,
                color: Color(0xFF7A9BEE),
                elevation: 7.0,
                child: FlatButton(
                  onPressed: () {
                    _auth.sendPasswordResetEmail(email: _emailController.text);
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text(
                      'Отправить запрос',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ));
  }
}
