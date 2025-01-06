import 'package:flutter/foundation.dart';
import '../models/borrow_record.dart';

class BorrowProvider with ChangeNotifier {
  final List<BorrowRecord> _borrowRecords = [];

  List<BorrowRecord> get borrowRecords {
    return [..._borrowRecords];
  }

  List<BorrowRecord> get activeLoans {
    return _borrowRecords.where((record) => !record.isReturned).toList();
  }

  List<BorrowRecord> get overdueLoans {
    return activeLoans.where((record) => record.isOverdue()).toList();
  }

  List<BorrowRecord> getMemberBorrowHistory(String memberId) {
    return _borrowRecords
        .where((record) => record.memberId == memberId)
        .toList();
  }

  List<BorrowRecord> getBookBorrowHistory(String bookId) {
    return _borrowRecords.where((record) => record.bookId == bookId).toList();
  }

  void addBorrowRecord(BorrowRecord record) {
    _borrowRecords.add(record);
    notifyListeners();
  }

  void returnBook(String recordId) {
    final index = _borrowRecords.indexWhere((record) => record.id == recordId);
    if (index >= 0) {
      _borrowRecords[index].returnDate = DateTime.now();
      _borrowRecords[index].isReturned = true;
      notifyListeners();
    }
  }

  bool canBorrowBook(String memberId) {
    final activeBookCount =
        activeLoans.where((record) => record.memberId == memberId).length;
    return activeBookCount < 3; // Maximum 3 books per member
  }

  bool hasOverdueBooks(String memberId) {
    return activeLoans
        .where((record) => record.memberId == memberId && record.isOverdue())
        .isNotEmpty;
  }
}
