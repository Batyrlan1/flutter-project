import 'package:Tau/Sign/Auth.dart';
import 'package:Tau/other/Climb/Meethelp.dart';
import 'package:Tau/other/Climb/geolocation.dart';
import 'package:Tau/other/Profile/Alternateprofile.dart';
import 'package:Tau/other/upLoadPost/PostOptions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Sign/Firebaseoperations.dart';
import 'Sign/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tau',
          theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: OutRoot(),
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => CurrentUser()),
          ChangeNotifierProvider(create: (_) => FirebaseOperations()),
          ChangeNotifierProvider(create: (_) => PostFunctions()),
          ChangeNotifierProvider(create: (_) => AlternateProfile()),
          ChangeNotifierProvider(create: (_) => LocationApi()),
          ChangeNotifierProvider(create: (_) => MeetHelp()),
        ]);
  }
}
