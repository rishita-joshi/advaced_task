import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wings_advanced_tasl/main.dart';
import 'package:wings_advanced_tasl/screens/login_screen.dart';
import 'package:wings_advanced_tasl/screens/user_list.dart';
import '../model/user_model.dart';
import '../notification/awesome_notification.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    sendNotification();
                  },
                  child: Text("Send notification")),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    loginAsAdmin();
                  },
                  child: Text("Login as Admin")),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Text("Login as User")),
            ),
          ]),
    );
  }

  void loginAsAdmin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userToken = sharedPreferences.getString("user_token");
    authServices
        .createAuthUser("testwtsm@gmail.com", "wts@123")
        .then((value) => {
              if (value!.uid != null)
                {
                  sharedPreferences.setString(
                      "user_login_token", value.uid.toString()),
                  userService
                      .saveAdminToFirebase(UserModel(
                          userName: "testwtsm@gmail.com",
                          email: "testwtsm@gmail.com",
                          phoneNumber: "1234556789",
                          userFcmToken: userToken!,
                          userId: value.uid,
                          userRole: 'admin'))
                      .then((value) => {
                            if (value.isNotEmpty)
                              {
                                sharedPreferences.setBool("is_admin", true),
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const UserList()),
                                )
                              }
                          })
                }
            });
  }

  void sendNotification() {
    NotificationController.createNewNotification();
  }
}
//userService
               //        .isEmailExists("testwtsm@gmail.com")
               //        .then((value1) => {
               //              if (!value1)
               //                {