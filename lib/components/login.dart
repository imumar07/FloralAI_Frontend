import 'package:flutter/material.dart';
import 'package:myappflutter/components/forget_password.dart';
import 'package:myappflutter/components/my_textfield.dart';
import 'package:myappflutter/components/register_page.dart';
import 'package:myappflutter/components/sign_in_button.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Image.asset('assets/FloralAI.png', height: 130, width: 130),
              SizedBox(
                height: 50,
              ),
              Text(
                'Welcome Please Login To Continue',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
              ),
              SizedBox(
                height: 25,
              ),
              MyTextField(
                controller: usernameController,
                hintText: 'Enter Username',
                obsecureText: false,
              ),
              SizedBox(
                height: 25,
              ),
              MyTextField(
                controller: passwordController,
                hintText: 'Enter Password',
                obsecureText: true,
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to ForgotPassword screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgetPassword()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SignInButton(
                text: "Sign In",
                usernameController: usernameController,
                passwordController: passwordController,
                context: context,
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to ForgotPassword screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterApp()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        'Not Registerted Yet? Register Now',
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
