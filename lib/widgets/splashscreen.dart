import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqfliteauth/JSON/users.dart';
import 'package:sqfliteauth/Views/auth.dart';
import 'package:sqfliteauth/Views/profile.dart';
import 'package:sqfliteauth/database/database_helper.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var token;
  var email;
  Users? usrDetails;

  getToken() async {
    final pref = await SharedPreferences.getInstance();
    token = pref.getString('token');
  }

  getEmail() async {
    final pref = await SharedPreferences.getInstance();
    email = pref.getString('email');
    usrDetails = await db.getUser(email);
  }

  final db = DatabaseHelper();
  // bool? languageid;
  // getlanguageid() async {
  //   final pref = await SharedPreferences.getInstance();
  //   languageid = pref.getBool("languageid");
  // }

  @override
  void initState() {
    getToken();
    getEmail();
    // getlanguageid();

    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => token == null
              ? AuthScreen()
              // ignore: unrelated_type_equality_checks
              : Profile(
                  profile: usrDetails,
                 
                )));
    });
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
