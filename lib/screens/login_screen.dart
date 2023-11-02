import 'package:flutter/material.dart';
import 'package:wings_advanced_tasl/main.dart';
import 'package:wings_advanced_tasl/screens/signup_user.dart';
import '../components/button_widget.dart';
import '../components/text_components.dart';
import '../utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isSignup = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 30),
        child: InkWell(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => SignUpUser(),
              ));
            },
            child: Text("Signup?")),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                EventTextBoxWidget(
                  controller: emailController,
                  hintText: 'Enter Email',
                  inputType: TextInputType.emailAddress,
                  validator: (value) => Validators.emailValidate(value),
                ),
                SizedBox(
                  height: 10,
                ),
                EventTextBoxWidget(
                  controller: passwordController,
                  hintText: 'Enter  Password',
                  inputType: TextInputType.text,
                  validator: (value) => Validators.emailValidate(value),
                ),
                SizedBox(
                  height: 15,
                ),
                buttonWidget(isSignup: isSignup, "Login", () {}, context),
                SizedBox(
                  height: 15,
                ),
              ]),
        ),
      ),
    );
  }

  void login() {
    setState(() {
      bool isSignup = false;
    });
    if (_formKey.currentState!.validate()) {
      authServices.signInWithEmailPassword(context,
          email: emailController.text, password: passwordController.text);
    }
  }
}
