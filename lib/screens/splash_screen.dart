import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wings_advanced_tasl/screens/first_page.dart';
import 'package:wings_advanced_tasl/screens/user_list.dart';

import 'api_page.dart';

class SplashScreeen extends StatefulWidget {
  const SplashScreeen({super.key});

  @override
  State<SplashScreeen> createState() => _SplashScreeenState();
}

class _SplashScreeenState extends State<SplashScreeen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isAdmin = sharedPreferences.getBool("is_admin") ?? false;
    String isLoginToken = sharedPreferences.getString("user_login_token") ?? "";

    Future.delayed(Duration(seconds: 2), () {
      if (isAdmin && isLoginToken.isNotEmpty) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => UserList(),
        ));
      }

      if (!isAdmin && isLoginToken.isNotEmpty) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => APIPage(),
        ));
      }
      if (isLoginToken.isEmpty) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => FirstPage(),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: FlutterLogo(),
    ));
  }
}
