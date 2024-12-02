import 'package:flutter/material.dart';
import 'home.dart'; // Import HomePage
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GeneralPreferencesPage extends StatefulWidget {
  const GeneralPreferencesPage({super.key});

  @override
  _GeneralPreferencesPageState createState() => _GeneralPreferencesPageState();
}

class _GeneralPreferencesPageState extends State<GeneralPreferencesPage> {
  // Preferences
  String? selectedCity;
  String? selectedCompany;
  String? selectedBudget;
  int currentQuestionIndex = 0;

  void nextQuestion() {
    setState(() {
      currentQuestionIndex++;
    });

    // Save selected city to Firestore
    if (currentQuestionIndex == 1 && selectedCity != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'city': selectedCity, // Save the selected city
      });
    }
  }

  void savePreferencesAndNavigate() {
    // Save selected companion and budget to Firestore
    if (selectedCompany != null && selectedBudget != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'companion': selectedCompany, // Save the selected companion
        'budget': selectedBudget, // Save the selected budget
      });
    }

    // Navigate to HomePage and clear navigation stack
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) =>  HomePage(),
      ),
      (route) => false, // Remove all previous routes
    );
  }

  Widget buildQuestion(String question) {
    return Text(
      question,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget buildRadioList(
      List<String> options, String? selectedValue, ValueChanged<String?> onChange) {
    return Column(
      children: options.map((option) {
        return RadioListTile<String>(
          title: Text(
            option,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          value: option,
          groupValue: selectedValue,
          activeColor: Theme.of(context).colorScheme.secondary,
          onChanged: onChange,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('General Preferences'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (currentQuestionIndex == 0) ...[
              buildQuestion('Which city do you want to explore?'),
              const SizedBox(height: 10),
              buildRadioList(['Riyadh', 'Jeddah', 'Aseer'], selectedCity,
                  (value) {
                setState(() {
                  selectedCity = value;
                });
              }),
              const SizedBox(height: 40),
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedCity != null) {
                        nextQuestion();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: const Text('Next'),
                  ),
                ),
              ),
            ],
            if (currentQuestionIndex == 1) ...[
              buildQuestion('Who do you usually go out with?'),
              const SizedBox(height: 10),
              buildRadioList(['Friends', 'Family', 'Alone'], selectedCompany,
                  (value) {
                setState(() {
                  selectedCompany = value;
                });
              }),
              const SizedBox(height: 40),
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedCompany != null) {
                        nextQuestion();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor:
                          Theme.of(context).colorScheme.onSecondary,
                    ),
                    child: const Text('Next'),
                  ),
                ),
              ),
            ],
            if (currentQuestionIndex == 2) ...[
              buildQuestion('What is your budget preference?'),
              const SizedBox(height: 10),
              buildRadioList(['Luxury', 'Mid-range', 'Economy'], selectedBudget,
                  (value) {
                setState(() {
                  selectedBudget = value;
                });
              }),
              const SizedBox(height: 40),
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedBudget != null) {
                        savePreferencesAndNavigate();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor:
                          Theme.of(context).colorScheme.onSecondary,
                    ),
                    child: const Text('Continue'),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
