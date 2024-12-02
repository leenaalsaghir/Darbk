import 'package:flutter/material.dart';
import 'login_signup_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3), () {}); // Display for 3 seconds
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginSignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/LOGOTEXT.png', // Path to  logo image
              width: 100, // Adjust the width as needed
              height: 100, // Adjust the height as needed
            ),

            const SizedBox(height: 40),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onPrimary),
            ), // Loading indicator
          ],
        ),
      ),
    );
  }
}
