import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mounarchtech_task/screens/user_slider_screen.dart';
import 'package:mounarchtech_task/services/local_repo.dart';
import 'package:mounarchtech_task/widget/text_feild.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  TextEditingController nameController = TextEditingController();
  XFile? _selectedImage;
  bool visibility = true;
  ImagePicker _image_picker = ImagePicker();
  
  final _formKey = GlobalKey<FormState>();  // Key for the Form widget

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 150),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Sign up now",
                    style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(27, 30, 40, 1)))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Please fill the details and create account",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(125, 132, 141, 1)))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
              child: Form(  // Wrap your fields with the Form widget
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextFeild(
                      hintText: 'Enter Name',
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextFeild(
                      hintText: 'Enter Email',
                      controller: emailCon,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: passwordCon,
                      obscureText: visibility,
                      obscuringCharacter: '*',
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(125, 132, 141, 1)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(14)),
                        fillColor: const Color.fromRGBO(247, 247, 249, 1),
                        filled: true,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              visibility = !visibility;
                            });
                          },
                          icon: Icon(visibility
                              ? Icons.visibility_off
                              : Icons.visibility)
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password should be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () async {
                        _selectedImage = await _image_picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
                        setState(() {});
                      },
                      child: Container(
                        width: 120,
                        height: 120,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: _selectedImage != null
                            ? Image.file(File(_selectedImage!.path), fit: BoxFit.cover)
                            : Image.network("https://icons.veryicon.com/png/o/miscellaneous/standard/avatar-15.png"),
                      ),
                    ),
                    const Text("Upload Profile Pic"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Color.fromRGBO(13, 110, 253, 1)),
                        minimumSize: WidgetStatePropertyAll(Size(double.infinity, 56)),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {  
                          
                          LocalRepo.storeData(
                            name: nameController.text, 
                            email: emailCon.text, 
                            imageUrl: _selectedImage?.path ?? "https://icons.veryicon.com/png/o/miscellaneous/standard/avatar-15.png"
                          );

                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                            return UserSliderScreen();
                          }));
                        }
                      },
                      child: Text("Sign Up",
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromRGBO(255, 255, 255, 1))),
                    ),
                    const SizedBox(height: 35),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
