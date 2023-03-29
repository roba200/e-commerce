import 'package:e_commerce_app/my_textfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();

  void sendResetLink() async {
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
      await FirebaseAuth.instance
          .sendPasswordResetEmail(
        email: emailcontroller.text,
      )
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("Password reset link sent to ${emailcontroller.text}")));
      });
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

  void linkSendMessage() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Enter your email to get password reset link",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              MyTextField(
                controller: emailcontroller,
                hintText: "Email",
                obscureText: false,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? "Enter a valid Email"
                        : null,
              ),
              SizedBox(
                height: 20,
              ),
              CupertinoButton(
                  color: Colors.deepPurple,
                  child: Text("Get Reset Link"),
                  onPressed: () {
                    final form = formKey.currentState!;
                    if (form.validate()) {
                      sendResetLink();
                    }
                  })
            ],
          ),
        ),
      )),
    );
  }
}
