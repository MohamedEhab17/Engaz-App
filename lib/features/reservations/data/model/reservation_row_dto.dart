import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engaz_app/shared/data/model/book_dto.dart';

class ReservationRowDto {
  String? id;
  String? bookId;
  String? bookName;
  String? subject;
  String? gradeName;
  int? gradeId;
  int? totalQuantity;
  double? totalPrice;
  bool? withHeight;
  bool? isReady;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? numWithHeight;
  int? numWithWidth;
  int? readyWidth;
  int? readyHeight;
  int? printedWidth;
  int? printedHeight;

  ReservationRowDto({
    this.id,
    this.bookId,
    this.bookName,
    this.subject,
    this.gradeName,
    this.gradeId,
    this.totalQuantity,
    this.totalPrice,
    this.withHeight,
    this.isReady,
    this.createdAt,
    this.updatedAt,
    this.numWithHeight,
    this.numWithWidth,
    this.readyWidth,
    this.readyHeight,
    this.printedWidth,
    this.printedHeight,
  });

  ReservationRowDto copyWith({
    String? id,
    String? bookId,
    String? bookName,
    String? subject,
    String? gradeName,
    int? gradeId,
    int? totalQuantity,
    double? totalPrice,
    bool? withHeight,
    bool? isReady,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? numWithHeight,
    int? numWithWidth,
    int? readyWidth,
    int? readyHeight,
    int? printedWidth,
    int? printedHeight,
  }) {
    return ReservationRowDto(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      bookName: bookName ?? this.bookName,
      subject: subject ?? this.subject,
      gradeName: gradeName ?? this.gradeName,
      gradeId: gradeId ?? this.gradeId,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      totalPrice: totalPrice ?? this.totalPrice,
      withHeight: withHeight ?? this.withHeight,
      isReady: isReady ?? this.isReady,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      numWithHeight: numWithHeight ?? this.numWithHeight,
      numWithWidth: numWithWidth ?? this.numWithWidth,
      readyWidth: readyWidth ?? this.readyWidth,
      readyHeight: readyHeight ?? this.readyHeight,
      printedWidth: printedWidth ?? this.printedWidth,
      printedHeight: printedHeight ?? this.printedHeight,
    );
  }

  factory ReservationRowDto.fromJson(Map<String, dynamic> json) {
    return ReservationRowDto(
      id: json['id'] as String?,
      bookId: json['bookId'] as String?,
      bookName: json['bookName'] as String?,
      subject: json['subject'] as String?,
      gradeName: json['gradeName'] as String?,
      gradeId: json['gradeId'] as int?,
      totalQuantity: json['totalQuantity'] as int?,
      totalPrice: json['totalPrice'] != null
          ? (json['totalPrice'] as num).toDouble()
          : null,
      withHeight: json['withHeight'] as bool?,
      isReady: json['isReady'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is Timestamp
                ? (json['createdAt'] as Timestamp).toDate()
                : DateTime.parse(json['createdAt'].toString()))
          : null,
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] is Timestamp
                ? (json['updatedAt'] as Timestamp).toDate()
                : DateTime.parse(json['updatedAt'].toString()))
          : null,
      numWithHeight: json['numWithHeight'] as int?,
      numWithWidth: json['numWithWidth'] as int?,
      readyWidth: json['readyWidth'] as int?,
      readyHeight: json['readyHeight'] as int?,
      printedWidth: json['printedWidth'] as int?,
      printedHeight: json['printedHeight'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'bookName': bookName,
      'subject': subject,
      'gradeName': gradeName,
      'gradeId': gradeId,
      'totalQuantity': totalQuantity ?? 0,
      'totalPrice': totalPrice ?? 0.0,
      'withHeight': withHeight ?? false,
      'isReady': isReady ?? false,
      'createdAt': createdAt ?? Timestamp.now(),
      'updatedAt': updatedAt ?? Timestamp.now(),
      'numWithHeight': numWithHeight ?? 0,
      'numWithWidth': numWithWidth ?? 0,
      'readyWidth': readyWidth ?? 0,
      'readyHeight': readyHeight ?? 0,
      'printedWidth': printedWidth ?? 0,
      'printedHeight': printedHeight ?? 0,
    };
  }

  // Helper method to create from BookDto
  static ReservationRowDto fromBookDto(BookDto book) {
    return ReservationRowDto(
      bookId: book.id,
      bookName: book.name,
      subject: book.subject,
      gradeName: book.gradeName,
      gradeId: book.gradeId,
      totalQuantity: book.quantity ?? 0,
      totalPrice: (book.price ?? 0.0) * (book.quantity ?? 0),
      withHeight: book.withHeight ?? false,
      isReady: book.statusBadge == 'ready' || book.statusBadge == 'received',
      createdAt: book.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      numWithHeight: book.numWithHeight ?? 0,
      numWithWidth: book.numWithWidth ?? 0,
      readyWidth: book.readyWidth ?? 0,
      readyHeight: book.readyHeight ?? 0,
      printedWidth: book.printedWidth ?? 0,
      printedHeight: book.printedHeight ?? 0,
    );
  }
}
