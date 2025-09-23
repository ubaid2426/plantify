
import 'package:flutter/material.dart';
import 'package:plant_app/components/navigation.dart';
import 'package:plant_app/constants.dart';
import 'package:video_player/video_player.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Load your video from assets
    _controller = VideoPlayerController.asset(
        'assets/videos/payment/payment.mov',
      )
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(false);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void goToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Navigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment Successful"), backgroundColor: kPrimaryColor,),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_controller.value.isInitialized)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          else
            CircularProgressIndicator(),

          const SizedBox(height: 24),
          const Text(
            'Payment Successful!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Thank you for your payment.',
            style: TextStyle(fontSize: 16),
          ),
          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: goToHome,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                minimumSize: Size(double.infinity, 50),
              ),
              child: const Text("Go to Home Page", style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
}
