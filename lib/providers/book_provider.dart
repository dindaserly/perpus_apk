import 'package:flutter/foundation.dart';
import '../models/book.dart';
import '../helpers/database_helper.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  final _db = DatabaseHelper.instance;

  List<Book> get books {
    return [..._books];
  }

  Future<void> loadBooks() async {
    try {
      _books = await _db.getAllBooks();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading books: $e');
      rethrow;
    }
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
    try {
      // Validate ISBN uniqueness
      if (_books.any((b) => b.isbn == book.isbn)) {
        throw Exception('Buku dengan ISBN ${book.isbn} sudah ada');
      }

      await _db.createBook(book);
      await loadBooks(); // Reload books from database
    } catch (e) {
      debugPrint('Error adding book: $e');
      rethrow;
    }
  }

  Future<void> updateBook(Book book) async {
    try {
      final index = _books.indexWhere((b) => b.id == book.id);
      if (index >= 0) {
        // Check if ISBN is changed and if it's unique
        if (book.isbn != _books[index].isbn &&
            _books.any((b) => b.isbn == book.isbn)) {
          throw Exception('Buku dengan ISBN ${book.isbn} sudah ada');
        }

        await _db.updateBook(book);
        await loadBooks(); // Reload books from database
      } else {
        throw Exception('Buku tidak ditemukan');
      }
    } catch (e) {
      debugPrint('Error updating book: $e');
      rethrow;
    }
  }

  Future<void> deleteBook(String id) async {
    try {
      await _db.deleteBook(id);
      await loadBooks(); // Reload books from database
    } catch (e) {
      debugPrint('Error deleting book: $e');
      rethrow;
    }
  }

  void updateBookAvailability(String id, bool isAvailable) async {
    try {
      final book = findById(id);
      if (book != null) {
        book.isAvailable = isAvailable;
        await _db.updateBook(book);
        await loadBooks(); // Reload books from database
      }
    } catch (e) {
      debugPrint('Error updating book availability: $e');
      rethrow;
    }
  }
}
