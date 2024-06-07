import 'package:flutter/material.dart';
import 'package:final_project/database_helper.dart';
import 'package:final_project/login.dart';
//import 'package:sqflite/sqflite.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  //int? userId = DatabaseHelper.loggedInUserId;
  String? username;
  String? email;

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Call the method to fetch the username
  }

  Future<void> _fetchUserName() async {
    String? name = await DatabaseHelper().getLoggedinUserName();
    String? emailfrom = await DatabaseHelper().getLoggedinEmail();
    setState(() {
      username = name;
      email = emailfrom;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 237, 247),
        body: SafeArea(
            child: Center(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
              Image.asset("assets/profile.png",
                  color: const Color.fromRGBO(27, 66, 66, 1)),
              Text(
                '$username',
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text("$email", style: const TextStyle(fontSize: 15)),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    DatabaseHelper.logout();
                    // Navigator.pushNamed(context, '/login');
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text('Logout'))
            ])))));
  }
}
