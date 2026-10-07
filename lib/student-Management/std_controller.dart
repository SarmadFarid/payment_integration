import 'package:payment_integration/student-Management/std_model.dart';

class StudentController {
  List<StudentModel> students = [StudentModel(name: 'My Little Student', rollNom: '101', smester: '5th')];

  void add(StudentModel std) {
    students.add(std);
  }

  void remove(StudentModel student) {
    students.remove(student);
  }

  void edit(StudentModel std, {required int index}) {
    if (index >= 0 && index < students.length) {
      students[index] = students[index].copywith(
        std.name,
        std.rollNom,
        std.smester,
      );
    }
  }

  List<StudentModel> searchStudent({required String query}) {
    if (query.trim().isEmpty) {
      return students;
    }
    return students.where((s) {
      return s.name.toLowerCase().contains(query) ||
          s.rollNom.toLowerCase().contains(query);
    }).toList();
  }
}
