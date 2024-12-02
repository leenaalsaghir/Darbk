import 'package:flutter/material.dart';
import 'login_signup_page.dart'; // Import the login signup page
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    // Perform logout using FirebaseAuth
    await FirebaseAuth.instance.signOut();

    // Navigate back to the login signup page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginSignUpPage()),
      (route) => false, // Remove all routes from the stack
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'General Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              subtitle: const Text('Manage notification settings'),
              onTap: () {
                // Handle navigation to notification settings
                showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                    title: Text('Notification Settings'),
                    content: Text('Manage notification settings here.'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Privacy'),
              subtitle: const Text('Manage privacy options'),
              onTap: () {
                // Handle navigation to privacy settings
                showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                    title: Text('Privacy Settings'),
                    content: Text('Manage privacy options here.'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              subtitle: const Text('Choose your preferred language'),
              onTap: () {
                // Handle language settings
                showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                    title: Text('Language Settings'),
                    content: Text('Choose your preferred language here.'),
                  ),
                );
              },
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => _logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}