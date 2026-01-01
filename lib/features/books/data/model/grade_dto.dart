class GradeDto {
  GradeDto({required this.id, required this.name});
  final int id;
  final String name;

  factory GradeDto.fromJson(Map<String, dynamic> json) {
    return GradeDto(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
