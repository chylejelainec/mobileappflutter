
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateStudentPage extends StatefulWidget {
  final String? documentId;
  final Map<String, dynamic>? initialData;

  const CreateStudentPage({
    super.key,
    this.documentId,
    this.initialData,
  });

  @override
  State<CreateStudentPage> createState() => _CreateStudentPageState();
}

class _CreateStudentPageState extends State<CreateStudentPage> {
  final nameController = TextEditingController();
  final courseController = TextEditingController();
  final studentNumberController = TextEditingController();

  bool loading = false;

  bool get isEditing => widget.documentId != null;

  @override
  void initState() {
    super.initState();

    final data = widget.initialData ?? {};

    nameController.text = data['name']?.toString() ?? '';
    courseController.text = data['course']?.toString() ?? '';
    studentNumberController.text =
        data['studentNumber']?.toString() ?? '';
  }

  Future<void> saveStudent() async {
    final name = nameController.text.trim();
    final course = courseController.text.trim();
    final studentNumber = studentNumberController.text.trim();

    if (name.isEmpty || course.isEmpty || studentNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill in all fields.'),
        backgroundColor: Colors.red),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login first.'),
        backgroundColor: Colors.red,),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final collection =
          FirebaseFirestore.instance.collection('students');

      final data = <String, dynamic>{
        'name': name,
        'course': course,
        'studentNumber': studentNumber,
        'ownerUid': user.uid,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (isEditing) {
        await collection.doc(widget.documentId).update(data);
      } else {
        await collection.add({
          ...data,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'Student updated successfully!'
                : 'Student saved successfully!',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e'),
        backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    courseController.dispose();
    studentNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF1976D2);
    const darkText = Color(0xFF172B4D);
    const secondaryText = Color(0xFF64748B);
    const courses = <String>[
      'BS Information Technology',
      'BS Computer Science',
      'BS Business Administration',
      'BS Hospitality Management',
      'BS Tourism Management',
      'BS Criminology',
    ];

    // Keep an existing course available when editing older student records.
    final courseOptions = [...courses];
    final savedCourse = courseController.text.trim();
    if (savedCourse.isNotEmpty && !courseOptions.contains(savedCourse)) {
      courseOptions.insert(0, savedCourse);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Student' : 'Add Student'),
        leading: IconButton(
          tooltip: 'Go back',
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
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
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5F1FF),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      isEditing
                          ? Icons.edit_rounded
                          : Icons.person_add_alt_1_rounded,
                      color: blue,
                      size: 30,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Text(
                    isEditing ? 'Update student' : 'New student',
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                      color: darkText,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    isEditing
                        ? 'Update the student information below.'
                        : 'Enter the student details below to create a record.',
                    style: const TextStyle(
                      color: secondaryText,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFE6EDF5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Student Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: darkText,
                          ),
                        ),

                        const SizedBox(height: 22),

                        const Text(
                          'Full Name',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: darkText,
                          ),
                        ),

                        const SizedBox(height: 9),

                        TextField(
                          controller: nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            hintText: 'Enter full name',
                            prefixIcon:
                                Icon(Icons.person_outline_rounded),
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Student Number',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: darkText,
                          ),
                        ),

                        const SizedBox(height: 9),

                        TextField(
                          controller: studentNumberController,
                          decoration: const InputDecoration(
                            hintText: 'e.g., 2023-00123',
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Course',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: darkText,
                          ),
                        ),

                        const SizedBox(height: 9),

                        DropdownButtonFormField<String>(
                          initialValue: courseController.text.isEmpty
                              ? null
                              : courseController.text,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            hintText: 'Select course',
                            prefixIcon: Icon(Icons.school_outlined),
                          ),
                          items: courseOptions.map((course) {
                            return DropdownMenuItem<String>(
                              value: course,
                              child: Text(course),
                            );
                          }).toList(),
                          onChanged: (value) {
                            courseController.text = value ?? '';
                          },
                        ),

                        const SizedBox(height: 28),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: loading ? null : saveStudent,
                            child: loading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.save_outlined,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 9),
                                      Text(
                                        isEditing
                                            ? 'Update Student'
                                            : 'Save Student',
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Center(
                    child: Text(
                      'Please ensure all information is correct.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
