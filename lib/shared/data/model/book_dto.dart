import 'package:cloud_firestore/cloud_firestore.dart';

class BookDto {
  String? id;
  String? name;
  String? gradeName;
  int? gradeId;
  String? subject;
  double? price;
  String? statusBadge;
  int? quantity;
  DateTime? createdAt;
  bool? withHeight;
  int? numWithWidth;
  int? numWithHeight;
  int? readyCount;
  int? printedWidth;
  int? printedHeight;
  int? readyWidth;
  int? readyHeight;
  bool ? addedToCart ;

  BookDto({
    this.id,
    this.name,
    this.gradeName,
    this.gradeId,
    this.subject,
    this.price,
    this.statusBadge,
    this.quantity,
    this.createdAt,
    this.withHeight,
    this.numWithWidth,
    this.numWithHeight,
    this.readyCount,
    this.printedWidth,
    this.printedHeight,
    this.readyWidth,
    this.readyHeight,
    this.addedToCart=false,
  });

  BookDto copyWith({
    String? id,
    String? name,
    String? gradeName,
    int? gradeId,
    String? subject,
    double? price,
    String? statusBadge,
    int? quantity,
    DateTime? createdAt,
    bool? withHeight,
    int? numWithWidth,
    int? numWithHeight,
    int? readyCount,
    int? printedWidth,
    int? printedHeight,
    int? readyWidth,
    int? readyHeight,
    bool? addedToCart,
  }) {
    return BookDto(
      id: id ?? this.id,
      name: name ?? this.name,
      gradeName: gradeName ?? this.gradeName,
      gradeId: gradeId ?? this.gradeId,
      subject: subject ?? this.subject,
      price: price ?? this.price,
      statusBadge: statusBadge ?? this.statusBadge,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
      withHeight: withHeight ?? this.withHeight,
      numWithHeight: numWithHeight ?? this.numWithHeight,
      numWithWidth: numWithWidth ?? this.numWithWidth,
      readyCount: readyCount ?? this.readyCount,
      printedWidth: printedWidth ?? this.printedWidth,
      printedHeight: printedHeight ?? this.printedHeight,
      readyWidth: readyWidth ?? this.readyWidth,
      readyHeight: readyHeight ?? this.readyHeight,
      addedToCart: addedToCart ?? this.addedToCart,
    );
  }

  factory BookDto.fromJson(Map<String, dynamic> json) {
    return BookDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
      subject: json['subject'] as String?,
      gradeId: json['gradeId'] as int?,
      gradeName: json['gradeName'] as String?,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      statusBadge: json['statusBadge'] as String?,
      quantity: json['quantity'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : json['createdAt'] is String
          ? DateTime.parse(json['createdAt'])
          : json['createdAt'] as DateTime?,
      withHeight: json['withHeight'] as bool?,
      numWithWidth: json['numWithWidth'] as int?,
      numWithHeight: json['numWithHeight'] as int?,
      readyCount: json['readyCount'] as int?,
      printedWidth: json['printedWidth'] as int?,
      printedHeight: json['printedHeight'] as int?,
      readyWidth: json['readyWidth'] as int?,
      readyHeight: json['readyHeight'] as int?,
      addedToCart: json['addedToCart'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subject': subject,
      'gradeId': gradeId,
      'gradeName': gradeName,
      'price': price,
      'statusBadge': statusBadge,
      'quantity': quantity,
      'createdAt': createdAt ?? DateTime.now(),
      'withHeight': withHeight,
      'readyCount': readyCount,
      'numWithWidth': numWithWidth,
      'numWithHeight': numWithHeight,
      'printedWidth': printedWidth,
      'printedHeight': printedHeight,
      'readyWidth': readyWidth,
      'readyHeight': readyHeight,
      'addedToCart': addedToCart,
    };
  }

  @override
  String toString() {
    return 'BookDto{id: $id, name: $name, gradeName: $gradeName, gradeId: $gradeId, subject: $subject, price: $price, statusBadge: $statusBadge, quantity: $quantity, createdAt: $createdAt} , withHeight: $withHeight, readyCount: $readyCount ,numWithWidth: $numWithWidth, numWithHeight: $numWithHeight, printedWidth: $printedWidth, printedHeight: $printedHeight , readyWidth: $readyWidth, readyHeight: $readyHeight , addedToCart: $addedToCart}';
  }
}
