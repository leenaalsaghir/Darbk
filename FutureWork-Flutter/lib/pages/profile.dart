import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'settings.dart';
import 'user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Controllers for editable fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Dropdown values
  String _selectedCity = 'Riyadh';
  String _selectedCompanion = 'Alone';
  String _selectedBudget = 'Economy';

  // Stream to fetch user data
  Stream<AppUser> getUser() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) => AppUser.fromJson(snapshot.data() ?? {}));
  }

  // Update user data in Firestore
  Future<void> updateUser(AppUser user) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(user.toJson());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: 1,
            onDestinationSelected: (int index) {
              if (index == 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              }
            },
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Profile'),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<AppUser>(
              stream: getUser(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final user = snapshot.data!;

                if (_nameController.text.isEmpty) {
                  _nameController.text =
                      "${user.firstName} ${user.lastName}".trim();
                  _emailController.text = user.email;
                  _phoneController.text = user.phone;
                  _selectedCity = user.city.isNotEmpty ? user.city : 'Riyadh';
                  _selectedCompanion =
                      user.companion.isNotEmpty ? user.companion : 'Alone';
                  _selectedBudget =
                      user.budget.isNotEmpty ? user.budget : 'Economy';
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _emailController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Preferences',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedCity,
                        decoration: const InputDecoration(
                          labelText: 'City',
                          border: OutlineInputBorder(),
                        ),
                        items: ['Riyadh', 'Jeddah', 'Aseer']
                            .map(
                              (city) => DropdownMenuItem(
                                value: city,
                                child: Text(city),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCity = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedCompanion,
                        decoration: const InputDecoration(
                          labelText: 'Companion',
                          border: OutlineInputBorder(),
                        ),
                        items: ['Alone', 'Family', 'Friends']
                            .map(
                              (companion) => DropdownMenuItem(
                                value: companion,
                                child: Text(companion),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCompanion = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedBudget,
                        decoration: const InputDecoration(
                          labelText: 'Budget',
                          border: OutlineInputBorder(),
                        ),
                        items: ['Luxury', 'Mid-range', 'Economy']
                            .map(
                              (budget) => DropdownMenuItem(
                                value: budget,
                                child: Text(budget),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedBudget = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                final updatedUser = AppUser(
                                  uid: user.uid,
                                  firstName:
                                      _nameController.text.split(' ').first,
                                  lastName:
                                      _nameController.text.split(' ').last,
                                  email: _emailController.text,
                                  phone: _phoneController.text,
                                  city: _selectedCity,
                                  companion: _selectedCompanion,
                                  budget: _selectedBudget,
                                );
                                updateUser(updatedUser);
                              },
                              child: const Text('Save Changes'),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SettingsPage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                              ),
                              child: const Text('Go to Settings'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
