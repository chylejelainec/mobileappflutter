
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../student_page.dart';
import 'account_settings_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF1976D2);
    const darkText = Color(0xFF172B4D);
    const secondaryText = Color(0xFF64748B);

    final user = FirebaseAuth.instance.currentUser!;

    // Private student records for the signed-in user.
    final students = FirebaseFirestore.instance
        .collection('students')
        .where('ownerUid', isEqualTo: user.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: 'Account Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AccountSettingsPage(),
                ),
              );
            },
            icon: const Icon(Icons.settings_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome
                  const Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: darkText,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Manage your student records in one place.',
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryText,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Signed-in Account
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFE6EDF5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5F1FF),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.account_circle_outlined,
                            size: 29,
                            color: blue,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Signed-in Account',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: secondaryText,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                user.email ?? 'Unknown User',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: darkText,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Total Students
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: students.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text(
                          'Unable to load student count.',
                        );
                      }

                      if (!snapshot.hasData) {
                        return const LinearProgressIndicator();
                      }

                      final count = snapshot.data!.docs.length;

                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xFFE6EDF5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5F1FF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.groups_rounded,
                                color: blue,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Students',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: secondaryText,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Registered Records',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: darkText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '$count',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: blue,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // Student Preview
                  const Text(
                    'Student Preview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: darkText,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Your registered students',
                    style: TextStyle(
                      fontSize: 13,
                      color: secondaryText,
                    ),
                  ),

                  const SizedBox(height: 14),

                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: students.limit(5).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text(
                          'Unable to load student records.',
                        );
                      }

                      if (!snapshot.hasData) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final docs = snapshot.data!.docs;

                      if (docs.isEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFE6EDF5),
                            ),
                          ),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.people_outline_rounded,
                                size: 38,
                                color: secondaryText,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'No student records yet.',
                                style: TextStyle(
                                  color: secondaryText,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: docs.map((doc) {
                          final data = doc.data();

                          final name =
                              data['name']?.toString() ?? 'Unnamed Student';

                          final course =
                              data['course']?.toString() ?? 'No course';

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color(0xFFE6EDF5),
                              ),
                            ),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Color(0xFFE5F1FF),
                                  child: Icon(
                                    Icons.person_outline_rounded,
                                    color: blue,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: darkText,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        course,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: secondaryText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  // Quick Access - KEEP THIS
                  const Text(
                    'QUICK ACCESS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: secondaryText,
                    ),
                  ),

                  const SizedBox(height: 14),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StudentPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 17,
                        ),
                        backgroundColor: blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_alt_outlined),
                          SizedBox(width: 10),
                          Text(
                            'Manage Students',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
