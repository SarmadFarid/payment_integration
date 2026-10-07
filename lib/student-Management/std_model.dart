class StudentModel {
  final String name;
  final String rollNom;
  final String smester;

  StudentModel({
    required this.name,
    required this.rollNom,
    required this.smester,
  });

  StudentModel copywith(String? name, String? roll, String? smester) {
    return StudentModel(
      name: name ?? this.name,
      rollNom: roll ?? rollNom,
      smester: smester ?? this.smester,
    );
  }

  factory StudentModel.fromjson(Map<String, dynamic> json) {
    return StudentModel(
      name: json['name'],
      rollNom: json['roll'],
      smester: json['smester'],
    );
  }
}
