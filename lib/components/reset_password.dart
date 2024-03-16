import 'package:flutter/material.dart';
import 'package:myappflutter/components/login.dart';
import 'package:myappflutter/components/my_textfield.dart';
import 'package:http/http.dart' as http;

class ResetPassword extends StatelessWidget {
  final String username;
  ResetPassword({super.key, required this.username});

  final passwordController = TextEditingController();
  final confrimPasswordController = TextEditingController();

  void onPressed(BuildContext context) async {
    String password = passwordController.text;
    String passwordConfrim = confrimPasswordController.text;
    if (password != passwordConfrim) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey.shade300,
              title: Text('Password and Confrim Password should be same'),
              content: Text('Please enter same password in both fields.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'ok',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            );
          });
    } else {
      Uri url = Uri.parse("http://localhost:8080/reset-password");
      Map<String, String> headers = {"Content-type": "application/json"};

      String json =
          '{"message": "Hello from Flutter","username": "$username","password": "$password"}';
      print(json);
      http.Response response =
          await http.post(url, headers: headers, body: json);
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey.shade300,
              title: Text('Verification Successful'),
              content: Text('Password reset successfully. You may now login.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
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
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
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
                'You are one step away to connect with us :)',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
              ),
              SizedBox(height: 25),
              MyTextField(
                controller: passwordController,
                hintText: 'Please Enter Password',
                obsecureText: true,
              ),
              SizedBox(height: 30),
              MyTextField(
                controller: confrimPasswordController,
                hintText: 'Please Re Enter Password',
                obsecureText: true,
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
