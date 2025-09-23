import 'package:flutter/material.dart';

class CallUs extends StatelessWidget {
  const CallUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF33A248),
                Color(0xFFB2EA50),
              ],
              begin: Alignment.topRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'For any inquiries or support, please feel free to contact us using the options below:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ContactOption(
              icon: Icons.email,
              title: 'Email',
              subtitle: 'contact@sadaqa.org.au',
              iconBackgroundColor: Color(0xFF7fc23a),
            ),
            SizedBox(height: 20),
            ContactOption(
              icon: Icons.phone,
              title: 'Phone',
              subtitle: '1300 234 673',
              iconBackgroundColor: Color(0xFF7fc23a),
            ),
            SizedBox(height: 20),
            ContactOption(
              icon: Icons.person,
              title: 'Contact Form',
              subtitle: '',
              iconBackgroundColor: Color(0xFF7fc23a),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconBackgroundColor;

  const ContactOption({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

void main() => runApp(const MaterialApp(home: CallUs()));
