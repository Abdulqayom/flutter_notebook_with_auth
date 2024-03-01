// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqfliteauth/Components/button.dart';
import 'package:sqfliteauth/Components/colors.dart';
import 'package:sqfliteauth/JSON/note.dart';
import 'package:sqfliteauth/JSON/users.dart';
import 'package:sqfliteauth/Views/addnotes.dart';
import 'package:sqfliteauth/Views/login.dart';
import 'package:sqfliteauth/database/database_helper.dart';
// import 'package:sqfliteauth/provider/provider.dart';
import 'package:sqfliteauth/widgets/details.dart';
import 'package:sqfliteauth/widgets/detailsUser.dart';

class ShowNotes extends StatefulWidget {
  int userId;
  final Users? profile;

  ShowNotes({super.key, required this.userId, required this.profile});

  @override
  State<ShowNotes> createState() => _ShowNotesState();
}

class _ShowNotesState extends State<ShowNotes> {
  void showimage() {
    AssetImage("assets/no_user.jpg");
  }

  final titile = TextEditingController();
  final description = TextEditingController();
  final userName = TextEditingController();
  final password = TextEditingController();
  late int selectedUserId;
  String? imageUrl;
  bool isshow = false;

  late DatabaseHelper handler;

  late Future<List<Note>> notes;
  late Future<List<Users>> users;

  final db = DatabaseHelper();
  int number = -1;

  // ignore: override_on_non_overriding_member
  @override
  void initState() {
    super.initState();
    handler = DatabaseHelper();
    notes = handler.getNotesbyUser(widget.userId);
    users = handler.getUsersbyId();

    handler.initDB().whenComplete(() async {
      notes = getList();
      users = getListu();
    });
    total();
    totalu();
  }

  //Total Users count
  Future<int?> total() async {
    int? count = await handler.totalNotes(widget.userId);
    setState(() => number = count!);
    return number;
  }

  Future<List<Note>> getList() async {
    return await handler.getNotesbyUser(widget.userId);
  }

  Future<void> _onRefresh() async {
    setState(() {
      notes = getList();
    });
  }

  Future<int?> totalu() async {
    int? count = await handler.totalUsers();
    setState(() => number = count!);
    return number;
  }

  Future<List<Users>> getListu() async {
    return await handler.getUsersbyId();
  }

  Future<void> _onRefreshu() async {
    setState(() {
      users = getListu();
    });
  }

