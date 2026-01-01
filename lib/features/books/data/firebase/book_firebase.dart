import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engaz_app/shared/data/model/book_dto.dart';
import 'package:engaz_app/features/books/data/model/grade_dto.dart';
import 'package:flutter/foundation.dart';

class BookFirebase {
  BookFirebase._();
  static BookFirebase? _instance;
  static BookFirebase get instance => _instance ?? BookFirebase._();

  CollectionReference<GradeDto> getCollectionGrade() {
    return FirebaseFirestore.instance
        .collection('Grades')
        .withConverter<GradeDto>(
          fromFirestore: (grade, _) {
            final data = grade.data();
            if (data == null) {
              throw Exception('Grade data is null');
            }
            return GradeDto.fromJson(data);
          },
          toFirestore: (grade, _) => grade.toJson(),
        );
  }

  CollectionReference<BookDto> getCollectionBookByGradeId(GradeDto gradeModel) {
    return getCollectionGrade()
        .doc(gradeModel.id.toString())
        .collection("Books")
        .withConverter<BookDto>(
          fromFirestore: (book, _) {
            final data = book.data();
            if (data == null) {
              throw Exception('Book data is null');
            }
            return BookDto.fromJson(data);
          },
          toFirestore: (book, _) => book.toJson(),
        );
  }

  Future<void> addBook(GradeDto gradeModel, BookDto bookModel) async {
    try {
      bookModel.id = getCollectionBookByGradeId(gradeModel).doc().id;
      if (bookModel.id == null || bookModel.id!.isEmpty) {
        throw Exception('Failed to generate book ID');
      }
      await getCollectionBookByGradeId(
        gradeModel,
      ).doc(bookModel.id.toString()).set(bookModel.copyWith(id: bookModel.id));
    } catch (e) {
      if (kDebugMode) {
        log("Error adding book: $e");
      }
      rethrow;
    }
  }

  Future<void> updateBook(GradeDto gradeModel, BookDto bookModel) async {
    try {
      if (bookModel.id == null || bookModel.id!.isEmpty) {
        throw Exception('Book ID is required');
      }
      await getCollectionBookByGradeId(
        gradeModel,
      ).doc(bookModel.id.toString()).update(bookModel.toJson());
    } catch (e) {
      if (kDebugMode) {
        log("Error updating book: $e");
      }
      rethrow;
    }
  }

  Future<void> deleteBook(GradeDto gradeModel, String bookId) async {
    try {
      if (bookId.isEmpty) {
        throw Exception('Book ID is required');
      }
      await getCollectionBookByGradeId(gradeModel).doc(bookId).delete();
    } catch (e) {
      if (kDebugMode) {
        log("Error deleting book: $e");
      }
      rethrow;
    }
  }

  Future<List<BookDto>> getBooks(GradeDto gradeModel) async {
    List<BookDto> books = [];
    try {
      final snapshot = await getCollectionBookByGradeId(gradeModel).get();
      books = snapshot.docs
          .where((doc) {
            try {
              final book = doc.data();
              return book.gradeId == gradeModel.id;
            } catch (e) {
              if (kDebugMode) {
                log("Error parsing book document ${doc.id}: $e");
              }
              return false;
            }
          })
          .map((doc) => doc.data())
          .toList();
      return books;
    } catch (e) {
      if (kDebugMode) {
        log("Error getting books: $e");
      }
      rethrow;
    }
  }
}
