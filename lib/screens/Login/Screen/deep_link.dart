// import 'package:flutter/material.dart';
// // import 'package:uni_links/uni_links.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:uni_links3/uni_links.dart';

// class DeepLinkHandler extends StatefulWidget {
//   const DeepLinkHandler({super.key});

//   @override
//   _DeepLinkHandlerState createState() => _DeepLinkHandlerState();
// }

// class _DeepLinkHandlerState extends State<DeepLinkHandler> {
//   final FlutterSecureStorage _storage = FlutterSecureStorage();

//   @override
//   void initState() {
//     super.initState();
//     _initDeepLinkListener();
//   }

//   Future<void> _initDeepLinkListener() async {
//     linkStream.listen((String? link) {
//       if (link != null) {
//         _handleDeepLink(link);
//       }
//     });
//   }

//   Future<void> _handleDeepLink(String link) async {
//     // Example link: your_scheme://your_domain/api/auth/users/reset_password_confirm/uuid/token/
//     final uri = Uri.parse(link);
    
//     // Extract the UUID and Token from the path segments
//     final segments = uri.pathSegments;
//     if (segments.length >= 5) {
//       final uuid = segments[3];  // Assuming the UUID is in the 4th segment
//       final token = segments[4];  // Assuming the Token is in the 5th segment

//       // Store UUID and Token in Secure Storage
//       await _storage.write(key: 'uuid', value: uuid);
//       await _storage.write(key: 'token', value: token);

//       print('Stored UUID: $uuid');
//       print('Stored Token: $token');

//       // Navigate to your reset password screen if needed
//       // Navigator.pushNamed(context, '/resetPassword');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Deep Link Handler')),
//       body: Center(child: Text('Listening for deep links...')),
//     );
//   }
// }
