import 'package:flutter/material.dart';
import 'package:literaland/admin-borrow-request.dart';
import 'package:literaland/admin-dashboard.dart';
import 'package:literaland/admin-return-book.dart';

class HomepageAdmin extends StatefulWidget {

  const HomepageAdmin({Key? key}) : super(key: key);

  @override
  _HomepageAdminState createState() => _HomepageAdminState();
}

class _HomepageAdminState extends State<HomepageAdmin> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      AdminDashboard(),
      AdminBorrowRequestsScreen(),
      AdminReturnBooksScreen()
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
                icon: Icon(Icons.assignment),
                label: 'Borrowed Books',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Borrowed Books',
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