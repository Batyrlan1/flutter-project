import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Tau/pages/BlogPage.dart';
import 'package:Tau/pages/Chatroom.dart';
import 'package:Tau/pages/Meeting.dart';
import 'package:Tau/pages/Plus.dart';
import 'package:Tau/pages/Profile.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController();
  List<Widget> _screens = [
    MeetPage(),
    BlogPage(),
    PlusPage(),
    ChatRoomPage(),
    ProfilePage(),
  ];
  int _selectedIndex = 0;

  void _onePageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onePageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                color: _selectedIndex == 0 ? Color(0xFF7A9BEE) : Colors.black87,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.lightbulb_outline,
                color: _selectedIndex == 1 ? Color(0xFF7A9BEE) : Colors.black87,
              ),
              label: "Climb"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle_outline,
                color: _selectedIndex == 2 ? Color(0xFF7A9BEE) : Colors.black87,
              ),
              label: "Add"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications_none_outlined,
                color: _selectedIndex == 3 ? Color(0xFF7A9BEE) : Colors.black87,
              ),
              label: "Room"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
                color: _selectedIndex == 4 ? Color(0xFF7A9BEE) : Colors.black87,
              ),
              label: "Profile"),
        ],
      ),
    );
  }
}
