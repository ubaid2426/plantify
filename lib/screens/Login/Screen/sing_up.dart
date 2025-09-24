import 'dart:convert';
// import 'dart:ffi';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:plant_app/screens/Login/Screen/login_page.dart';
import 'package:plant_app/screens/Login/components/clipper.dart';
import 'package:plant_app/screens/Login/components/colors.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool secure = true;
  GlobalKey<FormState> signup = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  // final phoneNumberController = PhoneNumberEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController conpassword = TextEditingController();
  bool isLoading = false;
  String message = '';
  String countryCode = '+92'; // Default country code
  String contactNumber = ''; // Contact number
  String combinedOutput = ''; // Combined string
  Future<void> _registerUser(
      String name,
      String email,
      String password,
      String combinedOutput) async {
    var url = Uri.parse(
        // 'https://sadqahzakaat.com/api/auth/users/'); // Replace with your IP
        'http://127.0.0.1:8000/api/auth/users/'); // Replace with your IP

    // Construct the payload
    Map<dynamic, dynamic> payload = {
      'email': email,
      'name': name,
      'contact_number': combinedOutput,
      'password': password,
      're_password': password, // Ensure this matches the API requirements
    };

    try {
      setState(() {
        isLoading = true; // Show loader
      });

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      setState(() {
        isLoading = false; // Hide loader
      });

      if (response.statusCode == 201) {
        // Registration successful
        setState(() {
          message =
              "User registered successfully! Check your email to activate your account.";
        });

        // Show an AlertDialog
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Success"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        // Handle errors
        var responseBody = jsonDecode(response.body);
        setState(() {
          message = responseBody['email']?.join(', ') ??
              responseBody['name']?.join(', ') ??
              responseBody['password']?.join(', ') ??
              "Registration failed!";
        });
        // print("Response Body: ${response.body}"); // Debug response
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        message = "Error occurred: $e";
      });
      // print("Error: $e"); // Debug error
    }
  }

  void _updateCombinedOutput() {
    print('Country Code: $countryCode');
    print('Contact Text: ${contact.text}');
    setState(() {
      contactNumber = contact.text;
      combinedOutput = '$countryCode$contactNumber';
    });
    print('Combined Output: $combinedOutput');
  }

  @override
  void dispose() {
    // phoneNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _updateCombinedOutput();
      // combinedOutput = code?.dialCode + contact.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    // print(combinedOutput);
    print('Country Code: $countryCode');
    print('Contact Text: ${contact.text}');
    print('Combined Output: $combinedOutput');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              // Background and ClipPaths
              ClipPath(
                clipper: MyClipper(),
                child: Container(
                  height: screenHeight * 0.30, // 40% of the screen height
                  width: double.infinity,
                  // ignore: deprecated_member_use
                  color: MyColors().maincolor.withOpacity(0.7),
                ),
              ),
              ClipPath(
                clipper: MyClipper(),
                child: Container(
                  height: screenHeight * 0.25, // 30% of the screen height
                  width: double.infinity,
                  color: MyColors().maincolor,
                ),
              ),
              SizedBox(
                height: screenHeight,
                width: screenWidth,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 100, // 7% from the top
                    left: screenWidth * 0.07, // 7% from the left
                  ),
                  child: Text(
                    'Welcome to \n Sadqah Zakaat',
                    style: TextStyle(
                      fontSize: screenHeight * 0.04, // 4% of the screen height
                      color: const Color.fromARGB(255, 4, 4, 4),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Signup Form positioned on top of the stack
              Positioned(
                top: 50,
                right: 0,
                child: _buildSignupForm(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignupForm(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Form(
        key: signup,
        child: Padding(
          padding:
              EdgeInsets.only(top: screenHeight * 0.20), // 25% from the top
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Colors.white,
            ),
            height: 900, // Full screen height
            // height: double.infinity,
            width: screenWidth, // Full screen width
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.07, // 7% horizontal padding
              ),
              child: SingleChildScrollView(
                child: SizedBox(
                  // color: Colors.red,
                  height: 1100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: screenHeight * 0.02), // 5% vertical space
                      Text(
                        "Create new account now",
                        style: TextStyle(
                          fontSize: screenHeight * 0.02, // 2% of screen height
                          color: MyColors().maincolor,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      // SizedBox(height: screenHeight * 0.01), // 2% vertical space
                      _buildTextField("Full Name", name),
                      _buildTextField("Email", email),
                      buildPhone(),
                      // buildPhone("Contact Number", phoneNumberController),
                      _buildTextField("Password", password, isPassword: true),
                      _buildTextField("Confirm Password", conpassword,
                          isPassword: true),
                      // buildDonorandNeedy(),
                      // SizedBox(height: screenHeight * 0.04), // 4% vertical space

                      // Signup Button
                      InkWell(
                        onTap: () {
                          if (signup.currentState!.validate()) {
                            if (password.text == conpassword.text) {
                              // Register user
                              _registerUser(
                                  name.text,
                                  email.text,
                                  password.text,
                                  combinedOutput.toString()
                                  // phoneNumberController.value.toString(),
                                  );
                            } else {
                              setState(() {
                                message = "Passwords do not match!";
                              });
                            }
                          }
                        },
                        child: Container(
                          height:
                              screenHeight * 0.07, // 7% of the screen height
                          width: screenWidth * 0.8, // 80% of the screen width
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: MyColors().maincolor,
                          ),
                          child: isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white))
                              : const Center(
                                  child: Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      decoration: TextDecoration.none,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(
                          height: screenHeight * 0.01), // 3% vertical space

                      // Error or Success Message
                      message.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                message,
                                style: TextStyle(
                                  color:
                                      message == "User registered successfully!"
                                          ? Colors.green
                                          : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : const SizedBox(),

                      Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(
                                fontSize:
                                    screenHeight * 0.02, // 2% of screen height
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                                height:
                                    screenHeight * 0.01), // 2% vertical space
                            InkWell(
                              onTap: () {
                                // Navigate to login
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                );
                              },
                              child: Text(
                                "Click here",
                                style: TextStyle(
                                  fontSize: screenHeight *
                                      0.02, // 2% of screen height
                                  color: MyColors().maincolor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ).animate().fade().slideY(
              begin: 1,
              duration: const Duration(milliseconds: 600),
            ),
      ),
    );
  }

  Widget buildPhone() {
    return SizedBox(
      height: 70,
      width: double.infinity,
      child: Row(
        children: [
          CountryCodePicker(
            onChanged: (code) {
              setState(() {
                countryCode = code.dialCode ?? '+92';
                _updateCombinedOutput(); // Update combined output
              });
            },
            initialSelection: 'PK',
            margin: const EdgeInsets.symmetric(horizontal: 6),
            comparator: (a, b) => b.name!.compareTo(a.name!),
            onInit: (code) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  countryCode =
                      code?.dialCode ?? '+92'; // Safely access `dialCode`
                  _updateCombinedOutput();
                });
                // });
              });
            },
          ),
          // Expanded(
          Flexible(child: _buildTextField("Contact Number", contact)),
          // ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16), // 16 pixels of vertical space
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? secure : false,
        decoration: InputDecoration(
          hintText: hint,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(secure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      secure = !secure;
                    });
                  },
                )
              : null,
          border: const UnderlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$hint cannot be empty';
          }
          return null;
        },
      ),
    );
  }


  Widget buildSwitch({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        Transform.scale(
          scale: 0.8, // Adjust the scale factor to make the switch smaller
          child: Switch(
            value: value,
            activeColor: const Color(0xFF7fc23a),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
