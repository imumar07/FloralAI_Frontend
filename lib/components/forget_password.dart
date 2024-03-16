import 'package:flutter/material.dart';
import 'package:myappflutter/components/login.dart';
import 'package:myappflutter/components/my_textfield.dart';
import 'package:http/http.dart' as http;
import 'package:myappflutter/components/reset_password.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({Key? key}) : super(key: key);

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  void onPressed(BuildContext context) async {
    String username = usernameController.text;
    String email = emailController.text;
    Uri url = Uri.parse("http://localhost:8080/forget-password");
    Map<String, String> headers = {"Content-type": "application/json"};

    String json =
        '{"message": "Hello from Flutter","username": "$username","email": "$email"}';
    print(json);
    http.Response response = await http.post(url, headers: headers, body: json);
    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade300,
            title: Text('Verification Successful'),
            content: Text('You may now reset your password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPassword(
                        username: usernameController.text,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Proceed',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        },
      );
    } else {
      print('Failed to send data. Status code: ${response.statusCode}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Verification Failed'),
            content:
                Text('You are not with us. Please check your credentials.'),
            actions: [
              TextButton(
                 onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(
                      ),
                    ),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
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
              SizedBox(height: 50),
              Image.asset('assets/FloralAI.png', height: 130, width: 130),
              SizedBox(height: 50),
              Text(
                'No worries, we got you :)',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
              ),
              SizedBox(height: 25),
              MyTextField(
                controller: usernameController,
                hintText: 'Please Enter Username',
                obsecureText: false,
              ),
              SizedBox(height: 30),
              MyTextField(
                controller: emailController,
                hintText: 'Please Enter Email Address',
                obsecureText: false,
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.symmetric(horizontal: 120),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: () => onPressed(context),
                  child: Center(
                    child: Text(
                      "Verify",
                      style: TextStyle(
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
