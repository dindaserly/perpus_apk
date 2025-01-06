import 'package:flutter/foundation.dart';
import '../models/book.dart';

class BookProvider with ChangeNotifier {
  final List<Book> _books = [];

  List<Book> get books {
    return [..._books];
  }

  Book? findById(String id) {
    try {
      return _books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Book> searchBooks(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _books.where((book) {
      return book.title.toLowerCase().contains(lowercaseQuery) ||
          book.author.toLowerCase().contains(lowercaseQuery) ||
          book.isbn.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  Future<void> addBook(Book book) async {
    // Validate ISBN uniqueness
    if (_books.any((b) => b.isbn == book.isbn)) {
      throw Exception('Buku dengan ISBN ${book.isbn} sudah ada');
    }

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    _books.add(book);
    notifyListeners();
  }

  Future<void> updateBook(Book book) async {
    final index = _books.indexWhere((b) => b.id == book.id);
    if (index >= 0) {
      // Check if ISBN is changed and if it's unique
      if (book.isbn != _books[index].isbn &&
          _books.any((b) => b.isbn == book.isbn)) {
        throw Exception('Buku dengan ISBN ${book.isbn} sudah ada');
      }

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      _books[index] = book;
      notifyListeners();
    } else {
      throw Exception('Buku tidak ditemukan');
    }
  }

  Future<void> deleteBook(String id) async {
    // Check if book exists
    final book = findById(id);
    if (book == null) {
      throw Exception('Buku tidak ditemukan');
    }

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    _books.removeWhere((book) => book.id == id);
    notifyListeners();
  }

  void updateBookAvailability(String id, bool isAvailable) {
    final index = _books.indexWhere((b) => b.id == id);
    if (index >= 0) {
      _books[index].isAvailable = isAvailable;
      notifyListeners();
    }
  }

  List<Book> getBooksByCategory(String category) {
    return _books.where((book) => book.category == category).toList();
  }

  List<Book> getAvailableBooks() {
    return _books.where((book) => book.isAvailable).toList();
  }

  int getTotalBooks() {
    return _books.length;
  }

  int getAvailableBooksCount() {
    return _books.where((book) => book.isAvailable).length;
  }

  Map<String, int> getBooksByCategories() {
    final Map<String, int> categoryCount = {};
    for (var book in _books) {
      categoryCount[book.category] = (categoryCount[book.category] ?? 0) + 1;
    }
    return categoryCount;
  }
}
