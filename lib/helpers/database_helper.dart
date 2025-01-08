import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('perpustakaan.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const boolType = 'INTEGER NOT NULL'; // For boolean values

    await db.execute('''
      CREATE TABLE books (
        id $idType,
        title $textType,
        author $textType,
        isbn $textType,
        publisher $textType,
        publicationYear $integerType,
        stock $integerType,
        isAvailable $boolType,
        category $textType,
        description $textType
      )
    ''');
  }

  // CRUD Operations for Books
  Future<Book> createBook(Book book) async {
    final db = await instance.database;
    await db.insert(
      'books',
      book.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return book;
  }

  Future<List<Book>> getAllBooks() async {
    final db = await instance.database;
    final result = await db.query('books');
    return result.map((json) => Book.fromJson(json)).toList();
  }

  Future<Book?> getBook(String id) async {
    final db = await instance.database;
    final result = await db.query(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Book.fromJson(result.first);
    }
    return null;
  }

  Future<int> updateBook(Book book) async {
    final db = await instance.database;
    return db.update(
      'books',
      book.toJson(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<int> deleteBook(String id) async {
    final db = await instance.database;
    return await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllBooks() async {
    final db = await instance.database;
    await db.delete('books');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
