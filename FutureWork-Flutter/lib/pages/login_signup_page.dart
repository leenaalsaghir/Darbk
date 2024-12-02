import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'login_page.dart';

class LoginSignUpPage extends StatefulWidget {
  const LoginSignUpPage({super.key});

  @override
  _LoginSignUpPageState createState() => _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<LoginSignUpPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: FadeTransition(
        opacity: _fadeInAnimation,
        child: Center(
          child: SingleChildScrollView( // Ensures scrolling on smaller screens
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Exploring.png',
                  width: 420,
                  height: 420,
                ),
                const SizedBox(height: 10),
                Text(
                  'Welcome to Darbk!',
                  style: TextStyle(
                    fontSize: 42,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  'Discover amazing places and things to do!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  icon: const Icon(Icons.person_add, size: 18),
                  label: const Text('Sign Up'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.login, size: 18),
                  label: const Text('Login'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
