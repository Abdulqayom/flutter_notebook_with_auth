import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqfliteauth/Components/button.dart';
import 'package:sqfliteauth/Components/colors.dart';
import 'package:sqfliteauth/Components/textfield.dart';
import 'package:sqfliteauth/JSON/users.dart';
import 'package:sqfliteauth/Views/profile.dart';
import 'package:sqfliteauth/Views/signup.dart';
import 'package:sqfliteauth/utils/local_auth_api.dart';

import '../database/database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Our controllers
  //Controller is used to take the value from user and pass it to database
  final usrName = TextEditingController();
  final password = TextEditingController();
  bool isfinger = false;

  String token =
      "asfghjklqwertyuiozxcvbnm,lkjhgfdsaoiuytrew23456789oiuytres4rfcvyhnikm";

  storeToken() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('token', '$token');
  }

  late String email;
  storeEmail() async {
    email = usrName.text;
    final pref = await SharedPreferences.getInstance();
    await pref.setString('email', '$email');
  }

  bool isChecked = false;
  bool isLoginTrue = false;
  bool isshow = true;
  final db = DatabaseHelper();
  String? userPass;
  String? userName;
  // Users? usrDetails;

  getname() async {
    final pref = await SharedPreferences.getInstance();
    userName = pref.getString('username');
  }

  getpass() async {
    final pref = await SharedPreferences.getInstance();
    userPass = pref.getString('userpass');
    // usrDetails = await db.getUser(email);
  }

  //Login Method
  //We will take the value of text fields using controllers in order to verify whether details are correct or not
  login() async {
    Users? usrDetails = await db.getUser(usrName.text);

    var res = await db
        .authenticate(Users(usrName: usrName.text, password: password.text));
    if (res == true) {
      //If result is correct then go to profile or home
      // if (value.isChecked == true) {
      //   value.setRememberMe();
      // }
      if (!mounted) return;
      storeToken();
      storeEmail();

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Profile(
                    profile: usrDetails,
                  )));
    } else {
      //Otherwise show the error message
      setState(() {
        isLoginTrue = true;
      });
    }
  }

  // var isAuthenticated;
  void setnamelistner() {
    usrName.text = userName!;
  }

  void setpasslistner() {
    usrName.text = userPass!;
  }

  loginwithfinger() async {
    final isAuthenticat = await ScanFinger.authenticate();
    if (isAuthenticat) {
      Future.delayed(Duration(seconds: 1), () {
        getname();
        getpass();
        usrName.text = userName.toString();
        password.text = userPass.toString();
        setState(() async {
          Users? usrDetails = await db.getUser(usrName.text);

          var res = await db.authenticate(
              Users(usrName: usrName.text, password: password.text));
          if (res == true) {
            //If result is correct then go to profile or home
            // if (value.isChecked == true) {
            //   value.setRememberMe();
            // }
            if (!mounted) return;
            storeToken();
            storeEmail();

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profile(
                          profile: usrDetails,
                        )));
          } else {
            //Otherwise show the error message
            setState(() {
              isLoginTrue = true;
            });
          }
        });
        // usrName.addListener(setpasslistner);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getname();
    getpass();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        loginwithfinger();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Because we don't have account, we must create one to authenticate
                //lets go to sign up

                const Text(
                  "LOGIN",
                  style: TextStyle(color: primaryColor, fontSize: 40),
                ),
                Image.asset("assets/background.jpg"),
                InputField(
                  hint: "Username",
                  icon: Icons.account_circle,
                  controller: usrName,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  width: size.width * .9,
                  height: 55,
                  decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: TextFormField(
                      obscureText: isshow,
                      controller: password,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                          icon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isshow = !isshow;
                                });
                              },
                              icon: Icon(isshow
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                    ),
                  ),
                ),
                // Consumer<UiProvider>(
                //     builder: (context, UiProvider notifier, child) {
                // ListTile(
                //     horizontalTitleGap: 2,
                //     title: const Text("login with Finger"),
                //     leading: IconButton(
                //         onPressed: () async {
                //           final isAuthenticat = await ScanFinger.authenticate();
                //           if (isAuthenticat) {
                //             Future.delayed(Duration(seconds: 1), () {
                //               getname();
                //               getpass();
                //               usrName.text = userName.toString();
                //               password.text = userPass.toString();
                //               setState(() async {
                //                 Users? usrDetails =
                //                     await db.getUser(usrName.text);

                //                 var res = await db.authenticate(Users(
                //                     usrName: usrName.text,
                //                     password: password.text));
                //                 if (res == true) {
                //                   //If result is correct then go to profile or home
                //                   // if (value.isChecked == true) {
                //                   //   value.setRememberMe();
                //                   // }
                //                   if (!mounted) return;
                //                   storeToken();
                //                   storeEmail();

                //                   Navigator.push(
                //                       context,
                //                       MaterialPageRoute(
                //                           builder: (context) => Profile(
                //                                 profile: usrDetails,
                //                               )));
                //                 } else {
                //                   //Otherwise show the error message
                //                   setState(() {
                //                     isLoginTrue = true;
                //                   });
                //                 }
                //               });
                //               // usrName.addListener(setpasslistner);
                //             });
                //           }
                //         },
                //         icon: Icon(Icons.fingerprint, color: Colors.green))),
                // }),

                //Our login button
                // // login();
                // Consumer(builder: ((context, UiProvider value, child) {
                //   return
                // })),
                Button(
                    label: "LOGIN",
                    press: () async {
                      Users? usrDetails = await db.getUser(usrName.text);

                      var res = await db.authenticate(Users(
                          usrName: usrName.text, password: password.text));
                      if (res == true) {
                        //If result is correct then go to profile or home
                        // if (value.isChecked == true) {
                        //   value.setRememberMe();
                        // }
                        if (!mounted) return;
                        storeToken();
                        storeEmail();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Profile(
                                      profile: usrDetails,
                                    )));
                      } else {
                        //Otherwise show the error message
                        setState(() {
                          isLoginTrue = true;
                        });
                      }
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupScreen()));
                        },
                        child: const Text("SIGN UP"))
                  ],
                ),

                // Access denied message in case when your username and password is incorrect
                //By default we must hide it
                //When login is not true then display the message
                isLoginTrue
                    ? Text(
                        "Username or password is incorrect",
                        style: TextStyle(color: Colors.red.shade900),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
