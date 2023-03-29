import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/forgot_password_page.dart';
import 'package:e_commerce_app/square_tile.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'my_button.dart';
import 'my_textfield.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // WRONG EMAIL
      if (e.code == 'user-not-found') {
        // show error to user
        wrongEmailMessage();
      }

      // WRONG PASSWORD
      else if (e.code == 'wrong-password') {
        // show error to user
        wrongPasswordMessage();
      }
    }
  }

  // wrong email message popup
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Email',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // wrong password message popup
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Password',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  // logo
                  Image.asset(
                    "lib/images/logo.png",
                    height: 200,
                  ),

                  const SizedBox(height: 50),

                  // email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? 'Enter a valid email'
                            : null,
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    validator: (value) {
                      if (value != null && value.length < 6) {
                        return "Password must have least 6 charactors";
                      } else {
                        return null;
                      }
                    },
                  ),

                  const SizedBox(height: 10),

                  // forgot password?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordPage()));
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // sign in button
                  MyButton(
                    text: "Sign In",
                    onTap: () {
                      final form = formKey.currentState!;
                      if (form.validate()) {
                        signUserIn();
                      }
                    },
                  ),

                  const SizedBox(height: 50),

                  // or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // google + apple sign in buttons
                  GestureDetector(
                    child: SquareTile(imagePath: 'lib/images/google.png'),
                    onTap: signInWithGoogle,
                  ),

                  const SizedBox(height: 50),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.showRegisterPage,
                        child: const Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> checkIfDocumentExists(
      String collectionName, String documentId) async {
    DocumentReference documentReference =
        firestore.collection(collectionName).doc(documentId);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    return documentSnapshot.exists;
  }

  Future<void> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await auth.signInWithCredential(credential).then((value) async {
      if (await checkIfDocumentExists(
              'users', FirebaseAuth.instance.currentUser!.uid) ==
          false) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          "address1": "",
          "address2": "",
          "city": "",
          "country": "",
          "name": googleUser.displayName,
          "number": "",
          "province": "",
          "zip": "",
        });
      }
    });
  }
}
