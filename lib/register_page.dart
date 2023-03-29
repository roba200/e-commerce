import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'my_button.dart';
import 'my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final nameController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final cityController = TextEditingController();
  final provinceController = TextEditingController();
  final countryController = TextEditingController();
  final zipController = TextEditingController();
  final numberController = TextEditingController();

  Future signUp() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "address1": address1Controller.text,
        "address2": address2Controller.text,
        "city": cityController.text,
        "country": countryController.text,
        "name": nameController.text,
        "number": numberController.text,
        "province": provinceController.text,
        "zip": zipController.text,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),

                const SizedBox(height: 50),

                // welcome back, you've been missed!
                Text(
                  'Hello There!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // email textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: confirmpasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                const SizedBox(height: 60),

                MyTextField(
                  controller: nameController,
                  hintText: 'Full Name',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: address1Controller,
                  hintText: 'Address Line 1',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: address2Controller,
                  hintText: 'Address Line 2',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: cityController,
                  hintText: 'City',
                  obscureText: false,
                ),

                const SizedBox(height: 10),
                MyTextField(
                  controller: provinceController,
                  hintText: 'Province',
                  obscureText: false,
                ),

                const SizedBox(height: 10),
                MyTextField(
                  controller: countryController,
                  hintText: 'Country',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: zipController,
                  hintText: 'ZIP Code',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: numberController,
                  hintText: 'Contact Number',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // forgot password?

                const SizedBox(height: 25),

                // sign in button
                GestureDetector(
                  onTap: signUp,
                  child: MyButton(
                    text: "Register",
                    onTap: signUp,
                  ),
                ),

                const SizedBox(height: 20),

                // not a member? register now
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Allready a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.showLoginPage,
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
