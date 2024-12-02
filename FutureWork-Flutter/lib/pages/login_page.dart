// ignore_for_file: unused_catch_clause

import 'package:flutter/material.dart';
import 'home.dart'; // Import the HomePage
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  TextEditingController _resetPasswordEmailController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true; // Show loading spinner while signing in
      });

      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);

        if (!mounted) return; // Check if the widget is still mounted
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false, // Remove all previous routes
        );
      } on FirebaseAuthException catch (e) {
        if (!mounted) return; // Prevent further context use if widget is unmounted
        String errorMessage = 'Invalid email or password.'; // Use generic message

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false; // Hide loading spinner
          });
        }
      }
    }
  }

  Future<void> _sendPasswordResetEmail() async {
    String email = _resetPasswordEmailController.text;

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent. Check your inbox.'),
        ),
      );
      _resetPasswordEmailController.clear(); // Clear the email field
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.message}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value!,
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Reset Password'),
                        content: TextField(
                          controller: _resetPasswordEmailController,
                          decoration: InputDecoration(
                            labelText: 'Enter your email address',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: _sendPasswordResetEmail,
                            child: const Text('Send'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    'Forgot your password? Reset it here',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
