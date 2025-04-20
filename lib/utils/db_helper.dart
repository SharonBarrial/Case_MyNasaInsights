import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:eb20242u202114900/models/PhotoInfo.dart';

class DbHelper {
  final int version = 1;
  Database? db;

  static final DbHelper _dbHelper = DbHelper._internal();

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> openDb() async {
    if (db == null) {
      db = await openDatabase(join(await getDatabasesPath(), 'universe11.db'),
          onCreate: (db, version) {
            db.execute(
                'CREATE TABLE photos('
                    'id INTEGER PRIMARY KEY, '
                    'imgSrc TEXT, '
                    'earthDate TEXT, '
                    'roverName TEXT, '
                    'cameraName TEXT, '
                    'isFavorite INTEGER)');
          }, version: version);
    }
    return db!;
  }

  Future<int> insertPhoto(PhotoInfo photo) async {
    int id = await db!.insert('photos', photo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<int> deletePhoto(PhotoInfo photo) async {
    int result =
    await db!.delete('photos', where: 'id = ?', whereArgs: [photo.id]);
    return result;
  }

  Future<int> editPhoto(PhotoInfo photo) async {
    int result = await db!.update('photos', photo.toMap(),
        where: 'id = ?', whereArgs: [photo.id]);
    return result;
  }

  Future<bool> isFavorite(PhotoInfo photo) async {
    final List<Map<String, dynamic>> maps =
    await db!.query('photos', where: 'id = ?', whereArgs: [photo.id]);
    return maps.isNotEmpty && maps[0]['isFavorite'] == 1;
  }

  Future<void> updateFavoriteStatus(PhotoInfo photo, bool isFavorite) async {
    await db!.update(
      'photos',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [photo.id],
    );
  }

  Future<List<PhotoInfo>> getFavorites() async {
    final List<Map<String, dynamic>> maps = await db!.query('photos',
      where: 'isFavorite = ?',
      whereArgs: [1],
    );
    print('Photos fetched: $maps');

    return List.generate(maps.length, (i) {
      return PhotoInfo(
        maps[i]['id'],
        maps[i]['imgSrc'],
        maps[i]['earthDate'],
        maps[i]['roverName'],
        maps[i]['cameraName'],
        maps[i]['isFavorite'] == 1,
      );
    });
  }
}