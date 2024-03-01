import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqfliteauth/Components/button.dart';
import 'package:sqfliteauth/Components/colors.dart';
import 'package:sqfliteauth/Components/textfield.dart';
import 'package:sqfliteauth/JSON/users.dart';
import 'package:sqfliteauth/Views/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqfliteauth/Views/profile.dart';
import 'package:sqfliteauth/widgets/splashscreen.dart';

import '../database/database_helper.dart';

class UserDetails extends StatefulWidget {
  String name, fullName, email, password, imageurl;
  int userId;
  UserDetails({
    required this.userId,
    required this.name,
    required this.fullName,
    required this.email,
    required this.password,
    required this.imageurl,
  });

  @override
  State<UserDetails> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<UserDetails> {
  removeToken() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  @override
  void initState() {
    setState(() {
      fullName.text = widget.fullName;
      usrName.text = widget.name;

      email.text = widget.email;

      password.text = widget.password;
    });
    getEmail();
    // TODO: implement initState
    super.initState();
  }

  //Controllers
  late File _image;
  // String? image=_image as String?;
  late int selectedUserId;
  // String? imageUrl;
  bool isshow = true;
  final fullName = TextEditingController();
  final email = TextEditingController();
  final usrName = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final db = DatabaseHelper();
  var token;
  var emails;
  Users? usrDetails;
  getEmail() async {
    final pref = await SharedPreferences.getInstance();
    emails = pref.getString('email');
    usrDetails = await db.getUser(emails);
  }

  late String emailss;
  storeEmail() async {
    emailss = usrName.text;
    final pref = await SharedPreferences.getInstance();
    await pref.setString('email', '$emailss');
  }

  updateuser() async {
    storeEmail();
    var res = await db.updateUser(Users(
        usrId: widget.userId,
        fullName: fullName.text,
        email: email.text,
        usrImage: widget.imageurl,
        usrName: usrName.text,
        password: password.text));
    if (res > 0) {
      if (!mounted) {
        print("This is the problems" + res.toString());
      }
      ;
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => SplashScreen()));
    }
  }

  // to get image from gallery or from camera
  Future _pickImage(BuildContext context, ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile == null) return;
    _image = File(pickedFile.path);
    widget.imageurl = _image.path;
    setState(() {
      // usrImageurl = _image.;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Edite The User Informations",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: Stack(children: [
                    Container(
                      child: CircleAvatar(
                        // maxRadius: 200,
                        // minRadius: 50,
                        backgroundColor: primaryColor,
                        radius: 100,
                        child: CircleAvatar(
                          backgroundImage: (widget.imageurl != null)
                              ? Image.file(
                                  File(widget.imageurl.toString()),
                                  // height: 480,
                                  // width: 500,
                                ).image
                              : AssetImage("assets/no_user.jpg"),
                          radius: 95,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 1,
                      right: -2,
                      child: Row(
                        children: [
                          PopupMenuButton(
                              color: Colors.white,
                              constraints:
                                  BoxConstraints(maxHeight: 100, maxWidth: 250),
                              icon: Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.red,
                              ),
                              itemBuilder: ((context) => [
                                    PopupMenuItem(
                                        onTap: () {
                                          setState(() {
                                            _pickImage(
                                                context, ImageSource.camera);
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.camera_alt_outlined),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Camera",
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )),
                                    PopupMenuItem(
                                        onTap: (() => _pickImage(
                                            context, ImageSource.gallery)),
                                        child: Row(
                                          children: [
                                            Icon(Icons.camera_alt_outlined),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Gallery",
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                  ]))
                        ],
                      ),
                    )
                  ]),
                ),
                const SizedBox(height: 20),
                InputField(
                    hint: widget.fullName + "",
                    icon: Icons.person,
                    controller: fullName),
                InputField(
                    hint: widget.email + "",
                    icon: Icons.email,
                    controller: email),
                InputField(
                    hint: widget.name + "",
                    icon: Icons.account_circle,
                    controller: usrName),
                InputField(
                    hint: widget.password + "",
                    icon: Icons.lock,
                    controller: password,
                    passwordInvisible: true),
                const SizedBox(height: 10),
                Button(
                    label: "Update",
                    press: () {
                      updateuser();
                    }),
                Button(
                    label: "Delete",
                    press: () {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: Text(
                      //       'Are you Sure To Delete This User!',
                      //     ),
                      //     duration: Duration(seconds: 2),
                      //     action: SnackBarAction(
                      //       label: 'UNDO',
                      //       onPressed: () {

                      //       },
                      //     ),
                      //   ),
                      // );
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Are you sure?'),
                          content: Text(
                            'Do you want to remove the User?',
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: Text('No'),
                              onPressed: () {
                                Navigator.of(ctx).pop(false);
                              },
                            ),
                            ElevatedButton(
                              child: Text('Yes'),
                              onPressed: () {
                                Navigator.of(ctx).pop(true);
                                removeToken();

                                db
                                    .deleteUser(widget.userId.toString())
                                    .whenComplete(() => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                SplashScreen())));
                              },
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
