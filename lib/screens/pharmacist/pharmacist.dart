import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PharamcistPage extends StatefulWidget {
  const PharamcistPage({super.key});

  @override
  State<PharamcistPage> createState() => _PharamcistPageState();
}

class _PharamcistPageState extends State<PharamcistPage> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Padding(
      padding:const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment:MainAxisAlignment.center,
        children :[
          const Text(
            'signed in as',
            style:TextStyle(fontSize: 16),
          ),
          const SizedBox(height:8),
          Text(
            user.email!,
            style: const TextStyle(fontSize:20,fontWeight:FontWeight.bold),
          ),
          const SizedBox(height:40),
          ElevatedButton.icon(
            style:ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            icon: const Icon(Icons.arrow_back,size: 32),
            label:const Text(
              'sign out',
              style:TextStyle(fontSize:24),
            ),
            onPressed:() => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
    )
    );
  }
}