import 'package:Tau/Sign/Auth.dart';
import 'package:Tau/Sign/Reset.dart';
import 'package:Tau/pages/Home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'SignUp.dart';

enum LoginType {
  email,
  google,
}

class SignPage extends StatefulWidget {
  const SignPage({Key key}) : super(key: key);

  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  void _logInUser({
    @required LoginType type,
    String email,
    String password,
    BuildContext context,
  }) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    try {
      String _returnString;
      switch (type) {
        case LoginType.email:
          _returnString =
              await _currentUser.logInUserWithEmail(email, password);
          break;
        case LoginType.google:
          _returnString = await _currentUser.logInUserWithEmailGoogle();

          break;
        default:
      }

      if (_returnString == "success") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false,
        );
      } else {
        Fluttertoast.showToast(
            msg: "Неверный логин или пароль!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          child: Column(
            children: [
              Container(
                height: screenHeight - screenHeight / 1.7,
                width: screenWidth,
                child: Stack(children: [
                  ShaderMask(
                    shaderCallback: (rectangle) {
                      return LinearGradient(
                              colors: [Colors.black, Colors.transparent],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)
                          .createShader(Rect.fromLTRB(
                              0, 0, rectangle.width, rectangle.height));
                    },
                    blendMode: BlendMode.dstIn,
                    child: Container(
                      height: screenHeight - screenHeight / 1.7,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/snow 2.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 18,
                    right: 42,
                    child: Container(
                        child: Text(
                      " Время перемен",
                      style: GoogleFonts.roboto(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w200,
                        color: Colors.grey[400],
                      ),
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 36,
                    child: Container(
                      child: Text(
                        ".",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF7A9BEE),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
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
                      height: screenHeight * 0.06,
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
                          width: 20,
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
                      height: screenHeight * 0.06,
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
                        controller: _passwordController,
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
                    Container(
                      padding: EdgeInsets.only(
                        left: 167,
                      ),
                      child: FlatButton(
                        child: Text(
                          "Забыли пароль?",
                          style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              decoration: TextDecoration.underline),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ResetScreen()),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.045,
                    ),
                    Container(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.062,
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        shadowColor: Colors.lightGreen,
                        color: Colors.green,
                        elevation: 7.0,
                        child: FlatButton(
                          onPressed: () {
                            _logInUser(
                                type: LoginType.email,
                                email: _emailController.text,
                                password: _passwordController.text,
                                context: context);
                          },
                          child: Center(
                            child: Text(
                              'Войти',
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.008,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                "Еще нет аккаунта?",
                                style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Создать",
                                style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
