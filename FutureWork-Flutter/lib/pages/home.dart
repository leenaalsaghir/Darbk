import 'package:flutter/material.dart';
import 'profile.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: 0,
            onDestinationSelected: (int index) {
              if (index == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
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
            child: Center(
              child: Text('Welcome to the Home Page'),
            ),
          ),
        ],
      ),
    );
  }
}
