import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myappflutter/components/image_send.dart';

class SignInButton extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final String text;
  final BuildContext context; // Add context here
  const SignInButton(
      {Key? key,
      required this.text,
      required this.usernameController,
      required this.passwordController,
      required this.context}) // Pass context to the constructor
      : super(key: key);

  void onPressed() async {
    String username = this.usernameController.text;
    String password = this.passwordController.text;
    Uri url = Uri.parse("http://localhost:8080/send-data");
    Map<String, String> headers = {"Content-type": "application/json"};

    String json =
        '{"message": "Hello from Flutter","username": "$username","password": "$password"}';
    http.Response response = await http.post(url, headers: headers, body: json);
    if (response.statusCode == 200) {
      print('Data sent successfully');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ImageUploadWidget()), // Replace AnotherPage() with the page you want to navigate to
      );
    } else {
      print('Failed to send data. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
