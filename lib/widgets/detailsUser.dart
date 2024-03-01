import 'dart:io';

import 'package:flutter/material.dart';

class detailsUser extends StatelessWidget {
  String titile, description, imageurl;
  String? userName, password;
  detailsUser(
      {required this.titile,
      required this.description,
      required this.imageurl,
      this.userName,
      this.password,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titile),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.file(
                File(imageurl),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300,
              ),
              SizedBox(
                height: 20,
              ),
              Text("Full Name:"),
              Text(
                titile,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Email:"),
              Text(
                description,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 20,
              ),
              Text("User Name:"),
              Text(
                userName!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Password:"),
              Text(
                password!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
