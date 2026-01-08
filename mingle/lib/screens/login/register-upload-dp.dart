import 'package:dotted_border/dotted_border.dart' show BorderType, DottedBorder;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mingle/components/mingle-button.dart';
import 'package:mingle/components/mingle-overlay.dart' show LoadingOverlay;
import 'package:mingle/components/mingle-title.dart';
import 'package:mingle/widgets/NavBar-restaurant.dart';
import 'package:mingle/widgets/NavBar-user.dart';
import 'package:mingle/styles/colors.dart';
import 'package:mingle/styles/login-register-bg.dart';
import 'package:mingle/styles/widget-styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mingle/components/dialogs.dart' show showErrorAlertDialog;
import 'package:mingle/utils/form-validator.dart';
import 'package:mingle/screens/login/register-controller.dart';
import 'dart:io';

class RegisterUploadDP extends StatefulWidget {
  final String name;
  final String email;
  final String password;

  const RegisterUploadDP({
    super.key,
    this.name = '',
    this.email = '',
    this.password = '',
  });

  @override
  State<RegisterUploadDP> createState() => _RegisterUploadDPState();
}

class _RegisterUploadDPState extends State<RegisterUploadDP> {
  TextEditingController userName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? file;

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

  //other role selector (TODO)
  // List<bool> selectedRole = [true, false]; // default: User
  bool isLoading = false;

  final RegisterController registerController = Get.put(RegisterController());
 // Image picker 
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        file = File(image.path);
      });
    }
  }

  Future<void> handleSignUp() async {
     if (file == null) {
      Get.snackbar(
        "Note",
        "Please select a profile picture",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await registerController.registerUser(
        name: widget.name,
        email: widget.email,
        password: widget.password,
        description: userName.text,
        isUser: isUser,
      );

      if (result['success']) {
        // Save role to SharedPreferences
        await saveRole();

        Get.snackbar(
          "Success",
          "Registration successful!",
          snackPosition: SnackPosition.BOTTOM,
        );

        // Navigate based on role
        if (isUser) {
          Get.offAll(() => NavBarUser());
        } else {
          Get.offAll(() => NavBarRestaurant());
        }
      } else {
        Get.snackbar(
          "Error",
          result['message'] ?? "Registration failed",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Registration failed: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LoginRegisterBg(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            mingleTitle(size: 64),
            SizedBox(height: height * 0.01),
            Text(
              "Personalise Your Account",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: height * 0.045),
            
            /// Profile Picture upload
            GestureDetector(
              onTap: pickImage,
              child: file == null
                  ? DottedBorder(
                      borderType: BorderType.RRect,
                      color: secondary,
                      dashPattern: [6, 3],
                      strokeWidth: 2,
                      radius: Radius.circular(8),
                      child: Container(
                        width: 150,
                        height: 150,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_rounded,
                              size: 40,
                              color: Colors.black,
                            ),
                            Text(
                              "Upload Profile Photo",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        file!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            SizedBox(height: height * 0.03),

            /// Description box
            Form(
              key: _formKey,
              child: TextFormField(
                controller: userName,
                decoration: textFieldDeco.copyWith(hintText: "Description about yourself"),
                validator: (value) => FormValidator.isEmpty(value, "description"),
              ),
            ),
            SizedBox(height: height * 0.015),

            /// Role Selection
            Text("Select Account Type:", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
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

            /// Confirm Button
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: height * 0.033,
                horizontal: 0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: mingleButton(
                      text: isLoading ? "Registering..." : "Sign Up",
                      onPressed: isLoading ? null : () async {
                        handleSignUp();
                                        
                       
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    userName.dispose();
    super.dispose();
  }
}