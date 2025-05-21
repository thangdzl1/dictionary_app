import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'dictionary.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE dictionary (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      word TEXT NOT NULL,
      definition TEXT NOT NULL
    )
  ''');

    // Thêm nhiều dữ liệu tiếng Anh - dịch nghĩa tiếng Việt
    final entries = [
      {'word': 'hello', 'definition': 'Xin chào'},
      {'word': 'world', 'definition': 'Thế giới'},
      {'word': 'flutter', 'definition': 'Bộ công cụ giao diện người dùng do Google phát triển'},
      {'word': 'computer', 'definition': 'Máy tính'},
      {'word': 'apple', 'definition': 'Quả táo'},
      {'word': 'banana', 'definition': 'Quả chuối'},
      {'word': 'car', 'definition': 'Xe hơi'},
      {'word': 'train', 'definition': 'Tàu hỏa'},
      {'word': 'teacher', 'definition': 'Giáo viên'},
      {'word': 'student', 'definition': 'Học sinh, sinh viên'},
      {'word': 'school', 'definition': 'Trường học'},
      {'word': 'book', 'definition': 'Cuốn sách'},
      {'word': 'language', 'definition': 'Ngôn ngữ'},
      {'word': 'dictionary', 'definition': 'Từ điển'},
      {'word': 'love', 'definition': 'Tình yêu'},
      {'word': 'happy', 'definition': 'Hạnh phúc'},
      {'word': 'sad', 'definition': 'Buồn bã'},
      {'word': 'rain', 'definition': 'Mưa'},
      {'word': 'sun', 'definition': 'Mặt trời'},
      {'word': 'moon', 'definition': 'Mặt trăng'},
    ];

    for (var entry in entries) {
      await db.insert('dictionary', entry);
    }
  }

  Future<List<Map<String, dynamic>>> search(String text) async {
    final db = await database;

    final exactMatch = await db.query(
      'dictionary',
      where: 'word = ?',
      whereArgs: [text],
    );

    if (exactMatch.isNotEmpty) {
      return exactMatch;
    }

    // Nếu không có từ khớp hoàn toàn → tìm theo substring
    return await db.query(
      'dictionary',
      where: 'word LIKE ?',
      whereArgs: ['%$text%'],
    );
  }
}
