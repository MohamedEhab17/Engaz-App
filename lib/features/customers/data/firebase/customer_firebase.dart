import 'dart:developer';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engaz_app/features/books/data/model/grade_dto.dart';
import 'package:engaz_app/features/customers/data/model/customer_dto.dart';
import 'package:engaz_app/shared/data/model/book_dto.dart';
import 'package:flutter/foundation.dart';

class CustomerFirebase {
  CustomerFirebase._();
  static CustomerFirebase? _instance;
  static CustomerFirebase get instance => _instance ?? CustomerFirebase._();

  CollectionReference<CustomerDto> getCollectionCustomers() {
    return FirebaseFirestore.instance
        .collection('Customers')
        .withConverter<CustomerDto>(
          fromFirestore: (customer, _) {
            final data = customer.data();
            if (data == null) {
              throw Exception('Customer data is null');
            }
            return CustomerDto.fromJson(data);
          },
          toFirestore: (customer, _) => customer.toJson(),
        );
  }

  Stream<List<CustomerDto>> getAllCustomers() {
    return getCollectionCustomers()
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) {
            return <CustomerDto>[];
          }
          return snapshot.docs.map((doc) {
            try {
              return doc.data();
            } catch (e) {
              if (kDebugMode) {
                log("Error parsing customer document ${doc.id}: $e");
              }
              rethrow;
            }
          }).toList();
        })
        .handleError((error) {
          if (kDebugMode) {
            log("Error in getAllCustomers stream: $error");
          }
          throw error;
        });
  }

  Future<bool> isCustomerExists(String phone) async {
    try {
      final doc = await getCollectionCustomers().doc(phone).get();
      if (kDebugMode) {
        log("Customer exists check for phone $phone: ${doc.exists}");
      }
      return doc.exists;
    } catch (e) {
      if (kDebugMode) {
        log("Error checking customer existence: $e");
      }
      rethrow;
    }
  }

  Future<void> addCustomer(CustomerDto customer) async {
    try {
      await getCollectionCustomers()
          .doc(customer.phone.toString())
          .set(customer);
    } catch (e) {
      if (kDebugMode) {
        log("Error adding customer: $e");
      }
      rethrow;
    }
  }

  Future<void> updateCustomer(CustomerDto customer) async {
    try {
      await getCollectionCustomers()
          .doc(customer.phone.toString())
          .update(customer.toJson());
    } catch (e) {
      if (kDebugMode) {
        log("Error updating customer: $e");
      }
      rethrow;
    }
  }

  Future<void> deleteCustomer(String phone) async {
    try {
      final customerRef = getCollectionCustomers().doc(phone);
      final booksCollection = customerRef.collection("Books");

      final booksSnapshot = await booksCollection.get();

      // We will perform updates in batches since we can't do a single transaction for many books easily without hitting limits.
      // But for a single user, it's safer to iterate and update reservations one by one or in small groups.
      // Given the requirement for robustness, we will iterate and use transactions per book or small batches.
      // However, to ensure atomicity for the deletion itself, we can use a batch for the delete but we need to update reservations first.

      // 1. Update Reservations first (best effort to keep sync)
      for (var doc in booksSnapshot.docs) {
        final bookData = doc.data();
        final bookId = bookData['id'] as String?;
        if (bookId != null) {
          await FirebaseFirestore.instance.runTransaction((transaction) async {
            final reservationQuery = await getCollectionReservations()
                .where('bookId', isEqualTo: bookId)
                .limit(1)
                .get();

            if (reservationQuery.docs.isNotEmpty) {
              final reservationRef = reservationQuery.docs.first.reference;
              final reservationData = reservationQuery.docs.first.data();

              final int quantity = bookData['quantity'] as int? ?? 0;
              final double price =
                  (bookData['price'] as num?)?.toDouble() ?? 0.0;
              final String status =
                  bookData['statusBadge'] as String? ?? 'waiting';
              final bool withHeight = bookData['withHeight'] as bool? ?? false;

              reservationData['totalQuantity'] = math.max(
                0,
                (reservationData['totalQuantity'] as int) - quantity,
              );
              reservationData['totalPrice'] = math.max(
                0.0,
                (reservationData['totalPrice'] as num).toDouble() -
                    (price * quantity),
              );
              reservationData['updatedAt'] = FieldValue.serverTimestamp();

              if (status == 'ready') {
                if (withHeight) {
                  reservationData['readyHeight'] = math.max(
                    0,
                    (reservationData['readyHeight'] as int) - quantity,
                  );
                  // Added printed logic
                  reservationData['printedHeight'] = math.max(
                    0,
                    (reservationData['printedHeight'] as int? ?? 0) - quantity,
                  );
                } else {
                  reservationData['readyWidth'] = math.max(
                    0,
                    (reservationData['readyWidth'] as int) - quantity,
                  );
                  // Added printed logic
                  reservationData['printedWidth'] = math.max(
                    0,
                    (reservationData['printedWidth'] as int? ?? 0) - quantity,
                  );
                }
              } else if (status == 'waiting') {
                if (withHeight) {
                  reservationData['numWithHeight'] = math.max(
                    0,
                    (reservationData['numWithHeight'] as int) - quantity,
                  );
                } else {
                  reservationData['numWithWidth'] = math.max(
                    0,
                    (reservationData['numWithWidth'] as int) - quantity,
                  );
                }
              }

              if ((reservationData['totalQuantity'] as int) <= 0) {
                transaction.delete(reservationRef);
              } else {
                transaction.update(reservationRef, reservationData);
              }
            }
          });
        }
      }

      // 2. Delete User and Books
      final batch = FirebaseFirestore.instance.batch();
      for (var doc in booksSnapshot.docs) {
        batch.delete(doc.reference);
      }
      batch.delete(customerRef);
      await batch.commit();

      if (kDebugMode) {
        log("Customer and their Books deleted successfully");
      }
    } catch (e) {
      if (kDebugMode) {
        log("Error deleting customer: $e");
      }
      rethrow;
    }
  }

  CollectionReference<BookDto> getCollectionCustomerBookByGradeId(
    String customerId,
  ) {
    return getCollectionCustomers()
        .doc(customerId)
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

  Future<void> addBookToCustomer(String customerId, BookDto book) async {
    try {
      if (book.id == null || book.id!.isEmpty) {
        throw Exception('Book ID is required');
      }

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final customerRef = getCollectionCustomers().doc(customerId);
        final bookRef = getCollectionCustomerBookByGradeId(
          customerId,
        ).doc(book.id);

        // 0. Queries (Reads outside transaction lock, but safe for this logic)
        // If we wanted to lock the reservation row, we would need to read it via transaction.get(reservationRef)
        // Since we don't know the ID yet, we query it.
        final reservationQuery = await getCollectionReservations()
            .where('bookId', isEqualTo: book.id)
            .limit(1)
            .get();

        DocumentReference reservationRef;
        Map<String, dynamic> reservationData;

        if (reservationQuery.docs.isNotEmpty) {
          reservationRef = reservationQuery.docs.first.reference;
          reservationData = reservationQuery.docs.first.data();
        } else {
          reservationRef = getCollectionReservations().doc();
          reservationData = {
            'bookId': book.id,
            'bookName': book.name,
            'subject': book.subject,
            'gradeName': book.gradeName,
            'gradeId': book.gradeId,
            'totalQuantity': 0,
            'totalPrice': 0.0,
            'isReady': false,
            'numWithHeight': 0,
            'numWithWidth': 0,
            'readyHeight': 0,
            'readyWidth': 0,
            'printedHeight': 0,
            'printedWidth': 0,
            'createdAt': FieldValue.serverTimestamp(),
          };
          // Note: New doc set happens at the end
        }

        // 1. Transaction Reads (MUST BE FIRST)
        final customerSnapshot = await transaction.get(customerRef);
        final currentCount = customerSnapshot.exists
            ? (customerSnapshot.get('numberOfBooks') ?? 0)
            : 0;

        // 2. Transaction Writes

        // Write Book
        transaction.set(bookRef, book);

        // Update Customer
        if (customerSnapshot.exists) {
          transaction.update(customerRef, {
            'numberOfBooks': currentCount + 1,
            'shoppingCartCount': currentCount + 1,
          });
        }

        // Update Reservation
        final quantity = book.quantity ?? 0;
        final double price = book.price ?? 0.0;
        final bool withHeight = book.withHeight ?? false;

        // Use readyCount if available, or infer from status (for backward compat or if status passed explicitly)
        // But since we control the object, we prefer readyCount.
        // If adding a new book, typically readyCount is 0 unless pre-set.
        final int readyCount =
            book.readyCount ?? (book.statusBadge == 'ready' ? quantity : 0);

        final int readyPart = readyCount;
        final int waitingPart = math.max(0, quantity - readyCount);

        reservationData['totalQuantity'] =
            (reservationData['totalQuantity'] as int) + quantity;
        reservationData['totalPrice'] =
            (reservationData['totalPrice'] as num).toDouble() +
            (price * quantity);
        reservationData['updatedAt'] = FieldValue.serverTimestamp();

        if (withHeight) {
          reservationData['readyHeight'] =
              (reservationData['readyHeight'] as int) + readyPart;
          reservationData['numWithHeight'] =
              (reservationData['numWithHeight'] as int) + waitingPart;
          // Printed Logic - NO INCREMENT ON ADD
          // reservationData['printedHeight'] =
          //     (reservationData['printedHeight'] as int? ?? 0) + readyPart;
        } else {
          reservationData['readyWidth'] =
              (reservationData['readyWidth'] as int) + readyPart;
          reservationData['numWithWidth'] =
              (reservationData['numWithWidth'] as int) + waitingPart;
          // Printed Logic - NO INCREMENT ON ADD
          // reservationData['printedWidth'] =
          //     (reservationData['printedWidth'] as int? ?? 0) + readyPart;
        }

        if (waitingPart > 0) {
          reservationData['isReady'] = false;
        }

        if (reservationQuery.docs.isEmpty) {
          transaction.set(reservationRef, reservationData);
        } else {
          transaction.update(reservationRef, reservationData);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        log("Error adding book to customer: $e");
      }
      rethrow;
    }
  }

  Future<void> addBookToCart({
    required String customerId,
    required String bookId,
  }) async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final customerRef = getCollectionCustomers().doc(customerId);
        final bookRef = getCollectionCustomerBookByGradeId(
          customerId,
        ).doc(bookId);

        // 1️⃣ Reads (لازم الأول)
        final customerSnap = await transaction.get(customerRef);
        final bookSnap = await transaction.get(bookRef);

        if (!customerSnap.exists) {
          throw Exception('Customer not found');
        }

        if (!bookSnap.exists) {
          throw Exception('Book not found');
        }

        final int currentCartCount = customerSnap.get('shoppingCartCount') ?? 0;

        if (currentCartCount <= 0) {
          throw Exception('Shopping cart count is already zero');
        }

        // 2️⃣ Writes

        /// نقص addToCart (shoppingCartCount) بواحد
        transaction.update(customerRef, {
          'shoppingCartCount': currentCartCount - 1,
        });

        /// خلي addedToCart = true
        transaction.update(bookRef, {
          'addedToCart': true,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      if (kDebugMode) {
        log('Error in addBookToCart: $e');
      }
      rethrow;
    }
  }

  Future<void> removeBookFromCustomer(String customerId, BookDto book) async {
    try {
      if (book.id == null || book.id!.isEmpty) {
        throw Exception('Book ID is required');
      }

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final customerRef = getCollectionCustomers().doc(customerId);
        final bookRef = getCollectionCustomerBookByGradeId(
          customerId,
        ).doc(book.id);

        // ----------------------------
        // READ FIRST
        // ----------------------------
        final bookSnapshot = await transaction.get(bookRef);
        if (!bookSnapshot.exists) {
          throw Exception('Book not found');
        }

        final customerSnapshot = await transaction.get(customerRef);

        final reservationQuery = await getCollectionReservations()
            .where('bookId', isEqualTo: book.id)
            .limit(1)
            .get();

        // ----------------------------
        // BOOK DATA (SOURCE OF TRUTH)
        // ----------------------------
        final deletedBook = BookDto.fromJson(bookSnapshot.data()!.toJson());

        final int quantity = deletedBook.quantity ?? 0;
        final int readyCount = deletedBook.readyCount ?? 0;
        final bool withHeight = deletedBook.withHeight ?? false;
        final double price = deletedBook.price ?? 0.0;
        final String status = deletedBook.statusBadge ?? 'waiting';

        final bool shouldAffectReservation = status != 'received';

        final int effectiveReady = shouldAffectReservation ? readyCount : 0;

        final int effectiveWaiting = shouldAffectReservation
            ? math.max(0, quantity - readyCount)
            : 0;

        final int effectiveQuantity = effectiveReady + effectiveWaiting;

        // ----------------------------
        // DELETE BOOK
        // ----------------------------
        transaction.delete(bookRef);

        // ----------------------------
        // UPDATE CUSTOMER COUNTER
        // ----------------------------
        if (customerSnapshot.exists) {
          final customerData = customerSnapshot.data();
          final int currentCount = customerData?.numberOfBooks ?? 1;

          int currentPrintedHeight = customerData?.printedHeight ?? 0;
          int currentPrintedWidth = customerData?.printedWidth ?? 0;

          if (withHeight) {
            currentPrintedHeight = math.max(
              0,
              currentPrintedHeight - effectiveReady,
            );
          } else {
            currentPrintedWidth = math.max(
              0,
              currentPrintedWidth - effectiveReady,
            );
          }

          transaction.update(customerRef, {
            'numberOfBooks': math.max(0, currentCount - 1),
            'printedHeight': currentPrintedHeight,
            'printedWidth': currentPrintedWidth,
          });
        }

        // ----------------------------
        //! UPDATE RESERVATION (ONLY IF NEEDED)
        // ----------------------------
        if (shouldAffectReservation &&
            reservationQuery.docs.isNotEmpty &&
            effectiveQuantity > 0) {
          final reservationRef = reservationQuery.docs.first.reference;
          final reservationData = reservationQuery.docs.first.data();

          // TOTALS
          reservationData['totalQuantity'] = math.max(
            0,
            (reservationData['totalQuantity'] as int) - effectiveQuantity,
          );

          reservationData['totalPrice'] = math.max(
            0.0,
            (reservationData['totalPrice'] as num).toDouble() -
                (price * effectiveQuantity),
          );

          reservationData['updatedAt'] = FieldValue.serverTimestamp();

          //! READY / WAITING
          if (withHeight) {
            reservationData['readyHeight'] = math.max(
              0,
              (reservationData['readyHeight'] as int) - effectiveReady,
            );
            // Printed Logic
            reservationData['printedHeight'] = math.max(
              0,
              (reservationData['printedHeight'] as int? ?? 0) - effectiveReady,
            );
            reservationData['numWithHeight'] = math.max(
              0,
              (reservationData['numWithHeight'] as int) - effectiveWaiting,
            );
          } else {
            reservationData['readyWidth'] = math.max(
              0,
              (reservationData['readyWidth'] as int) - effectiveReady,
            );
            reservationData['numWithWidth'] = math.max(
              0,
              (reservationData['numWithWidth'] as int) - effectiveWaiting,
            );
            // Printed Logic
            reservationData['printedWidth'] = math.max(
              0,
              (reservationData['printedWidth'] as int? ?? 0) - effectiveReady,
            );
          }

          final int remainingReady =
              (reservationData['readyHeight'] as int? ?? 0) +
              (reservationData['readyWidth'] as int? ?? 0);

          final int remainingWaiting =
              (reservationData['numWithHeight'] as int? ?? 0) +
              (reservationData['numWithWidth'] as int? ?? 0);

          if (remainingReady + remainingWaiting <= 0) {
            transaction.delete(reservationRef);
          } else {
            reservationData['isReady'] =
                remainingWaiting == 0 && remainingReady > 0;

            transaction.update(reservationRef, reservationData);
          }
        }
      });
    } catch (e) {
      if (kDebugMode) {
        log("Error removing book from customer: $e");
      }
      rethrow;
    }
  }

  // ----------------------------
  //! UPDATE BOOK IN CUSTOMER
  // ----------------------------
  Future<void> updateBookInCustomer(String customerId, BookDto book) async {
    try {
      if (book.id == null || book.id!.isEmpty) {
        throw Exception('Book ID is required');
      }
      final customerRef = getCollectionCustomers().doc(customerId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final bookRef = getCollectionCustomerBookByGradeId(
          customerId,
        ).doc(book.id);
        // ----------------------------
        // READ FIRST
        // ----------------------------
        final snapshot = await transaction.get(bookRef);
        if (!snapshot.exists) {
          throw Exception('Book not found');
        }

        final oldData = snapshot.data()!.copyWith();
        // ----------------------------
        // OLD VALUES
        // ----------------------------
        final int oldQuantity = oldData.quantity ?? 0;
        final int oldReadyCount =
            oldData.readyCount ??
            (oldData.statusBadge == 'ready' ? oldQuantity : 0);

        final bool oldWithHeight = oldData.withHeight ?? false;
        final double oldPrice = oldData.price ?? 0.0;
        // ----------------------------
        // RECEIVE ALL ?
        // ----------------------------
        final bool isReceivingAll =
            book.statusBadge == 'received' && oldQuantity > 0;
        // ----------------------------
        // NEW VALUES
        // ----------------------------
        int newQuantity = book.quantity ?? oldQuantity;
        int newReadyCount = oldReadyCount;
        final bool newWithHeight = book.withHeight ?? oldWithHeight;
        final double newPrice = book.price ?? oldPrice;

        if (isReceivingAll) {
          newQuantity = 0;
          newReadyCount = 0;
        } else {
          if (newQuantity < newReadyCount) {
            newReadyCount = newQuantity;
          }
        }
        // ----------------------------
        // STATUS
        // ----------------------------
        final String newStatus = isReceivingAll
            ? 'received'
            : (newReadyCount < newQuantity ? 'waiting' : 'ready');

        book.quantity = newQuantity;
        book.readyCount = newReadyCount;
        book.statusBadge = newStatus;
        if (book.statusBadge == 'waiting') {
          book.addedToCart = false;
          transaction.update(customerRef, {
            'shoppingCartCount': FieldValue.increment(
              1,
            ), // Return to cart if waiting
          });
        }

        // ----------------------------
        // DIFF
        // ----------------------------
        final int quantityDiff = newQuantity - oldQuantity;
        final int readyDiff = newReadyCount - oldReadyCount;
        final int waitingDiff = quantityDiff - readyDiff;

        // ----------------------------
        // UPDATE BOOK
        // ----------------------------
        transaction.update(bookRef, book.toJson());

        final reservationQuery = await getCollectionReservations()
            .where('bookId', isEqualTo: book.id)
            .limit(1)
            .get();

        if (reservationQuery.docs.isNotEmpty) {
          final reservationRef = reservationQuery.docs.first.reference;
          final reservationData = reservationQuery.docs.first.data();

          //! TOTALS
          reservationData['totalQuantity'] =
              (reservationData['totalQuantity'] as int) + quantityDiff;

          reservationData['totalPrice'] =
              (reservationData['totalPrice'] as num).toDouble() +
              ((newPrice * newQuantity) - (oldPrice * oldQuantity));

          reservationData['updatedAt'] = FieldValue.serverTimestamp();
          //! PRINTED ADJUSTMENT IF RECEIVED
          if (isReceivingAll) {
            final int receivedCount = oldReadyCount;

            if (receivedCount > 0) {
              if (oldWithHeight) {
                reservationData['printedHeight'] =
                    (reservationData['printedHeight'] as int? ?? 0) -
                    receivedCount;
              } else {
                reservationData['printedWidth'] =
                    (reservationData['printedWidth'] as int? ?? 0) -
                    receivedCount;
              }
            }
          }
          //! APPLY DIFF
          if (newWithHeight) {
            if (readyDiff != 0) {
              reservationData['readyHeight'] =
                  (reservationData['readyHeight'] as int) + readyDiff;
            }
            if (waitingDiff != 0) {
              reservationData['numWithHeight'] =
                  (reservationData['numWithHeight'] as int) + waitingDiff;
            }
          } else {
            if (readyDiff != 0) {
              reservationData['readyWidth'] =
                  (reservationData['readyWidth'] as int) + readyDiff;
            }
            if (waitingDiff != 0) {
              reservationData['numWithWidth'] =
                  (reservationData['numWithWidth'] as int) + waitingDiff;
            }
          }
          final bool quantityIncreased = quantityDiff > 0;

          if (quantityIncreased) {
            reservationData['isReady'] = false;
          } else {
            reservationData['isReady'] =
                reservationData['isReady'] as bool? ?? true;
          }
          transaction.update(reservationRef, reservationData);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        log("Error updating book in customer: $e");
      }
      rethrow;
    }
  }

  Stream<List<BookDto>> getCustomerBooks({required String customerId}) {
    return getCollectionCustomerBookByGradeId(customerId)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) {
            return <BookDto>[];
          }
          return snapshot.docs.map((doc) {
            try {
              return doc.data();
            } catch (e) {
              if (kDebugMode) {
                log("Error parsing book document ${doc.id}: $e");
              }
              rethrow;
            }
          }).toList();
        })
        .handleError((error) {
          if (kDebugMode) {
            log("Error in getCustomerBooks stream: $error");
          }
          throw error;
        });
  }

  Future<bool> isCustomerBookExists(String customerId, String bookId) async {
    try {
      final doc = await getCollectionCustomerBookByGradeId(
        customerId,
      ).doc(bookId).get();
      if (kDebugMode) {
        log("Book exists check for bookId $bookId: ${doc.exists}");
      }
      return doc.exists;
    } catch (e) {
      if (kDebugMode) {
        log("Error checking book existence: $e");
      }
      rethrow;
    }
  }

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

  CollectionReference<BookDto> getCollectionBookByGradeId(String gradeId) {
    return getCollectionGrade()
        .doc(gradeId)
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

  Stream<List<BookDto>> streamBooksByGradeAndSubject({
    required String gradeId,
    required String subject,
  }) {
    try {
      if (kDebugMode) {
        log("Streaming books for gradeId: $gradeId and subject: $subject");
        log(
          "Collection Reference: ${getCollectionBookByGradeId(gradeId).path}",
        );
      }
      return getCollectionBookByGradeId(gradeId)
          .where("subject", isEqualTo: subject)
          .snapshots()
          .map((snapshot) {
            if (kDebugMode) {
              log("Streaming books: ${snapshot.docs.length} found");
            }
            if (snapshot.docs.isEmpty) {
              return <BookDto>[];
            }
            return snapshot.docs.map((e) {
              try {
                return e.data();
              } catch (error) {
                if (kDebugMode) {
                  log("Error parsing book document ${e.id}: $error");
                }
                rethrow;
              }
            }).toList();
          })
          .handleError((error) {
            if (kDebugMode) {
              log("Error in streamBooksByGradeAndSubject stream: $error");
            }
            throw error;
          });
    } catch (e) {
      if (kDebugMode) {
        log("Error while streaming books: $e");
      }
      return Stream.error(e);
    }
  }

  //! ========== RESERVATION METHODS ==========

  // Reservations collection organized by rows
  CollectionReference<Map<String, dynamic>> getCollectionReservations() {
    return FirebaseFirestore.instance.collection('Reservations');
  }

  // Aggregate and upsert reservation row by bookId
  Future<void> syncReservationForBook(String bookId) async {
    try {
      if (bookId.isEmpty) {
        throw Exception('Book ID is required');
      }

      // Aggregate all customer books with this bookId
      final customersSnapshot = await getCollectionCustomers().get();
      int totalQuantity = 0;
      double totalPrice = 0.0;
      String? bookName;
      String? subject;
      String? gradeName;
      int? gradeId;
      bool isReady = true;
      int numWithHeight = 0;
      int numWithWidth = 0;
      int readyHeight = 0;
      int readyWidth = 0;
      int printedHeight = 0;
      int printedWidth = 0;

      for (var customerDoc in customersSnapshot.docs) {
        final booksSnapshot = await customerDoc.reference
            .collection('Books')
            .where('id', isEqualTo: bookId)
            .get();

        for (var bookDoc in booksSnapshot.docs) {
          final bookData = bookDoc.data();
          final quantity = bookData['quantity'] as int? ?? 0;
          final price = (bookData['price'] as num?)?.toDouble() ?? 0.0;
          final statusBadge = bookData['statusBadge'] as String?;
          final readyCount =
              bookData['readyCount'] as int? ??
              (statusBadge == 'ready' || statusBadge == 'received'
                  ? quantity
                  : 0);

          totalQuantity += quantity;
          totalPrice += price * quantity;

          final readyPart = readyCount;
          final waitingPart = math.max(0, quantity - readyCount);

          if (bookData['withHeight'] == true) {
            readyHeight += readyPart;
            numWithHeight += waitingPart;
            printedHeight += readyPart;
          } else {
            readyWidth += readyPart;
            numWithWidth += waitingPart;
            printedWidth += readyPart;
          }
          // log("1.numWithHeight: $numWithHeight, numWithWidth: $numWithWidth");

          if (waitingPart > 0) {
            isReady = false;
          }

          // Set book details from first occurrence
          if (bookName == null) {
            bookName = bookData['name'] as String?;
            subject = bookData['subject'] as String?;
            gradeName = bookData['gradeName'] as String?;
            gradeId = bookData['gradeId'] as int?;
          }
        }
      }
      numWithHeight = (numWithHeight - readyHeight)
          .clamp(0, double.infinity)
          .toInt();
      numWithWidth = (numWithWidth - readyWidth)
          .clamp(0, double.infinity)
          .toInt();

      // If no books found, delete the reservation row
      if (totalQuantity == 0) {
        await deleteReservationRowByBookId(bookId);
        return;
      }

      // Check if reservation row exists
      final existingRow = await getReservationRowByBookId(bookId);

      final reservationData = {
        'bookId': bookId,
        'bookName': bookName,
        'subject': subject,
        'gradeName': gradeName,
        'gradeId': gradeId,
        'totalQuantity': totalQuantity,
        'totalPrice': totalPrice,
        'isReady': isReady,
        'updatedAt': FieldValue.serverTimestamp(),
        'numWithHeight': numWithHeight,
        'numWithWidth': numWithWidth,
        'readyHeight': readyHeight,
        'readyWidth': readyWidth,
        'printedHeight': printedHeight,
        'printedWidth': printedWidth,
      };

      if (existingRow != null) {
        // Update existing row

        final rowId = existingRow['id'] as String?;

        if (rowId != null) {
          await getCollectionReservations().doc(rowId).update(reservationData);
        }
      } else {
        // Create new row
        final rowRef = getCollectionReservations().doc();
        await rowRef.set({
          'id': rowRef.id,
          ...reservationData,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      if (kDebugMode) {
        log("Error syncing reservation: $e");
      }
      rethrow;
    }
  }

  //! Get reservation row by bookId
  Future<Map<String, dynamic>?> getReservationRowByBookId(String bookId) async {
    try {
      final querySnapshot = await getCollectionReservations()
          .where('bookId', isEqualTo: bookId)
          .limit(1)
          .get();
      if (querySnapshot.docs.isEmpty) {
        return null;
      }
      return querySnapshot.docs.first.data();
    } catch (e) {
      if (kDebugMode) {
        log("Error getting reservation row: $e");
      }
      rethrow;
    }
  }

  //! Delete reservation row by bookId
  Future<void> deleteReservationRowByBookId(String bookId) async {
    try {
      final querySnapshot = await getCollectionReservations()
          .where('bookId', isEqualTo: bookId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
      }
    } catch (e) {
      if (kDebugMode) {
        log("Error deleting reservation row: $e");
      }
      rethrow;
    }
  }

  //! Get all reservation rows
  Stream<List<Map<String, dynamic>>> getAllReservationRows() {
    return getCollectionReservations()
        .snapshots()
        .map((snapshot) {
          final rows = snapshot.docs.map((doc) {
            final data = doc.data();
            return {...data, 'id': doc.id};
          }).toList();

          // Sort by createdAt if available, otherwise by id
          rows.sort((a, b) {
            final aCreated = a['createdAt'];
            final bCreated = b['createdAt'];
            if (aCreated != null && bCreated != null) {
              final aTime = aCreated is Timestamp
                  ? aCreated.toDate()
                  : DateTime.parse(aCreated.toString());
              final bTime = bCreated is Timestamp
                  ? bCreated.toDate()
                  : DateTime.parse(bCreated.toString());
              return bTime.compareTo(aTime);
            }
            return (b['id'] as String).compareTo(a['id'] as String);
          });

          return rows;
        })
        .handleError((error) {
          if (kDebugMode) {
            log("Error in getAllReservationRows stream: $error");
          }
          throw error;
        });
  }

  Future<void> finalizeReservation(String bookId) async {
    try {
      // ----------------------------
      // READ RESERVATION
      // ----------------------------
      final querySnapshot = await getCollectionReservations()
          .where('bookId', isEqualTo: bookId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return;

      final reservationRef = querySnapshot.docs.first.reference;
      final reservationData = querySnapshot.docs.first.data();

      final int oldPrintedWidth = reservationData['printedWidth'] as int? ?? 0;
      final int oldPrintedHeight =
          reservationData['printedHeight'] as int? ?? 0;

      final int readyWidth = reservationData['readyWidth'] as int? ?? 0;
      final int readyHeight = reservationData['readyHeight'] as int? ?? 0;
      final int numOfWidth = reservationData['numWithWidth'] as int? ?? 0;
      final int numOfHeight = reservationData['numWithHeight'] as int? ?? 0;

      // ----------------------------
      // 🔥 CALCULATE WHAT TO PRINT
      // ----------------------------

      final int widthToPrint = math.max(
        0,
        numOfWidth - oldPrintedWidth + readyWidth,
      );
      final int heightToPrint = math.max(
        0,
        numOfHeight - oldPrintedHeight + readyHeight,
      );
      // ----------------------------
      // UPDATE RESERVATION
      // ----------------------------
      await reservationRef.update({
        'isReady': true,
        'printedWidth': oldPrintedWidth + widthToPrint,
        'printedHeight': oldPrintedHeight + heightToPrint,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // ----------------------------
      // UPDATE CUSTOMER BOOKS
      // ----------------------------
      final customersSnapshot = await getCollectionCustomers().get();
      final batch = FirebaseFirestore.instance.batch();
      int batchCount = 0;

      for (var customerDoc in customersSnapshot.docs) {
        final booksSnapshot = await customerDoc.reference
            .collection('Books')
            .where('id', isEqualTo: bookId)
            .get();

        for (var bookDoc in booksSnapshot.docs) {
          final bookData = bookDoc.data();
          final statusBadge = bookData['statusBadge'] as String?;

          // Only update non-ready books
          if (statusBadge == 'waiting' || statusBadge == 'ordered') {
            final int quantity = bookData['quantity'] as int? ?? 0;

            batch.update(bookDoc.reference, {
              'statusBadge': 'ready',
              'readyCount': quantity,
            });

            batchCount++;
            if (batchCount >= 450) {
              await batch.commit();
              batchCount = 0;
            }
          }
        }
      }

      if (batchCount > 0) {
        await batch.commit();
      }

      // ----------------------------
      // FINAL SYNC
      // ----------------------------
      await syncReservationForBook(bookId);
    } catch (e) {
      if (kDebugMode) {
        log("Error finalizing reservation: $e");
      }
      rethrow;
    }
  }
}
