import 'package:Tau/Sign/Auth.dart';
import 'package:Tau/pages/Home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Tau/pages/Start.dart';

enum AuthStatus {
  notLoggedIn,
  loggedIn,
}

class OutRoot extends StatefulWidget {
  OutRoot({Key key}) : super(key: key);

  @override
  _OutRootState createState() => _OutRootState();
}

class _OutRootState extends State<OutRoot> {
  AuthStatus _authStatus = AuthStatus.notLoggedIn;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await _currentUser.onStartUp();
    if (_returnString == "success") {
      setState(() {
        _authStatus = AuthStatus.loggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget retVal;
    switch (_authStatus) {
      case AuthStatus.notLoggedIn:
        retVal = Startpage();
        break;
      case AuthStatus.loggedIn:
        retVal = HomePage();

        break;
      default:
    }

    return retVal;
  }
}
