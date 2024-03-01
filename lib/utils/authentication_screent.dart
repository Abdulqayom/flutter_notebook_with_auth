import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import '';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  // static bool mounted = false;
  static final _auth = LocalAuthentication();
  bool? _canCheckBiometric;
  String autherized = "Not Autherized";
  List<BiometricType>? _availableBiometrics;

  Future<void> checkBiometrics() async {
    bool? canCheckBiometric;
    try {
      canCheckBiometric = await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future<void> getAvailableBiometrics() async {
    List<BiometricType>? availableBiometrics;

    try {
      availableBiometrics = await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> authenticate() async {
    bool authenticated = false;

    try {
      authenticated = await _auth.authenticate(
          localizedReason: 'Scan Fingerprint to Authenticate',
          options: AuthenticationOptions(
              useErrorDialogs: true,
              stickyAuth: false,
              biometricOnly: true,
              sensitiveTransaction: true));
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      autherized = authenticated ? "success" : "Failer";
      print(autherized);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    checkBiometrics();
    getAvailableBiometrics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Finger Print Data"),
      ),
      body: Center(
        child:
            IconButton(onPressed: authenticate, icon: Icon(Icons.fingerprint)),
      ),
    );
  }
}
