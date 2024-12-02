// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';
import 'general_preferences_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      try {
        // Create a new user with Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // Save user details to Firestore
        final appUser = AppUser(
          uid: userCredential.user!.uid,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phoneNumber,
          city: '', // Default city
          companion: '', // Default companion
          budget: '',
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(appUser.uid)
            .set(appUser.toJson());

        // Navigate to the GeneralPreferencesPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GeneralPreferencesPage(),
          ),
        );
      } catch (e) {
        // Handle Firebase Auth or Firestore errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Your Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'First Name',
                onSaved: (value) => firstName = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Enter your first name' : null,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Last Name',
                onSaved: (value) => lastName = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Enter your last name' : null,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Phone Number',
                onSaved: (value) => phoneNumber = value!,
                validator: (value) => value!.isEmpty || value.length < 10
                    ? 'Enter a valid phone number'
                    : null,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Email',
                onSaved: (value) => email = value!,
                validator: (value) => value!.isEmpty || !value.contains('@')
                    ? 'Enter a valid email'
                    : null,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Password',
                onSaved: (value) => password = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Enter a password' : null,
                obscureText: true,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Confirm Password',
                onSaved: (value) => confirmPassword = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Confirm your password' : null,
                obscureText: true,
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primary,
                    foregroundColor:
                        Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      onSaved: onSaved,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
    );
  }
}
