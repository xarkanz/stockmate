import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'product.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'inventory.db');
    return await openDatabase(
      path,
      version: 2, // Naikkan versi dari 1 ke 2
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE products (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          barcode TEXT UNIQUE NOT NULL,
          description TEXT,
          category TEXT,
          imagePath TEXT,
          dateAdded TEXT NOT NULL,
          quantity INTEGER DEFAULT 0
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE products ADD COLUMN quantity INTEGER DEFAULT 0',
          );
        }
      },
    );
  }

  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      orderBy: 'dateAdded DESC',
    );

    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<Product?> getProductByBarcode(String barcode) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'products',
      where: 'barcode = ?',
      whereArgs: [barcode],
    );

    if (result.isNotEmpty) {
      return Product.fromMap(result.first);
    }
    return null;
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getTotalStock() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as total FROM products');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getTotalStockByCategory(String category) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM products WHERE category = ?',
      [category],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Product>> getRecentProducts(int limit) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      orderBy: 'dateAdded DESC',
      limit: limit,
    );
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }
}
