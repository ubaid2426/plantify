// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:zakat_app/components/navigation.dart'; // Assuming you have this component for navigation

// class ResetPasswordScreen extends StatefulWidget {
//   const ResetPasswordScreen({super.key});

//   @override
//   _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
// }

// class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
//   bool vis = true;
//   final _globalkey = GlobalKey<FormState>();
//   TextEditingController newPasswordController = TextEditingController();
//   TextEditingController confirmPasswordController = TextEditingController();
//   String errorText = ''; // Initialize errorText to an empty string
//   bool validate = false;
//   bool circular = false;
//   final storage = const FlutterSecureStorage(); // Secure Storage instance

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: FractionalOffset(0.0, 1.0),
//             end: FractionalOffset(0.0, 1.0),
//             stops: [0.0, 1.0],
//             tileMode: TileMode.repeated,
//             colors: [Colors.white, Colors.green], // Update colors if needed
//           ),
//         ),
//         child: Form(
//           key: _globalkey,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   "Reset Password",
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 2,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 newPasswordTextField(),
//                 const SizedBox(height: 15),
//                 confirmPasswordTextField(),
//                 const SizedBox(height: 20),
//                 InkWell(
//                   onTap: () async {
//                     if (_globalkey.currentState!.validate()) {
//                       setState(() {
//                         circular = true;
//                       });

//                       print("Form validation passed!");

//                       // Retrieve stored UUID and token
//                       String? uuid = await storage.read(key: 'reset_uid');
//                       String? token = await storage.read(key: 'reset_token');


//                       if (uuid != null && token != null) {
//                         print("UUID and Token found: $uuid, $token");
//                         await resetPassword(uuid, token);
//                       } else {
//                         setState(() {
//                           errorText = 'UUID or token not found';
//                           validate = true;
//                           circular = false;
//                         });
//                         print("UUID or token not found");
//                       }
//                     } else {
//                       print("Form validation failed.");
//                     }
//                   },
//                   child: Container(
//                     width: 150,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: const Color(0xff00A86B),
//                     ),
//                     child: Center(
//                       child: circular
//                           ? const CircularProgressIndicator()
//                           : const Text(
//                               "Update Password",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget newPasswordTextField() {
//     return Column(
//       children: [
//         const Text("New Password"),
//         TextFormField(
//           controller: newPasswordController,
//           obscureText: vis,
//           decoration: InputDecoration(
//             errorText: validate ? null : errorText,
//             suffixIcon: IconButton(
//               icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
//               onPressed: () {
//                 setState(() {
//                   vis = !vis;
//                 });
//               },
//             ),
//             focusedBorder: const UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.black,
//                 width: 2,
//               ),
//             ),
//           ),
//           validator: (value) {
//             if (value!.isEmpty) {
//               return 'Please enter a new password';
//             }
//             return null;
//           },
//         )
//       ],
//     );
//   }

//   Widget confirmPasswordTextField() {
//     return Column(
//       children: [
//         const Text("Confirm Password"),
//         TextFormField(
//           controller: confirmPasswordController,
//           obscureText: vis,
//           decoration: InputDecoration(
//             errorText: validate ? null : errorText,
//             suffixIcon: IconButton(
//               icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
//               onPressed: () {
//                 setState(() {
//                   vis = !vis;
//                 });
//               },
//             ),
//             focusedBorder: const UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.black,
//                 width: 2,
//               ),
//             ),
//           ),
//           validator: (value) {
//             if (value!.isEmpty) {
//               return 'Please confirm your password';
//             }
//             if (value != newPasswordController.text) {
//               return 'Passwords do not match';
//             }
//             return null;
//           },
//         )
//       ],
//     );
//   }

// Future<void> resetPassword(String uuid, String token) async {
//   String url = 'http://127.0.0.1:8000/api/auth/users/reset_password_confirm/';

//   Map<String, String> data = {
//     'uid': uuid,
//     'token': token,
//     'new_password': newPasswordController.text,
//     're_new_password': confirmPasswordController.text,
//   };

//   try {
//     var response = await http.post(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(data),
//     );

//     print("Response Status Code: ${response.statusCode}");
//     print("Response Body: ${response.body}");

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const Navigation()),
//       );
//     } else {
//       setState(() {
//         errorText = 'Failed to reset password: ${response.body}';
//         validate = true;
//         circular = false;
//       });
//     }
//   } catch (e) {
//     setState(() {
//       errorText = 'Error: $e';
//       validate = true;
//       circular = false;
//     });
//     print("Error: $e");
//   }
// }

// }
