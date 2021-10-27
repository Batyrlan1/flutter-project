import 'dart:io';
import 'package:path/path.dart';
import 'package:Tau/Sign/Auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UpdatePage extends StatefulWidget {
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  var _aboutMe = "";
  File _imageFile;

  final ImagePicker _picker = ImagePicker();
  void takephoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    File compressedFile = await FlutterNativeImage.compressImage(
      pickedFile.path,
      quality: 10,
    );
    setState(() {
      _imageFile = compressedFile;
    });
  }

  Future upLoadpic(BuildContext context) async {
    String fileName = basename(_imageFile.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child("user_image").child(fileName);
    await firebaseStorageRef.putFile(_imageFile);
    final _uploadURL = await firebaseStorageRef.getDownloadURL();

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(Provider.of<CurrentUser>(context, listen: false).getUid)
        .update({
      "avatar": _uploadURL,
    });
  }

  final _formKey = GlobalKey<FormState>();
  void trySubmit(BuildContext context) async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(Provider.of<CurrentUser>(context, listen: false).getUid)
          .update({
        "Bio": _aboutMe,
      }).whenComplete(() {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            CupertinoIcons.arrow_left,
            size: 19,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Редактировать',
          style: GoogleFonts.roboto(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          child: Stack(
            children: <Widget>[
              Container(
                height: screenHeight,
                width: screenWidth,
                padding: EdgeInsets.only(
                  top: 60,
                  left: 20,
                  right: 20,
                ),
                child: Form(
                  key: _formKey,
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Center(
                                child: Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        width: 1,
                                        color: Color(0xFF7A9BEE),
                                      )),
                                  child: Container(
                                    height: screenHeight * 0.13,
                                    width: screenWidth * 0.22,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      image: DecorationImage(
                                        image: _imageFile == null
                                            ? AssetImage('assets/albert.png')
                                            : FileImage(File(_imageFile.path)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            child: FlatButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return bottomSheet(context);
                                    });
                              },
                              child: Text(
                                'Сменить фото',
                                style: GoogleFonts.roboto(
                                  color: Colors.black54,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "О себе",
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
                              key: ValueKey("Date"),
                              onSaved: (value) {
                                _aboutMe = value;
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
                            height: screenHeight * 0.065,
                          ),
                          Container(
                            width: screenWidth * 0.8,
                            height: screenHeight * 0.055,
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              shadowColor: Colors.blueAccent,
                              color: Color(0xFF7A9BEE),
                              elevation: 7.0,
                              child: FlatButton(
                                onPressed: () {
                                  upLoadpic(context).whenComplete(() {
                                    trySubmit(context);
                                  });
                                },
                                child: Center(
                                  child: Text(
                                    'Сохранить',
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bottomSheet(BuildContext context) {
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
                "Изменить фото профиля",
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
                  takephoto(ImageSource.camera);
                },
                child: Text('Сделать фото',
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 16,
                    )),
              ),
              FlatButton(
                onPressed: () {
                  takephoto(ImageSource.gallery);
                },
                child: Text('Выбрать из галереи',
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
