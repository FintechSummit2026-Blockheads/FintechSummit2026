import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
// import 'package:mingle/backend-client.dart';
import 'package:mingle/components/mingle-button.dart';
import 'package:mingle/components/mingle-overlay.dart';
import 'package:mingle/components/mingle-title.dart';
import 'package:mingle/screens/login/register-upload-dp.dart';
import 'package:mingle/styles/colors.dart';
import 'package:mingle/styles/login-register-bg.dart';
import 'package:mingle/styles/widget-styles.dart';
import 'package:mingle/components/dialogs.dart' show showErrorAlertDialog;
import 'package:mingle/utils/form-validator.dart';
import 'dart:convert';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // BackendClient backEndClient = BackendClient();
  bool passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  // Get a reference your Supabase client
  // final supabase = Supabase.instance.client;

  // void signUp({
  //   required String name,
  //   required String email,
  //   required String password,
  // }) async {
  //   final loader = LoadingOverlay();
  //   loader.show(context);
  //   try {
  //     backEndClient.getRequest("/auth/check_email?email=$email").then((
  //       res,
  //     ) {
  //       if (res.statusCode == 200) {
  //         Get.to(
  //           RegisterUploadDP(
  //             backendClient: backEndClient,
  //             name: name,
  //             email: email,
  //             password: password,
  //           ),
  //           transition: pageTransitionStyle,
  //         );
  //       } else {
  //         if (!mounted) return; // Just keep it its for context issues
  //         String message = json.decode(res.body)['detail'];
  //         showErrorAlertDialog(context, message);
  //       }
  //     });
  //   } catch (error) {
  //     if (!mounted) return; // Just keep it its for context issues
  //     showErrorAlertDialog(context, "Please try again.");
  //   } finally {
  //     loader.hide();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Fix for bottom overflow by blank pixels error
      body: LoginRegisterBg(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.05),
            mingleTitle(size: 64),
            Text(
              "Sign Up For Free.",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(height: height * 0.10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: name,
                    decoration: textFieldDeco.copyWith(hintText: "Name"),
                    validator: (value) => FormValidator.isEmpty(value, "name"),
                  ),
                  SizedBox(height: height * 0.033),
                  TextFormField(
                    autofillHints: [AutofillHints.email],
                    controller: email,
                    decoration: textFieldDeco.copyWith(hintText: "Email"),
                    validator: FormValidator.validateEmail,
                  ),
                  SizedBox(height: height * 0.033),
                  TextFormField(
                    obscureText: !passwordVisible,
                    controller: password,
                    decoration: textFieldDeco.copyWith(
                      hintText: "Password",
                      suffixIcon: IconButton(
                        icon:
                            passwordVisible
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                        color: passwordVisible ? secondary : grey,
                        splashColor: Colors.transparent,
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                    ),
                    validator:
                        (value) => FormValidator.isEmpty(value, "password"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: height * 0.033,
                horizontal: 0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: mingleButton(
                      text: "Sign Up",
                      onPressed: () async {
                        // if (_formKey.currentState!.validate()) {
                        //   // Form is valid
                        //   signUp(
                        //     name: name.text,
                        //     email: email.text,
                        //     password: password.text,
                        //   );
                        // }
                        Get.to(RegisterUploadDP());
                        // Get.to(RegisterUploadDP(name: name, email: email, password: password))
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.18),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 16),
                children: [
                  const TextSpan(text: "Already have an account? "),
                  TextSpan(
                    text: "Login",
                    style: const TextStyle(
                      color: secondary, // Purple color
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            Get.back();
                          },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}