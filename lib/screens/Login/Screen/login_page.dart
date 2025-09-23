import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plant_app/components/navigation.dart';
import 'package:plant_app/screens/Login/Screen/sing_up.dart';
import 'package:plant_app/screens/Login/auth/widgets/email_field.dart';
import 'package:plant_app/screens/Login/auth/widgets/password_field.dart';
import 'package:plant_app/screens/Login/components/clipper.dart';
import 'package:plant_app/screens/Login/components/colors.dart';
import 'package:plant_app/screens/Login/components/const.dart';

const storage = FlutterSecureStorage();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool secure = true;
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  Future<void> _fetchUserDetails(String token) async {
    setState(() {
      isLoading = true;
    });

    try {
      // var url = Uri.parse('https://sadqahzakaat.com/api/auth/users/me/');
      var url = Uri.parse('http://127.0.0.1:8000/api/auth/users/me/');
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'JWT $token',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String email = data['email'] ?? 'N/A';

        String username = data['name'] ?? 'N/A';
        String userid = data['id'].toString();
        setState(() {
          isLoading = false;
        });

        // Store email in secure storage
        await storage.write(key: 'user_name', value: username);
        await storage.write(key: 'user_id', value: userid);
        await storage.write(key: 'email', value: email);
      } else {
        throw Exception('Failed to fetch user details');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      // Handle error (e.g., show a message to the user)
      // print('Error fetching user details: $error');
    }
  }

  Future<void> login(String email, String password) async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    var url = Uri.parse('https://sadqahzakaat.com/api/auth/jwt/create/');
    Map<String, String> body = {
      'email': email,
      'password': password,
    };

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String accessToken = data['access'];
        await storage.write(key: 'access_token', value: accessToken);
        await storage.write(key: 'email', value: email);
        _fetchUserDetails(accessToken);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You are successfully logged in!'),
            backgroundColor: Colors.green,
          ),
        );

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Navigation()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed. Please check your credentials.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                width: width,
                height: height,
                child: Stack(
                  children: [
                    ClipPath(
                      clipper: MyClipper(),
                      child: Container(
                        // height: 300,
                        height: MediaQuery.of(context).size.height * 0.30,
                        width: width,
                        // ignore: deprecated_member_use
                        color: primaryColor.withOpacity(0.3),
                      ),
                    ),
                    ClipPath(
                      clipper: MyClipper(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width - 50,
                        color: primaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 20,
                        left: 20,
                        top: 100,
                        bottom: 50,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const Text(
                                "Sign In",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Enter your email to continue",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black26,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Form(
                                key: loginKey,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.05),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      EmailField(email: emailController),
                                      PasswordField(
                                          password: passwordController),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ForgotPasswordPage()),
                                            );
                                          },
                                          child: Text(
                                            'Forgot Password?',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: MyColors().maincolor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      InkWell(
                                        onTap: () {
                                          if (loginKey.currentState!
                                              .validate()) {
                                            login(emailController.text,
                                                passwordController.text);
                                          }
                                        },
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: MyColors().maincolor,
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'SIGN IN',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Signup()),
                                          );
                                        },
                                        child: Text(
                                          "Don't have an account? Click here",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: MyColors().maincolor,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Navigation()),
                                  );
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: MyColors().maincolor,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Go TO Home Page',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  String message = '';

  Future<void> sendResetPasswordEmail(
      String email, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        message = 'Password reset email has been sent.';
      });
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Email Sent'),
            content: const Text(
                'A password reset link has been sent to your email. Please check your inbox.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                     Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                  // Navigator.of(context).pop(); // Close the dialog
                  // Navigator.of(context).pop(); // Go back to login screen
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    });

    var url = Uri.parse('https://sadqahzakaat.com/api/auth/users/reset_password/');
    Map<String, String> body = {
      'email': email,
    };

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 204) {
        var responseBody = json.decode(response.body);
        String uid = responseBody['uid']; // Replace with actual field
        String token = responseBody['token']; // Replace with actual field
        await storage.write(key: 'reset_uid', value: uid);
        await storage.write(key: 'reset_token', value: token);

        setState(() {
          message = 'Password reset email sent!';
        });
      } else {
        setState(() {
          message = 'Failed to send email. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Enter your email to reset password',
              style: TextStyle(fontSize: 18),
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      sendResetPasswordEmail(emailController.text, context);
                    },
                    child: const Text('Send Reset Email'),
                  ),
            const SizedBox(height: 20),
            if (message.isNotEmpty)
              Text(
                message,
                style: const TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}
