import 'package:flutter/material.dart';
import 'package:literaland/Model/user.dart';
import 'package:literaland/widget/Grid-view.dart';

class Dashboard extends StatelessWidget {
  final User user;

  const Dashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 40),
                Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 0),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Search',
                      labelStyle: TextStyle(
                        color: Colors.white
                      ),
                      hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Colors.white54,
                          fontStyle: FontStyle.italic
                        ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: MyGridView(user: user), // Kirim user ke MyGridView
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}