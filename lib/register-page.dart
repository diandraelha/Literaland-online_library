import 'package:flutter/material.dart';
import 'package:literaland/Controller/apiservice.dart';
import 'package:literaland/login-page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password tidak cocok!')),
        );
        return;
      }

      final ApiService apiService = ApiService();
      final response = await apiService.register(
        _usernameController.text,
        _passwordController.text,
        _emailController.text,
      );

      if (response['status'] == 'success') {
        // Registrasi berhasil, arahkan ke halaman login atau home
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrasi berhasil!')),
        );
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        // Registrasi gagal, tampilkan pesan error
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
          'Register',
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
                  SizedBox(height: 100),
                  // Email/Phone Number Input
                    Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
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
                          style: TextStyle(
                            color: Colors.white, 
                          ),
                        ),
                        SizedBox(height: 16.0),
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
                          style: TextStyle(
                            color: Colors.white, 
                          ),
                        ),
                        SizedBox(height: 16.0),
                        // Password Input
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Create Password',
                            labelStyle: TextStyle(
                                color: Colors.white
                              ),
                            hintText: 'Create Password',
                            hintStyle: TextStyle(
                              color: Colors.white54
                            )
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(
                                color: Colors.white
                              ),
                            hintText: 'Confirm Password',
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
                            onPressed: _register, // Panggil fungsi _register() saat tombol ditekan
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF7453FC),
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(color: Colors.white),
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
