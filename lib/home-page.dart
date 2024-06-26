import 'package:flutter/material.dart';
import 'package:literaland/borrowed-book-screen.dart';
import 'package:literaland/profile-page.dart';
import 'package:literaland/dashboard.dart';
import 'package:literaland/Model/user.dart';

class Homepage extends StatefulWidget {
  final User user;

  const Homepage({Key? key, required this.user}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      Dashboard(user: widget.user),
      BorrowedBooksScreen(user: widget.user),
      ProfilePage(user: widget.user),
    ];
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex == 0) {
      return true;
    } else {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Shadow color
                spreadRadius: 5, // Spread radius
                blurRadius: 10, // Blur radius
                offset: Offset(0, 3), // Shadow offset
              ),
            ],
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Borrowed Books',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color(0xFF7453FC), // Change this to your desired color
            unselectedItemColor: Colors.white, // Change this to your desired color
            backgroundColor: Color(0xFF282b2f), // Change this to your desired color
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}