import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  Future<void> saveTestData() async {
    await FirebaseFirestore.instance.collection('students').add({
      'name': 'Chyle Jelaine Cenzon',
      'course': 'BS Information Technology',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Page')),
      body: Center(
        child: Column(
          children: [
            const Text('Student Page!', style: TextStyle(fontSize: 24)),
            ElevatedButton(
              onPressed: saveTestData,
              child: const Text('Save data'),
            ),
          ],
        ),
      ),
    );
  }}