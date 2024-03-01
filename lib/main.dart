import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sqfliteauth/JSON/users.dart';
import 'package:sqfliteauth/Views/auth.dart';
import 'package:provider/provider.dart';
import 'package:sqfliteauth/Views/login.dart';
import 'package:sqfliteauth/Views/profile.dart';
import 'package:sqfliteauth/database/database_helper.dart';
import 'package:sqfliteauth/localstring.dart';
// import 'package:sqfliteauth/provider/provider.dart';
import 'package:sqfliteauth/provider/theme_provider.dart';
import 'package:sqfliteauth/utils/authentication_screent.dart';
import 'package:sqfliteauth/utils/fingerprint_page.dart';
import 'package:sqfliteauth/widgets/splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final db = DatabaseHelper();

  late Users? profile;

  Users? usrDetails;
  @override
  login() async {
    // setState(() async{
    usrDetails = await db.getUser(profile!.usrName);

    // });

    //   Navigator.push(context, MaterialPageRoute(builder: (context)=> Profile(profile: usrDetails)));
  }

  // TODO: implement initState

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, ThemeProvider notifier, child) {
          final controller = Provider.of<ThemeProvider>(context, listen: false);
          return GetMaterialApp(
            transitionDuration: Duration(days: 30),
            locale: Get.deviceLocale,
            enableLog: true,

            translations: localstring(),
            themeMode: ThemeMode.system,
            color: Colors.teal,
            darkTheme: MyThemes.darkTheme,
            // controller.darkLight ? ThemeData.dark() : ThemeData.light(),
            debugShowCheckedModeBanner: false,
            // title: ',
            theme: controller.currentTheme,

            home: SplashScreen(),
          );
        },
      ),
    );
    // ChangeNotifierProvider(
    //   create: (context) => UiProvider()..initStorage(),
    //   child:
    //       Consumer<UiProvider>(builder: (context, UiProvider notifier, child) {
    //     return MaterialApp(
    //       debugShowCheckedModeBanner: false,
    //       title: 'Flutter Demo',
    //       theme: ThemeData(
    //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //         useMaterial3: true,
    //       ),
    //       //Our fist screen
    //       home: SplashScreen(),
    //     );
    //   }),
    // );
  }
}