  // bool isshow = false;
  late File _image;
  Future _pickImage(BuildContext context, ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile == null) return;
    setState(() {
      // usrImageurl = _image.;
      _image = File(pickedFile.path);
      imageUrl = _image.path;

      // isshow = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final controller = Provider.of<UiProvider>(context, listen: false);

    return Scaffold(
      // drawer: Drawer(),
      body: widget.profile!.usrName!.contains("Silab") &&
              widget.profile!.password.contains("Silab")
          ? FutureBuilder<List<Users>>(
              future: users,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Users>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    //To show a circular progress indicator
                    child: CircularProgressIndicator(),
                  );
                  //If snapshot has error
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No Data"),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        minWidth: 100,
                        color: Colors.teal,
                        onPressed: () => _onRefreshu(),
                        child: Text("Refresh"),
                      )
                    ],
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                // gvn nn
                else {
                  final items = snapshot.data ?? <Users>[];

                  return Scrollbar(
                    child: RefreshIndicator(
                      onRefresh: _onRefreshu,
                      child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, int index) {
                            return Dismissible(
                              direction: DismissDirection.endToStart,
                              background: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.shade900,
                                ),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              key: ValueKey<int>(items[index].usrId as int),
                              confirmDismiss: (direction) {
                                return showDialog(
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
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onDismissed: (DismissDirection direction) async {
                                await handler
                                    .deleteUser(items[index].usrId.toString())
                                    .whenComplete(() => ScaffoldMessenger.of(
                                            context)
                                        .showSnackBar(SnackBar(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            backgroundColor: Colors.teal,
                                            behavior: SnackBarBehavior.floating,
                                            duration: const Duration(
                                                milliseconds: 900),
                                            content: Row(
                                              children: [
                                                // items[index].usrImage == null
                                                //     ? Text("nopicture")
                                                //     : Text("we have picture"),
                                                Text(
                                                  "${items[index].fullName} deleted",
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ))));
                                setState(() {
                                  items.remove(items[index]);

                                  totalu();
                                });
                              },
                              child: Card(
                                child: ListTile(
                                  trailing: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedUserId =
                                              items[index].usrId as int;
                                          titile.text =
                                              items[index].fullName.toString();
                                          description.text =
                                              items[index].email.toString();
                                          userName.text =
                                              items[index].usrName.toString();
                                          password.text =
                                              items[index].password.toString();
                                          imageUrl = items[index].usrImage;
                                        });
                                        //bottom modal sheet for update
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(20),
                                                    topLeft:
                                                        Radius.circular(20))),
                                            context: context,
                                            builder: (context) {
                                              return SingleChildScrollView(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  child: SizedBox(
                                                    height: 600,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Container(
                                                                // ignore: unnecessary_null_comparison
                                                                child: imageUrl !=
                                                                        null
                                                                    ? Image
                                                                        .file(
                                                                        File(imageUrl
                                                                            .toString()),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        height:
                                                                            200,
                                                                        width:
                                                                            200,
                                                                      )
                                                                    : Icon(Icons
                                                                        .person),
                                                              ),
                                                              // SizedBox(height: 20),
                                                              Row(
                                                                children: [
                                                                  PopupMenuButton(
                                                                      itemBuilder:
                                                                          ((context) =>
                                                                              [
                                                                                PopupMenuItem(
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        _pickImage(context, ImageSource.camera);
                                                                                      });
                                                                                    },
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Icon(Icons.camera_alt_outlined),
                                                                                        SizedBox(
                                                                                          width: 5,
                                                                                        ),
                                                                                        Text("Camera")
                                                                                      ],
                                                                                    )),
                                                                                PopupMenuItem(
                                                                                    onTap: (() => _pickImage(context, ImageSource.gallery)),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Icon(Icons.camera_alt_outlined),
                                                                                        SizedBox(
                                                                                          width: 5,
                                                                                        ),
                                                                                        Text("Gallery")
                                                                                      ],
                                                                                    )),
                                                                              ]))
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 25),

                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: TextFormField(
                                                              controller:
                                                                  titile,
                                                              decoration:
                                                                  const InputDecoration(
                                                                hintText:
                                                                    "Full Name",
                                                              )),
                                                        ),

                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: TextFormField(
                                                              controller:
                                                                  description,
                                                              decoration:
                                                                  const InputDecoration(
                                                                hintText:
                                                                    "Email",
                                                              )),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: TextFormField(
                                                              controller:
                                                                  userName,
                                                              decoration:
                                                                  const InputDecoration(
                                                                hintText:
                                                                    "User Name",
                                                              )),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: TextFormField(

                                                              // obscureText:
                                                              //     isshow
                                                              //         ? true
                                                              //         : false,
                                                              controller:
                                                                  password,
                                                              decoration:
                                                                  InputDecoration(
                                                                // icon: Icon(
                                                                //     Icons.lock),
                                                                // suffixIcon:
                                                                //     IconButton(
                                                                //         onPressed:
                                                                //             () {
                                                                //           setState(
                                                                //               () {
                                                                //             isshow =
                                                                //                 !isshow;
                                                                //           });
                                                                //         },
                                                                //         icon: Icon(isshow
                                                                //             ? Icons.visibility
                                                                //             : Icons.visibility_off)),
                                                                hintText:
                                                                    "Password",
                                                              )),
                                                        ),
                                                        const SizedBox(
                                                            height: 15),
                                                        //Update button
                                                        MaterialButton(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            minWidth: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .94,
                                                            height: 50,
                                                            color: Colors.teal,
                                                            child: const Text(
                                                                "Update"),
                                                            onPressed: () {
                                                              setState(() {
                                                                db
                                                                    .updateUser(Users(
                                                                        usrId:
                                                                            selectedUserId,
                                                                        fullName:
                                                                            titile
                                                                                .text,
                                                                        email: description
                                                                            .text,
                                                                        usrName:
                                                                            userName
                                                                                .text,
                                                                        password:
                                                                            password
                                                                                .text,
                                                                        usrImage:
                                                                            imageUrl))
                                                                    .whenComplete(
                                                                        () => Navigator.pop(
                                                                            context));
                                                                _onRefresh();
                                                              });
                                                            })
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      icon: Icon(Icons.edit_note_outlined)),
                                  title: Text(
                                    items[index].fullName ?? "",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 18, color: primaryColor),
                                  ),
                                  subtitle: Text(
                                    items[index].email ?? "",
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.grey),
                                  ),
                                  leading: CircleAvatar(
                                    // maxRadius: 200,
                                    // minRadius: 50,
                                    backgroundColor: primaryColor,
                                    radius: 27,
                                    child: CircleAvatar(
                                      backgroundImage: Image.file(File(
                                              items[index].usrImage.toString()))
                                          .image,
                                      radius: 25,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (Context) => detailsUser(
                                                  titile: items[index]
                                                      .fullName
                                                      .toString(),
                                                  description: items[index]
                                                      .email
                                                      .toString(),
                                                  imageurl: items[index]
                                                      .usrImage
                                                      .toString(),
                                                  userName: items[index]
                                                      .usrName
                                                      .toString(),
                                                  password:
                                                      items[index].password,
                                                )));
                                  },
                                ),
                              ),
                            );
                          }),
                    ),
                  );
                }
              })
          : FutureBuilder<List<Note>>(
              future: notes,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    //To show a circular progress indicator
                    child: CircularProgressIndicator(),
                  );
                  //If snapshot has error
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No Data"),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        minWidth: 100,
                        color: Colors.teal,
                        onPressed: () => _onRefresh(),
                        child: Text("Refresh"),
                      )
                    ],
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                // gvn nn
                else {
                  final items = snapshot.data ?? <Note>[];

                  return Scrollbar(
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, int index) {
                            return Dismissible(
                              direction: DismissDirection.endToStart,
                              background: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.shade900,
                                ),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              key: ValueKey<int>(items[index].userId!),
                              confirmDismiss: (direction) {
                                return showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Are you sure?'),
                                    content: Text(
                                      'Do you want to remove the item?',
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
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onDismissed: (DismissDirection direction) async {
                                await handler
                                    .deleteNotes(items[index].userId.toString())
                                    .whenComplete(() => ScaffoldMessenger.of(
                                            context)
                                        .showSnackBar(SnackBar(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            backgroundColor: Colors.teal,
                                            behavior: SnackBarBehavior.floating,
                                            duration: const Duration(
                                                milliseconds: 900),
                                            content: Row(
                                              children: [
                                                // items[index].usrImage == null
                                                //     ? Text("nopicture")
                                                //     : Text("we have picture"),
                                                Text(
                                                  "${items[index].title} deleted",
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ))));
                                setState(() {
                                  items.remove(items[index]);

                                  total();
                                });
                              },
                              child: Card(
                                child: ListTile(
                                  trailing: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedUserId =
                                              items[index].notId as int;
                                          titile.text =
                                              items[index].title.toString();
                                          description.text = items[index]
                                              .description
                                              .toString();
                                          imageUrl = items[index].image;
                                        });
                                        //bottom modal sheet for update
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(20),
                                                    topLeft:
                                                        Radius.circular(20))),
                                            context: context,
                                            builder: (context) {
                                              return SingleChildScrollView(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  child: SizedBox(
                                                    height: 500,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Container(
                                                                // ignore: unnecessary_null_comparison
                                                                child: imageUrl !=
                                                                        null
                                                                    ? Image
                                                                        .file(
                                                                        File(imageUrl
                                                                            .toString()),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        height:
                                                                            200,
                                                                        width:
                                                                            200,
                                                                      )
                                                                    : Icon(Icons
                                                                        .person),
                                                              ),
                                                              // SizedBox(height: 20),
                                                              Row(
                                                                children: [
                                                                  PopupMenuButton(
                                                                      itemBuilder:
                                                                          ((context) =>
                                                                              [
                                                                                PopupMenuItem(
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        _pickImage(context, ImageSource.camera);
                                                                                      });
                                                                                    },
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Icon(Icons.camera_alt_outlined),
                                                                                        SizedBox(
                                                                                          width: 5,
                                                                                        ),
                                                                                        Text("Camera")
                                                                                      ],
                                                                                    )),
                                                                                PopupMenuItem(
                                                                                    onTap: (() => _pickImage(context, ImageSource.gallery)),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Icon(Icons.camera_alt_outlined),
                                                                                        SizedBox(
                                                                                          width: 5,
                                                                                        ),
                                                                                        Text("Gallery")
                                                                                      ],
                                                                                    )),
                                                                              ]))
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 25),

                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: TextFormField(
                                                              controller:
                                                                  titile,
                                                              decoration:
                                                                  const InputDecoration(
                                                                hintText:
                                                                    "title",
                                                              )),
                                                        ),

                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: TextFormField(
                                                              controller:
                                                                  description,
                                                              decoration:
                                                                  const InputDecoration(
                                                                hintText:
                                                                    "Description",
                                                              )),
                                                        ),
                                                        const SizedBox(
                                                            height: 15),
                                                        //Update button
                                                        MaterialButton(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            minWidth: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .94,
                                                            height: 50,
                                                            color: Colors.teal,
                                                            child: const Text(
                                                                "Update"),
                                                            onPressed: () {
                                                              setState(() {
                                                                db
                                                                    .updateNote(Note(
                                                                        notId:
                                                                            selectedUserId,
                                                                        userId: items[index]
                                                                            .userId,
                                                                        title: titile
                                                                            .text,
                                                                        description: description
                                                                            .text,
                                                                        image:
                                                                            imageUrl))
                                                                    .whenComplete(() =>
                                                                        Navigator.pop(
                                                                            context));
                                                                _onRefresh();
                                                              });
                                                            })
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      icon: Icon(Icons.edit_note_outlined)),
                                  title: Text(
                                    items[index].title ?? "",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 18, color: primaryColor),
                                  ),
                                  subtitle: Text(
                                    items[index].description ?? "",
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.grey),
                                  ),
                                  leading: CircleAvatar(
                                    // maxRadius: 200,
                                    // minRadius: 50,
                                    backgroundColor: primaryColor,
                                    radius: 27,
                                    child: CircleAvatar(
                                      backgroundImage: Image.file(File(
                                              items[index].image.toString()))
                                          .image,
                                      radius: 25,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (Context) => Details(
                                                titile: items[index]
                                                    .title
                                                    .toString(),
                                                description: items[index]
                                                    .description
                                                    .toString(),
                                                imageurl: items[index]
                                                    .image
                                                    .toString())));
                                  },
                                ),
                              ),
                            );
                          }),
                    ),
                  );
                }
              }),
    );
  }
}
