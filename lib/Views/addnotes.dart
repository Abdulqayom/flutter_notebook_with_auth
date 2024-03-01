import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqfliteauth/Components/button.dart';
import 'package:sqfliteauth/Components/colors.dart';
import 'package:sqfliteauth/Components/textfield.dart';
import 'package:sqfliteauth/JSON/note.dart';
import 'package:sqfliteauth/JSON/users.dart';
import 'package:sqfliteauth/Views/login.dart';
import 'package:image_picker/image_picker.dart';

import '../database/database_helper.dart';

class AddNotes extends StatefulWidget {
  int? usersid;
  AddNotes(this.usersid);

  @override
  State<AddNotes> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<AddNotes> {
  //Controllers
  late File _image;
  // String? image=_image as String?;
  bool isshow = true;
  final titlecontroller = TextEditingController();
  final descontroller = TextEditingController();
  // final usrName = TextEditingController();
  // final password = TextEditingController();
  // final confirmPassword = TextEditingController();
  final db = DatabaseHelper();
  submitData() async {
    var res = await db.createNote(Note(
      notId: null,
      userId: widget.usersid,
      title: titlecontroller.text,
      description: descontroller.text,
      image: _image.path,
    ));
    if (res > 0) {
      if (!mounted) {
        print("This is the problems" + res.toString());
      }
      ;
      Navigator.pop(context);
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  // to get image from gallery or from camera
  Future _pickImage(BuildContext context, ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile == null) return;
    setState(() {
      // usrImageurl = _image.;
      _image = File(pickedFile.path);

      isshow = false;
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
                    "Register New Account",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 30,
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
                          backgroundImage: (isshow == false)
                              ? Image.file(
                                  _image,
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
                    hint: "Title",
                    icon: Icons.person,
                    controller: titlecontroller),
                InputField(
                    hint: "Description",
                    icon: Icons.email,
                    controller: descontroller),
                // InputField(
                //     hint: "Username",
                //     icon: Icons.account_circle,
                //     controller: usrName),
                // InputField(
                //     hint: "Password",
                //     icon: Icons.lock,
                //     controller: password,
                //     passwordInvisible: true),
                // InputField(
                //     hint: "Re-enter password",
                //     icon: Icons.lock,
                //     controller: confirmPassword,
                //     passwordInvisible: true),
                const SizedBox(height: 10),
                Button(
                    label: "Submit Data",
                    press: () {
                      submitData();
                    }),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Text(
                //       "Already have an account?",
                //       style: TextStyle(color: Colors.grey),
                //     ),
                //     TextButton(
                //         onPressed: () {
                //           Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => const LoginScreen()));
                //         },
                //         child: Text("LOGIN"))
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
