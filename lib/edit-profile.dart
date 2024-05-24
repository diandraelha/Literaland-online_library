import 'package:flutter/material.dart';

class Editprofile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF282b2f),
        centerTitle: true, // Menengahkan teks di AppBar
        iconTheme: IconThemeData(
          color: Colors.white, // Mengubah warna panah kembali menjadi putih
        ),
      ),
      backgroundColor: Color(0xFF282b2f),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('lib/assets/images/The-Shadow-of-Beltane - Etsy.jpeg'),
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(
                    color: Colors.white
                  ),
                  // hintText: 'Masukkan Email atau Nomor HP',
                  // hintStyle: TextStyle(
                  //   color: Colors.white54
                  // ),
                ),
                initialValue: "Test",
                style: TextStyle(
                  color: Colors.white, 
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Editprofile()),
                  );
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

