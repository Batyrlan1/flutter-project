import 'package:Tau/Sign/Auth.dart';
import 'package:Tau/Sign/Register.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var _userEmail = '';
  var _userName = '';
  var _userSureName = '';
  var _userPassword = '';

  final _formKey = GlobalKey<FormState>();
  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();

      Provider.of<CurrentUser>(context, listen: false)
          .singUpUser(_userEmail, _userPassword, _userName, _userSureName)
          .whenComplete(() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegisterPage()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          child: Stack(
            children: <Widget>[
              Container(
                height: screenHeight,
                width: screenWidth,
                color: Color(0xFF7A9BEE),
              ),
              Positioned(
                top: 100,
                child: Container(
                  height: screenHeight,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(45),
                      topLeft: Radius.circular(45),
                    ),
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                height: screenHeight,
                width: screenWidth,
                padding: EdgeInsets.only(
                  top: 140,
                  left: 30,
                  right: 30,
                ),
                child: Form(
                  key: _formKey,
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Фамилия",
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.015,
                          ),
                          Container(
                            width: screenWidth * 0.8,
                            height: screenHeight * 0.062,
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
                              key: ValueKey("Surename"),
                              validator: (value) {
                                if (value.isEmpty || value.length < 2) {
                                  return "Фамилия должно составлять 2 буквы";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _userSureName = value;
                              },
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
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Имя",
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.015,
                          ),
                          Container(
                            width: screenWidth * 0.8,
                            height: screenHeight * 0.062,
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
                              key: ValueKey("Name"),
                              validator: (value) {
                                if (value.isEmpty || value.length < 2) {
                                  return "Имя должно составлять 2 буквы";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _userName = value;
                              },
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
                            height: screenHeight * 0.015,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
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
                            height: screenHeight * 0.015,
                          ),
                          Container(
                            width: screenWidth * 0.8,
                            height: screenHeight * 0.062,
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
                              key: ValueKey("Email"),
                              validator: (value) {
                                if (value.isEmpty || !value.contains("@")) {
                                  return "Неверный @mail";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _userEmail = value;
                              },
                              keyboardType: TextInputType.emailAddress,
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
                            height: screenHeight * 0.015,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Пароль",
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.015,
                          ),
                          Container(
                            width: screenWidth * 0.8,
                            height: screenHeight * 0.062,
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
                              key: ValueKey("Password"),
                              validator: (value) {
                                if (value.isEmpty || value.length < 6) {
                                  return "Пароль должен состоять не менее из 6 символов";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _userPassword = value;
                              },
                              obscureText: true,
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
                            height: screenHeight * 0.08,
                          ),
                          Container(
                            width: screenWidth * 0.8,
                            height: screenHeight * 0.062,
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              shadowColor: Colors.blueAccent,
                              color: Color(0xFF7A9BEE),
                              elevation: 7.0,
                              child: FlatButton(
                                onPressed: _trySubmit,
                                child: Center(
                                  child: Text(
                                    'Регистрация',
                                    style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text:
                                      "Нажимая кнопку Регистрация,  вы принимаете  условия",
                                  style: GoogleFonts.roboto(
                                      fontSize: 11,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w200),
                                ),
                                TextSpan(
                                  text: "  Пользовательского соглашения  ",
                                  style: GoogleFonts.roboto(
                                      fontSize: 11,
                                      color: Color(0xFF7A9BEE),
                                      fontWeight: FontWeight.w300),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      var url =
                                          "https://docs.google.com/document/d/17FeX6yMGYWF62V0dYNl1EuaRy0h3tXXaZ4hTuvRhrX8/edit?usp=sharing";
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw "Не удалось загрузить";
                                      }
                                    },
                                ),
                                TextSpan(
                                  text: "и ",
                                  style: GoogleFonts.roboto(
                                      fontSize: 11,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w200),
                                ),
                                TextSpan(
                                  text: "Политики конфиденциальности.",
                                  style: GoogleFonts.roboto(
                                      fontSize: 11,
                                      color: Color(0xFF7A9BEE),
                                      fontWeight: FontWeight.w300),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      var url =
                                          "https://docs.google.com/document/d/1pfVtDqChtwxaNeSc8_GFjNe7Pa6vaR_VXNTs__YpRic/edit?usp=sharing";
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw "Не удалось загрузить";
                                      }
                                    },
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 40,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                  color: Colors.white,
                  iconSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
