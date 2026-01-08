import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingle/components/mingle-title.dart';
import 'package:mingle/components/mingle-overlay.dart';
import 'package:mingle/screens/explore/explore-page.dart';
import 'package:mingle/screens/login/register.dart';
import 'package:mingle/screens/login/register.dart';
import 'package:mingle/styles/login-register-bg.dart';
import 'package:mingle/styles/widget-styles.dart';
import 'package:mingle/widgets/NavBar-restaurant.dart';
import 'package:mingle/widgets/NavBar-user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/mingle-button.dart';
import '../../../styles/colors.dart';
import 'package:mingle/components/dialogs.dart' show showErrorAlertDialog;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Get a reference your Supabase client
  // final supabase = Supabase.instance.client;

  bool passwordVisible = false;
  TextEditingController email = TextEditingController(text: "123@gmail.com");
  TextEditingController password = TextEditingController(text: "123456");

  // NEW: selection state, 0 = User, 1 = Restaurant
  bool isUser = true; // default: User

  @override
  void initState() {
    super.initState();
    loadSavedRole();
  }

  Future<void> loadSavedRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString("role");

    if (role != null) {
      setState(() {
        isUser = role == "user";
      });
    }
  }

  // Save role to SharedPreferences
  Future<void> saveRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("role", isUser ? "user" : "restaurant");
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset : false, // Fix for bottom overflow by blank pixels error
      body: SingleChildScrollView(
        child: LoginRegisterBg(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.1),
              mingleTitle(size: 64),
              Text(
                "Join the Community.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              Text(
                "Fashionable and professional pre-loved",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: height * 0.1),
              TextFormField(
                autofillHints: [AutofillHints.email],
                controller: email,
                decoration: textFieldDeco.copyWith(hintText: "Email"),
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
              ),

              SizedBox(height: height * 0.033),

              //select user/restaurant role
              ToggleButtons(
                borderRadius: BorderRadius.circular(12),
                selectedColor: Colors.white,
                fillColor: secondary,
                color: black,
                isSelected: [isUser, !isUser],
                onPressed: (int index) async {
                  setState(() {
                    isUser = index == 0; // 0 = User, 1 = Restaurant
                  });
                  await saveRole(); // save immediately
                },
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("User"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("Restaurant"),
                  ),
                ],
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
                        key: Key('goToMainPage'),
                        text: "Login",
                        onPressed: () async {
                          await saveRole(); // ensure role is saved

                          if (isUser) {
                            Get.offAll(() => NavBarUser());
                          } else {
                            Get.offAll(() => NavBarRestaurant());
                          }
                          // final loader = LoadingOverlay();
                          // loader.show(context);
                          // try {
                          //   await supabase.auth.signInWithPassword(
                          //     email: email.text,
                          //     password: password.text,
                          //   );
                          //   // Route to nav bar
                          //   Get.offAll(() => NavBar());
                          // } on AuthException catch (e) {
                          //   if (!mounted) return; // Just keep it its for context issues
                          //   showErrorAlertDialog(context, e.message);
                          // } catch (error) {
                          //   if (!mounted) return; // Just keep it its for context issues
                          //   showErrorAlertDialog(context, "Please try again");
                          // } finally {
                          //   loader.hide();
                          // }
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
                    const TextSpan(text: "Don't have an account? "),
                    TextSpan(
                      text: "Sign Up",
                      style: const TextStyle(
                        color: secondary,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(() => Register(), transition: pageTransitionStyle);
                            },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 17),
              // GestureDetector(
              //   onTap: () {
              //     Get.to(() => ForgetPassword(), transition: pageTransitionStyle);
              //   },
              //   child: Text(
              //     "Forgot your password?",
              //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              //   ),
              // ),
              // SizedBox(height: 32),
            ],
          ),
        ),
      )
    );
  }
}