import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mingle/components/mingle-title.dart';
import 'package:mingle/screens/login/register.dart';
import 'package:mingle/styles/login-register-bg.dart';
import 'package:mingle/styles/widget-styles.dart';
import 'package:mingle/widgets/NavBar-restaurant.dart';
import 'package:mingle/widgets/NavBar-user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/mingle-button.dart';
import '../../../styles/colors.dart';
import 'package:mingle/services/auth_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Get a reference your Supabase client
  // final supabase = Supabase.instance.client;

  bool passwordVisible = false;
  late TextEditingController email;
  late TextEditingController password;
  bool isLoading = false;
  // List<bool> selectedRole = [true, false]; // default: User

  @override
  void initState() {
    super.initState();
    // Initialize controllers without default text
    email = TextEditingController();
    password = TextEditingController();
    loadSavedRole();
  }

  // NEW: selection state, 0 = User, 1 = Restaurant
  bool isUser = true; // default: User

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
      resizeToAvoidBottomInset: false,
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
              SizedBox(height: height * 0.1),
              
              /// Role Selection (User / Restaurant)
              Text("Login as:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              ToggleButtons(
                borderRadius: BorderRadius.circular(12),
                selectedColor: Colors.white,
                fillColor: secondary,
                color: black,
                isSelected: [isUser, !isUser],
                onPressed: (int index) {
                  setState(() {
                    isUser = index == 0; // 0 = User, 1 = Restaurant
                  });
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
              SizedBox(height: height * 0.05),
              
              TextFormField(
                autofillHints: [AutofillHints.email],
                controller: email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                enableInteractiveSelection: true,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')),
                ],
                decoration: textFieldDeco.copyWith(hintText: "Email"),
              ),
              SizedBox(height: height * 0.033),
              TextFormField(
                obscureText: !passwordVisible,
                controller: password,
                textInputAction: TextInputAction.done,
                enableInteractiveSelection: true,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'[\n\r]')),
                ],
                decoration: textFieldDeco.copyWith(
                  hintText: "Password",
                  suffixIcon: IconButton(
                    icon: passwordVisible
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

              // //select user/restaurant role
              // ToggleButtons(
              //   borderRadius: BorderRadius.circular(12),
              //   selectedColor: Colors.white,
              //   fillColor: secondary,
              //   color: black,
              //   isSelected: [isUser, !isUser],
              //   onPressed: (int index) async {
              //     setState(() {
              //       isUser = index == 0; // 0 = User, 1 = Restaurant
              //     });
              //     await saveRole(); // save immediately
              //   },
              //   children: const [
              //     Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 16),
              //       child: Text("User"),
              //     ),
              //     Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 16),
              //       child: Text("Restaurant"),
              //     ),
              //   ],
              // ),


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
                        text: isLoading ? "Loading..." : "Login",                        
                        onPressed: isLoading ? null : () async {
                          await saveRole();
                          handleLogin();

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
              SizedBox(height: height * 0.10),
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
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(() => Register(),
                              transition: pageTransitionStyle);
                        },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 17),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleLogin() async {
    try {
      // Validate inputs
      if (email.text.isEmpty || password.text.isEmpty) {
        Get.snackbar(
          "Error",
          "Please fill in all fields",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Show loading state
      setState(() {
        isLoading = true;
      });

      // Get selected role
      String selectedLoginRole = isUser ? "user" : "restaurant";

      // Call different API based on role
      final result = isUser
          ? await AuthService().loginUser(email.text, password.text)
          : await AuthService().loginRestaurant(email.text, password.text);

      if (result['success']) {
        // Save the selected role to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('role', selectedLoginRole);

        // Navigate based on selected role
        if (selectedLoginRole == "user") {
          Get.offAll(() => NavBarUser());
        } else if (selectedLoginRole == "restaurant") {
          Get.offAll(() => NavBarRestaurant());
        } else {
          Get.snackbar(
            "Error",
            "Unknown role: $selectedLoginRole",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        // Show error message from API
        Get.snackbar(
          "Error",
          result['message'] ?? "Login failed",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Login failed: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      // Hide loading state
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}