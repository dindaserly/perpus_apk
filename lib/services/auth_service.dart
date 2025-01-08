import '../models/member.dart';
import '../helpers/database_helper.dart';

class AuthService {
  static const String tableName = 'members';

  Future<Member> login(String email, String password) async {
    final db = await DatabaseHelper.instance.database;

    final results = await db.query(
      tableName,
      where: 'email = ? AND password = ?',
      whereArgs: [email.toLowerCase(), password],
      limit: 1,
    );

    if (results.isEmpty) {
      throw Exception('Email atau password salah');
    }

    return Member.fromJson(results.first);
  }

  Future<void> initializeDefaultAdmin() async {
    final db = await DatabaseHelper.instance.database;

    // Check if admin exists
    final adminCheck = await db.query(
      tableName,
      where: 'email = ?',
      whereArgs: ['admin@admin.com'],
      limit: 1,
    );

    if (adminCheck.isEmpty) {
      // Create default admin if not exists
      await db.insert(tableName, {
        'id': '1',
        'name': 'Administrator',
        'email': 'admin@admin.com',
        'password': 'admin123', // In production, this should be hashed
        'phoneNumber': '08123456789',
        'address': 'Jl. Admin No. 1',
        'memberSince': DateTime.now().toIso8601String(),
        'borrowedBookIds': '[]',
      });
    }
  }
}
