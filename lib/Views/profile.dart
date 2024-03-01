// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqfliteauth/Components/button.dart';
import 'package:sqfliteauth/Components/colors.dart';
import 'package:sqfliteauth/JSON/users.dart';
import 'package:sqfliteauth/Views/addnotes.dart';
import 'package:sqfliteauth/Views/auth.dart';
import 'package:sqfliteauth/Views/login.dart';
import 'package:sqfliteauth/Views/shownotes.dart';
import 'package:sqfliteauth/provider/theme_provider.dart';
import 'package:sqfliteauth/utils/fingerprint_page.dart';
// import 'package:sqfliteauth/provider/provider.dart';
import 'package:sqfliteauth/widgets/details.dart';
import 'package:sqfliteauth/widgets/userditails.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  final Users? profile;

  Profile({super.key, this.profile});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void showimage() {
    AssetImage("assets/no_user.jpg");
  }

  // var locale.toString().contains('AF') = false;
  // var language;

  // removelocale.toString().contains('AF')() async {
  //   final pref = await SharedPreferences.getInstance();
  //   pref.remove("locale.toString().contains('AF')");
  // }

  // getlocale.toString().contains('AF')() async {
  //   final pref = await SharedPreferences.getInstance();
  //   locale.toString().contains('AF') = pref.getBool("locale.toString().contains('AF')")!;
  // }

  // bool locale.toString().contains('AF') = false;
  // var locale.toString().contains('AF') = Locale('dr', 'AF') as bool;
  // bool isshow = false;
  bool islight = false;
  bool isclick = false;
  var slocale;
  removeToken() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove("token");
  }


 var locale;


  storelanguage(locale) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('locale', locale);
  }

  getlocal() async {
    final pref = await SharedPreferences.getInstance();
    slocale = pref.getString('locale');
  }

  removelocal() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove("locale");
  }
  

  removeName() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove("username");
  }

  removePass() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove("userpass");
  }

  late String userName;
  storeUserName() async {
    userName = widget.profile!.usrName;
    final pref = await SharedPreferences.getInstance();
    await pref.setString('username', '$userName');
  }

  late String userPass;
  storeUserPass() async {
    userPass = widget.profile!.password;
    final pref = await SharedPreferences.getInstance();
    await pref.setString('userpass', '$userPass');
  }

  @override
  void didChangeDependencies() {
    // getlocal();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // Get.defaultDialogTransitionDuration(true),
    getlocal();
    Future.delayed(Duration(seconds: 2), () {
      if (slocale != null) {
        setState(() {
          locale = "AF";
          locale = Locale('pa', 'AF');
          Get.updateLocale(locale);
        });
      }
    });
    // getlocale.toString().contains('AF')();
    // TODO: implement initState
    // Get.updateLocale(locale.toString().contains('AF') as Locale);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final controller = Provider.of<UiProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final text = Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? 'DarkTheme'
        : 'LightTheme';

    return Scaffold(
      // drawer: Drawer(),
      appBar: AppBar(
        // backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: widget.profile!.usrName.contains("Silab") &&
                        widget.profile!.password.contains("Silab")
                    ? Text("")
                    : IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddNotes(widget.profile!.usrId)));
                        },
                        icon: Icon(
                          Icons.note_add,
                          size: 30,
                        ),
                      )),
          ),
          Container(
            // width: 80,
            // height: 20,
            // padding: EdgeInsets.only(left: 5),
            alignment: Alignment.centerRight,
            child: Switch.adaptive(
              // splashRadius: BorderSide.strokeAlignOutside,
              // trackOutlineColor: Color(value),
              activeTrackColor: Colors.black,
              // thumbIcon: Icons.get_app.isBlank ,
              activeColor: Colors.white,
              inactiveThumbImage: AssetImage("assets/dark.png"),
              activeThumbImage: AssetImage("assets/light.png"),
              // value: themeProvider.isDarkMode,
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleThemes();
              },
            ),
          ),
          // Switch(
          //   value: Theme.of(context).brightness == Brightness.dark,
          //   onChanged: (value) {
          //     Provider.of<ThemeProvider>(context, listen: false).toggleThemes();
          //   },
          // ),
        ],
        title: widget.profile!.usrName.contains("Silab") &&
                widget.profile!.password.contains("Silab")
            ? Text(
                "Admin Page",
                // style: MyThemes.darkTheme.textTheme.bodyMedium,
              )
            : Text(
                "Profile Page",
                // style: MyThemes.lightTheme.textTheme.bodyMedium,
              ),
      ),

      drawer: Drawer(
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              // maxRadius: 200,
              // minRadius: 50,
              backgroundColor: primaryColor,
              radius: 60,
              child: CircleAvatar(
                backgroundImage:
                    Image.file(File(widget.profile!.usrImage.toString())).image,
                radius: 58,
              ),
            ),
            SizedBox(height: 10),
            // Text(
            //   widget.profile!.fullName ?? "",
            //   style: TextStyle(fontSize: 28, color: primaryColor),
            // ),
            // Text(
            //   widget.profile!.email ?? "",
            //   style: TextStyle(fontSize: 17, color: Colors.grey),
            // ),
            ListTile(
              trailing: locale.toString().contains('AF')
                  ? Icon(
                      Icons.person,
                    )
                  : null,
              leading: locale.toString().contains('AF')
                  ? null
                  : Icon(
                      Icons.person,
                    ),
              title: Text(
                "Full name",
                textAlign: locale.toString().contains('AF')
                    ? TextAlign.right
                    : TextAlign.left,
              ),
              subtitle: Text(
                widget.profile!.fullName ?? "",
                textAlign: locale.toString().contains('AF')
                    ? TextAlign.right
                    : TextAlign.left,
              ),
            ),
            ListTile(
              trailing: locale.toString().contains('AF')
                  ? Icon(
                      Icons.email,
                    )
                  : null,
              leading: locale.toString().contains('AF')
                  ? null
                  : Icon(
                      Icons.email,
                    ),
              title: Text(
                "Email",
                textAlign: locale.toString().contains('AF')
                    ? TextAlign.right
                    : TextAlign.left,
              ),
              subtitle: Text(
                widget.profile!.email ?? "",
                textAlign: locale.toString().contains('AF')
                    ? TextAlign.right
                    : TextAlign.left,
              ),
            ),
            ExpansionTile(
              // expandedAlignment: Alignment.center,
              onExpansionChanged: (value) {
                setState(() {
                  isclick = !isclick;
                });
              },
              // title: Text(""),
              // leading: Icon(locale.toString().contains('AF') ? Icons.language : null),
              trailing: locale.toString().contains('AF')
                  ? Container(
                      width: 130,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Language".tr,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.language_outlined,
                          ),
                        ],
                      ),
                    )

                  // semanticLabel: "Language".tr,

                  : Icon(isclick
                      ? Icons.keyboard_arrow_up_outlined
                      : Icons.keyboard_arrow_down_outlined),
              title: locale.toString().contains('AF')
                  ? Row(
                      children: [
                        Icon(isclick
                            ? Icons.keyboard_arrow_up_outlined
                            : Icons.keyboard_arrow_down_outlined),
                        // SizedBox(
                        //   width: 1,
                        // ),
                      ],
                    )
                  : Row(
                      children: [
                        Icon(
                          Icons.language_outlined,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Language".tr,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
              children: [
                ListTile(
                  title: Text(
                    "English".tr,
                    textAlign: locale.toString().contains('AF')
                        ? TextAlign.right
                        : TextAlign.left,
                  ),
                  onTap: () {
                    setState(() {
                      // language = false;
                      removelocal();
                      // removelocale.toString().contains('AF')();
                      locale = Locale('en', 'US');
                      Get.updateLocale(locale);
                      // Get.reset();
                    });
                  },
                ),
                ListTile(
                  title: Text(
                    "Pashto".tr,
                    textAlign: locale.toString().contains('AF')
                        ? TextAlign.right
                        : TextAlign.left,
                  ),
                  onTap: () {
                    setState(() {
                      // language = true;

                      // storelanguage();
                      locale = Locale('pa', 'AF');
                      Get.updateLocale(locale);
                      storelanguage("AF");
                      // Get.reset();
                    });
                  },
                ),
                ListTile(
                  title: Text(
                    "Dari".tr,
                    textAlign: locale.toString().contains('AF')
                        ? TextAlign.right
                        : TextAlign.left,
                  ),
                  onTap: () {
                    setState(() {
                      // language = true;
                      // storelanguage();

                      locale = Locale('dr', 'AF');
                      Get.updateLocale(locale);
                      storelanguage('AF');
                      // Get.reset();
                    });
                  },
                )
              ],
            ),

            ListTile(
              title: Text(
                "Settings",
                textAlign: locale.toString().contains('AF')
                    ? TextAlign.right
                    : TextAlign.left,
              ),
              trailing: locale.toString().contains('AF')
                  ? Icon(
                      Icons.settings,
                    )
                  : null,
              leading: locale.toString().contains('AF')
                  ? null
                  : Icon(
                      Icons.settings,
                    ),
              onTap: () {
                setState(() {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (Context) => UserDetails(
                      userId: widget.profile!.usrId as int,
                      name: widget.profile!.usrName,
                      fullName: widget.profile!.fullName.toString(),
                      email: widget.profile!.email.toString(),
                      imageurl: widget.profile!.usrImage.toString(),
                      password: widget.profile!.password,
                    ),
                  ));
                });
              },
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  locale.toString().contains('AF')
                      ? ListTile(
                          trailing: const Icon(Icons.power_settings_new),
                          title:
                              const Text("Logout", textAlign: TextAlign.right),
                          leading: const Icon(
                            Icons.arrow_back_ios_new_sharp,
                            size: 14,
                          ),
                          onTap: () => showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Are you sure?'),
                              content: Text(
                                'Do you want to Logout?',
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
                                    removeToken();

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AuthScreen()));
                                    // Navigator.of(ctx).pop(true);
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListTile(
                          leading: const Icon(Icons.power_settings_new),
                          title: const Text("Logout"),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                          ),
                          onTap: () => showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Are you sure?'),
                              content: Text(
                                'Do you want to Logout?',
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text('No'),
                                  onPressed: () {
                                    // Navigator.pushReplacement(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             FingerprintPage()));
                                    Navigator.of(ctx).pop(false);
                                  },
                                ),
                                ElevatedButton(
                                  child: Text('Yes'),
                                  onPressed: () {
                                    removeToken();
                                    // removeName();
                                    // removePass();
                                    //Navigator.pushReplacement(
                                    // context,

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AuthScreen()));
                                    // Navigator.of(ctx).pop(true);
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                ],
              ),
            )
          ],
        ),
      ),
      body: ShowNotes(
          userId: widget.profile!.usrId as int, profile: widget.profile),
    );
  }
}
