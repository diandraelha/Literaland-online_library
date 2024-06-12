import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF282b2f),
      appBar: AppBar(
        title: Text('DASHBOARDADMIN', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF282b2f),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onSelected: (String result) {},
            itemBuilder: (BuildContext context) {
              return {'admin'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Udin Sinaga"),
              accountEmail: Text("Admin Literaland"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage("assets/images/user.png"), // Update with correct image path
              ),
              decoration: BoxDecoration(
                color: Color(0xFF282b2f),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Category'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Book'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.confirmation_number),
              title: Text('Request Confirmation'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildDashboardCard('USERS', '2', Colors.purple),
                buildDashboardCard('NUMBER OF BOOK\'S TITLES', '7', Colors.purple),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildDashboardCard('ACCEPTED USERS', '1', Colors.red),
                buildDashboardCard('NUMBER OF CATEGORIES', '9', Colors.purple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDashboardCard(String title, String count, Color lineColor) {
    return Container(
      width: (MediaQuery.of(context).size.width / 2) - 24,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF383b40),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.white)),
          SizedBox(height: 8),
          Row(
            children: [
              Text(count, style: TextStyle(color: Colors.white, fontSize: 24)),
              Spacer(),
              Container(
                height: 4,
                width: 50,
                color: lineColor,
              )
            ],
          ),
        ],
      ),
    );
  }
}
