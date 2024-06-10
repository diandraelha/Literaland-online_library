import 'package:flutter/material.dart';
import 'package:literaland/Controller/apiservice.dart';
import 'package:literaland/home-page.dart';
import 'package:literaland/Model/user.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final ApiService apiService = ApiService();
      final response = await apiService.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (response['status'] == 'success') {
        User user = response['user']; // Already a User object
        // Login berhasil, arahkan ke halaman home
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login berhasil!')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Homepage(user: user), // Meneruskan objek User ke Homepage
          ),
        );
      } else {
        // Login gagal, tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF282b2f),
        centerTitle: true, // Menengahkan teks di AppBar
        iconTheme: IconThemeData(
          color: Colors.white, // Mengubah warna panah kembali menjadi putih
        ),
      ),
      backgroundColor: Color(0xFF282b2f), // Mengubah warna latar belakang halaman
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            color: Color(0xFF282b2f), // Mengubah warna latar belakang container
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 50), 
                    Text(
                      'Literaland',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 150),
                    Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(
                              color: Colors.white
                            ),
                            hintText: 'Masukkan Username',
                            hintStyle: TextStyle(
                              color: Colors.white54
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 16.0),
                        // Password Input
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                                color: Colors.white
                              ),
                            hintText: 'Masukkan Password',
                            hintStyle: TextStyle(
                              color: Colors.white54
                            )
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 16.0),
                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF7453FC),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}