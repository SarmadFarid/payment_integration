import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:payment_integration/student-Management/std_controller.dart';
import 'package:payment_integration/student-Management/std_model.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final StudentController studentController = StudentController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController rollController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';

  @override
  void dispose() {
    nameController.dispose();
    rollController.dispose();
    semesterController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _showAddStudentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Student'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Student Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: rollController,
                  decoration: const InputDecoration(
                    labelText: 'Roll Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: semesterController,
                  decoration: const InputDecoration(
                    labelText: 'Semester',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty ||
                    rollController.text.trim().isEmpty) {
                  return;
                }

                setState(() {
                  studentController.add(
                    StudentModel(
                      name: nameController.text.trim(),
                      rollNom: rollController.text.trim(),
                      smester: semesterController.text.trim(),
                    ),
                  );

                  log(
                    'name : ${nameController.text} roll : ${rollController.text} smester ${semesterController.text}',
                  );
                });

                nameController.clear();
                rollController.clear();
                semesterController.clear();

                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(StudentModel student, int index) {
    // Purani values ko controller ke andar shuru mein hi pass kar dein
    final editNameController = TextEditingController(text: student.name);
    final editRollController = TextEditingController(text: student.rollNom);
    final editSmesterController = TextEditingController(text: student.smester);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Student"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: editNameController,
                  decoration: const InputDecoration(
                    labelText: "Student Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: editRollController,
                  decoration: const InputDecoration(
                    labelText: "Roll Number",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: editSmesterController,
                  decoration: const InputDecoration(
                    labelText: "Semester",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  studentController.edit(
                    StudentModel(
                      name: editNameController.text.trim(),
                      rollNom: editRollController.text.trim(),
                      smester: editSmesterController.text.trim(),
                    ),
                    index: index,
                  );
                });

                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter students by name or roll number based on searchQuery
    final filteredStudents = searchQuery.isEmpty
        ? studentController.students
        : studentController.searchStudent(query: searchQuery.toLowerCase());

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Student Management System",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Add Student',
            onPressed: _showAddStudentDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Field at the top
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or roll number...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // Student List
          Expanded(
            child: filteredStudents.isEmpty
                ? const Center(
                    child: Text(
                      'No students found.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = filteredStudents[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 6.0,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              student.name.isNotEmpty
                                  ? student.name[0].toUpperCase()
                                  : '?',
                            ),
                          ),
                          title: Text(
                            student.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            "Roll: ${student.rollNom} | Semester: ${student.smester}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  final originalindex = studentController.students.indexOf(student); 
                                  _showEditDialog(student, originalindex); 
                                },
                                icon: Icon(Icons.edit, color: Colors.green),
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  setState(() {
                                    studentController.remove(student);
                                  });
                                },
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
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
