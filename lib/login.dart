import 'package:flutter/material.dart';
import 'package:final_project/database_helper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController namefield = TextEditingController();
  TextEditingController passwordField = TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(27, 66, 66, 1),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Column(
                children: [
                  Image.asset(
                    'assets/login.gif',
                    height: screenHeight * 0.3,
                  ),
                  const Row(
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    children: [
                      Text(
                        "Please Sign in to Continue",
                        style: TextStyle(color: Colors.white38, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: namefield,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'email',
                      prefixIcon: const Icon(Icons.account_circle),
                      filled: true,
                      fillColor: const Color.fromARGB(77, 255, 245, 234),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordField,
                    decoration: InputDecoration(
                      hintText: 'password',
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 49, 47, 47)),
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: const Color.fromARGB(77, 255, 245, 234),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        login();
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 100),
                          backgroundColor:
                              const Color.fromRGBO(255, 245, 234, 1)),
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Color.fromRGBO(27, 66, 66, 1)),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 100),
                          backgroundColor: const Color.fromRGBO(27, 66, 66, 1)),
                      child: const Text('Create an Account',
                          style: TextStyle(
                              color: Color.fromRGBO(255, 245, 234, 1)))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    String email = namefield.text;
    String password = passwordField.text;

    Map<String, dynamic> row = {'email': email, 'password': password};

    var res = await databaseHelper.authenticate(row);
    if (res == true) {
      if (!mounted) return;
      Navigator.pushNamed(context, '/bottom');
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
        ),
      );
    }
  }
}
