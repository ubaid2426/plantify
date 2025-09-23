import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ActivationScreen extends StatefulWidget {
  final String uid;
  final String token;

  const ActivationScreen({super.key, required this.uid, required this.token});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  String message = ''; // To hold activation message

  Future<void> _activateAccount(String uid, String token) async {
    var url = Uri.parse('http://127.0.0.1:8000/api/auth/users/activation/'); // Djoser activation URL

    // Construct the payload
    Map<String, String> payload = {
      'uid': uid,
      'token': token,
    };

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 204) {
        // Activation successful
        setState(() {
          message = "Account activated successfully! You can now log in.";
        });
        // Optionally navigate to the login page after a successful activation
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        // Handle activation errors
        var responseBody = jsonDecode(response.body);
        setState(() {
          message = responseBody['non_field_errors']?.join(', ') ?? "Activation failed!";
        });
      }
    } catch (e) {
      setState(() {
        message = "Error occurred: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activate Account')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Call the activation API
                _activateAccount(widget.uid, widget.token);
              },
              child: const Text('Activate Account'),
            ),
            const SizedBox(height: 20), // Add some spacing
            Text(
              message,
              style: TextStyle(
                color: message.contains("successfully") ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
