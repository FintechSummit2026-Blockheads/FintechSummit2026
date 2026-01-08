import 'package:dotted_border/dotted_border.dart' show BorderType, DottedBorder;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:mingle/backend-client.dart';
import 'package:mingle/components/mingle-button.dart';
import 'package:mingle/components/mingle-overlay.dart' show LoadingOverlay;
import 'package:mingle/components/mingle-title.dart';
import 'package:mingle/widgets/NavBar-restaurant.dart';
import 'package:mingle/widgets/NavBar-user.dart';
import 'package:mingle/styles/colors.dart';
import 'package:mingle/styles/login-register-bg.dart';
import 'package:mingle/styles/widget-styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:image-picker/image-picker.dart';
import 'package:path/path.dart' as path;
import 'package:mingle/components/dialogs.dart' show showErrorAlertDialog;
import 'package:mingle/utils/form-validator.dart';
import 'dart:io';
import 'dart:convert';
// import 'package:supabase_flutter/supabase_flutter.dart'
    // show AuthException, AuthResponse, FileOptions, Supabase;

class RegisterUploadDP extends StatefulWidget {
  // final BackendClient backendClient;
  // final String name, email, password;

  const RegisterUploadDP({
    super.key,
    // required this.backendClient,
    // required this.name,
    // required this.email,
    // required this.password,
  });

  @override
  State<RegisterUploadDP> createState() => _RegisterUploadDPState();
}

class _RegisterUploadDPState extends State<RegisterUploadDP> {
  TextEditingController userName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // final ImagePicker picker = ImagePicker();
  // final supabase = Supabase.instance.client;
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

  // Future<File?> pickImage() async {
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  //   if (image == null) return null;
  //   return File(image.path);
  // }

  // Future<String> uploadImage(File file) async {
  //   try {
  //     // final user = Supabase.instance.client.auth.currentUser;
  //     final fileName =
  //         '${user!.id}_${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';
  //     return await supabase.storage
  //         .from('profile-images')
  //         .upload(
  //           'public/$fileName',
  //           file,
  //           fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
  //         );
  //   } catch (e) {
  //     print("print: " + e.toString());
  //     return e.toString();
  //   }
  // }

  // void signup_2() async {
  //   final loader = LoadingOverlay();
  //   loader.show(context);
  //   try {
  //     widget.backendClient
  //         .getRequest("/auth/check_username?user_name=${userName.text}")
  //         .then((res) async {
  //           if (res.statusCode == 200) {
  //             try {
  //               final AuthResponse res = await supabase.auth.signUp(
  //                 email: widget.email,
  //                 password: widget.password,
  //                 data: {'user_name': userName.text, 'name': widget.name},
  //               );

  //               String filename = await uploadImage(file!);

  //               widget.backendClient
  //                   .postRequest("/auth/signup", {
  //                     'name': widget.name,
  //                     'email': widget.email,
  //                     'profile_url': filename,
  //                     "user_name": userName.text,
  //                   })
  //                   .then((res) {
  //                     if (res.statusCode == 200) {
  //                       // Opens Nav Bar
  //                       Get.offAll(() => NavBar());
  //                     } else {
  //                       // Error
  //                       if (!mounted)
  //                         return; // Just keep it its for context issues
  //                       String message = json.decode(res.body)['detail'];
  //                       showErrorAlertDialog(context, message);
  //                     }
  //                   });
  //             } on AuthException catch (e) {
  //               if (!mounted) return; // Just keep it its for context issues
  //               showErrorAlertDialog(context, e.message);
  //             } catch (error) {
  //               if (!mounted) return; // Just keep it its for context issues
  //               showErrorAlertDialog(context, "Please try again");
  //             } finally {
  //               loader.hide();
  //             }
  //           } else {
  //             if (!mounted) return; // Just keep it its for context issues
  //             String message = json.decode(res.body)['detail'];
  //             showErrorAlertDialog(context, message);
  //           }
  //         });
  //   } catch (error) {
  //     if (!mounted) return; // Just keep it its for context issues
  //     showErrorAlertDialog(context, "Please try again");
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
                decoration: textFieldDeco.copyWith(hintText: "Description"),
                validator: (value) => FormValidator.isEmpty(value, "description!"),
              ),
            ),

            SizedBox(height: height * 0.015),
            
            /// Role Selection (Restaurant / User)
            /// Role selection
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
                      text: "Confirm",
                      onPressed: () async {
                        if (file == null) {
                          Get.snackbar(
                            "Note",
                            "Please select a profile picture",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Color(0xFFFFFFFF),
                          );
                        } else if (_formKey.currentState!.validate()) {
                          // signup_2();
                          // Save role locally
                          await saveRole();

                          // TODO: call signup function here if needed
                          // Navigate to correct page based on role
                          if (isUser) {
                            Get.offAll(() => NavBarUser());
                          } else {
                            Get.offAll(() => NavBarRestaurant());
                          }
                        }
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
}