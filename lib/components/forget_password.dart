import 'package:flutter/material.dart';
import 'package:myappflutter/components/my_textfield.dart';
import 'package:http/http.dart' as http;

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});

  final usernameController = TextEditingController();
  final emailController = TextEditingController();

  void onPressed() async {
    String username = this.usernameController.text;
    String email = this.emailController.text;
    Uri url = Uri.parse("http://localhost:8080/forget-password");
    Map<String, String> headers = {"Content-type": "application/json"};

    String json =
        '{"message": "Hello from Flutter","username": "$username","email": "$email"}';
    print(json);
    http.Response response = await http.post(url, headers: headers, body: json);
    if (response.statusCode == 200) {
      print('User exist :)------');
    } else {
      print('Failed to send data. Status code: ${response.statusCode}');
    }
  }

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
                'No worriess we got you :)',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
              ),
              SizedBox(
                height: 25,
              ),
              MyTextField(
                controller: usernameController,
                hintText: 'Please Enter Username',
                obsecureText: false,
              ),
              SizedBox(
                height: 30,
              ),
              MyTextField(
                controller: emailController,
                hintText: 'Please Enter Email Address',
                obsecureText: false,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.symmetric(horizontal: 120),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: onPressed,
                  child: Center(
                    child: Text(
                      "Verify",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
