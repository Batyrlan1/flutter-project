import 'dart:io';
import 'package:Tau/Sign/Auth.dart';
import 'package:Tau/Sign/Firebaseoperations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class UploadView extends StatefulWidget {
  UploadView({Key key}) : super(key: key);

  @override
  _UploadViewState createState() => _UploadViewState();
}

class _UploadViewState extends State<UploadView> {
  TextEditingController captionController = TextEditingController();
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
    String postId = Uuid().v4();
    String fileName = basename(_imageFile.path);

    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child("user_posts").child(fileName);
    await firebaseStorageRef.putFile(_imageFile);

    final _uploadURL = await firebaseStorageRef.getDownloadURL();

    await FirebaseFirestore.instance.collection("Posts").doc(postId).set({
      "PostImage": _uploadURL,
      "Caption": captionController.text,
      "Time": Timestamp.now(),
      "Uid": Provider.of<CurrentUser>(context, listen: false).getUid,
      "name": Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      "avatar": Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserAvatar,
      "Surename": Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserSurename,
      "PostId": postId,
    });
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(Provider.of<CurrentUser>(context, listen: false).getUid)
        .collection("Posts")
        .doc(postId)
        .set({
      "PostImage": _uploadURL,
      "Caption": captionController.text,
      "Time": Timestamp.now(),
      "Uid": Provider.of<CurrentUser>(context, listen: false).getUid,
      "name": Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      "avatar": Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserAvatar,
      "Surename": Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserSurename,
      "PostId": postId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              CupertinoIcons.arrow_left,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          GestureDetector(
            onTap: () {
              if (_imageFile == null) {
                Fluttertoast.showToast(
                    msg: "Выложите фото",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                return;
              }
              Provider.of<FirebaseOperations>(context, listen: false)
                  .initUserData(context)
                  .whenComplete(() {
                upLoadpic(context)..whenComplete(() => Navigator.pop(context));
              });
            },
            child: Icon(
              Icons.send_rounded,
              size: 20,
              color: Color(0xFF7A9BEE),
            ),
          ),
        ],
      ),
      body: Container(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(Provider.of<CurrentUser>(context, listen: false).getUid)
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
              return Container(
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 12,
                              ),
                              Container(
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xFF7A9BEE),
                                    )),
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.044,
                                  width:
                                      MediaQuery.of(context).size.width * 0.082,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          snapshot.data.data()['avatar']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                onTap: () {
                                  takephoto(ImageSource.camera);
                                },
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 22,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  takephoto(ImageSource.gallery);
                                },
                                child: Icon(
                                  Icons.image_outlined,
                                  size: 22,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Transform(
                                      transform: Matrix4.translationValues(
                                          -20.0, 0.0, 0.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        child: TextField(
                                          controller: captionController,
                                          autocorrect: false,
                                          autofocus: true,
                                          style: GoogleFonts.montserrat(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300),
                                          maxLines: 70,
                                          maxLengthEnforced: true,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          decoration: InputDecoration(
                                            hintText: "Напишите свою идею",
                                            hintStyle: GoogleFonts.montserrat(
                                              fontSize: 14,
                                            ),
                                            isDense: true,
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: Center(
                                      child: AspectRatio(
                                        aspectRatio: 4 / 3,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: _imageFile == null
                                                  ? AssetImage(
                                                      'assets/fon.jpeg')
                                                  : FileImage(
                                                      File(_imageFile.path)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
