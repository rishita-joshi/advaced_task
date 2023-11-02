import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wings_advanced_tasl/model/user_model.dart';
import 'package:wings_advanced_tasl/screens/login_screen.dart';
import '../components/button_widget.dart';
import '../components/text_components.dart';
import '../main.dart';
import '../utils/validators.dart';

class SignUpUser extends StatefulWidget {
  const SignUpUser({super.key});

  @override
  State<SignUpUser> createState() => _SignUpUserState();
}

class _SignUpUserState extends State<SignUpUser> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var userNameController = TextEditingController();
  var phoneController = TextEditingController();
  var countryCode;
  bool isSignup = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text("Create New User"),
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
                  validator: (value) => Validators.emailValidate(value!),
                ),
                SizedBox(
                  height: 10,
                ),
                EventTextBoxWidget(
                  prefixWidget: IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CountryCodePicker(
                          initialSelection: countryCode,
                          showCountryOnly: false,
                          showFlag: true,
                          showFlagDialog: true,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                          dialogBackgroundColor: Theme.of(context).cardColor,
                          barrierColor: Colors.black12,
                          searchDecoration: InputDecoration(
                              iconColor: Theme.of(context).dividerColor,
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).dividerColor)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide())),
                          onInit: (c) {
                            countryCode = c!.dialCode!;
                          },
                          onChanged: (c) {
                            countryCode = c.dialCode!;
                          },
                        ),
                        VerticalDivider(color: Colors.grey.withOpacity(0.5))
                      ],
                    ),
                  ),
                  controller: phoneController,
                  hintText: 'Enter Phone Number',
                  inputType: TextInputType.phone,
                  // validator: (value) => Validators.emailValidate(value!),
                ),
                SizedBox(
                  height: 10,
                ),
                buttonWidget(isSignup: isSignup, "Register User", () {
                  if (formKey.currentState!.validate()) {
                    registerUser();
                  }
                }, context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void registerUser() async {
    setState(() {
      isSignup = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userToken = sharedPreferences.getString("user_token");
    sharedPreferences.setString("user_email", emailController.text);
    sharedPreferences.setString("user_name", userNameController.text);
    authServices
        .createAuthUser(emailController.text, passwordController.text)
        .then((value) => {
              print(value),
              if (value!.uid != null)
                {
                  userService.saveAdminToFirebase(UserModel(
                      userId: value.uid,
                      userFcmToken: userToken!,
                      userName: userNameController.text,
                      email: emailController.text,
                      phoneNumber: phoneController.text,
                      userRole: 'user'))
                }
            })
        .then((value) => {
              setState(() {
                isSignup = false;
              }),
              if (value.isNotEmpty)
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  ),
                }
            });
  }
}
