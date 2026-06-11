import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:darbk2/pages/splash_screen.dart';


void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions( apiKey: "#####",
  authDomain: "test-5999a.firebaseapp.com",
  databaseURL: "https://test-5999a-default-rtdb.firebaseio.com",
  projectId: "test-5999a",
  storageBucket: "test-5999a.firebasestorage.app",
  messagingSenderId: "####",
  appId: "###")); 
  runApp(const DarbkApp());
}

class DarbkApp extends StatelessWidget {
  const DarbkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Darbk',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(0, 109, 72, 168)),
        useMaterial3: true,
      ),
       home: const SplashScreen(),
    );
  }
}
