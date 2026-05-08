import 'package:sqflite/sqflite.dart' as sql;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';




class AppDatabase {
  
  AppDatabase() {
    database();
  }




  Future<void> createVerbsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS verbs (
        local_id TEXT PRIMARY KEY,        -- UUID (local primary key)

        id INTEGER UNIQUE,                       -- backend ID

        english TEXT NOT NULL,
        japanese TEXT NOT NULL,

        present TEXT NOT NULL,
        past TEXT NOT NULL,
        negative TEXT NOT NULL,

        polite_present TEXT NOT NULL,
        polite_negative TEXT NOT NULL,
        polite_past TEXT NOT NULL,
        polite_past_negative TEXT NOT NULL,

        te_form TEXT NOT NULL,
        volitional TEXT NOT NULL,

        created_at TEXT NOT NULL,         -- ISO8601 string
        updated_at TEXT NOT NULL
      );
    ''');
  }


  Future<void> addNewColumns(Database db) async {
    // try {
    //   await db.execute('ALTER TABLE quest ADD COLUMN start_location_lat REAL;');
    // } catch (e) {
    //   logError('The "start_location_lat" column already exists in the quest table. Skipping...');
    // }

  }


  Future<void> createTables(Database db) async {

    await createVerbsTable(db);
    //For updating my database, remove in production
    //await addNewColumns(db);
  }

  // Future<void> purgeAppData() async {
  //   final db = await database();
  // }

  Future<Database> database() async {  
    final dbPath = await sql.getDatabasesPath();
    
    return await sql.openDatabase(
      path.join(dbPath,'verbs.db'),
      onCreate: (db, version) async {
        await createTables(db);
      },
      version: 1,
      onConfigure: _onConfigure
    );
  }

    //Enables foreign keys to work
    static Future _onConfigure(Database db) async {
      await db.execute('PRAGMA foreign_keys = ON');
      await db.execute('PRAGMA auto_vacuum=FULL');
    }

  Future<void> purgeAppData() async {
    final db = await database();

    // await db.execute("DELETE FROM quest");
    // await db.execute("DELETE FROM cats");
    await db.execute("DELETE FROM verbs");
  }


    Future<Map<String,dynamic>> insertVerb(Map<String, dynamic> verb) async {
      final db = await database();
      final localId = Uuid().v4();

      Map<String,dynamic> row =         {
        'local_id': localId,
        'id': verb['id'],
        'english': verb['english'],
        'japanese': verb['japanese'],
        'present': verb['present'],
        'past': verb['past'],
        'negative': verb['negative'],
        'polite_present': verb['polite_present'],
        'polite_negative': verb['polite_negative'],
        'polite_past': verb['polite_past'],
        'polite_past_negative': verb['polite_past_negative'],
        'te_form': verb['te_form'],
        'volitional': verb['volitional'],
        'created_at': verb['created_at'],
        'updated_at': verb['updated_at'],
      };

      await db.insert(
        'verbs',
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return row;
    }

  Future<void> insertVerbsBatch(List<Map<String, dynamic>> verbs) async {
    final db = await database();

    //await createTables(db);

    final batch = db.batch();

    for (final verb in verbs) {
      batch.insert(
        'verbs',
        {
          'local_id': Uuid().v4(),
          'id': verb['id'],
          'english': verb['english'],
          'japanese': verb['japanese'],
          'present': verb['present'],
          'past': verb['past'],
          'negative': verb['negative'],
          'polite_present': verb['polite_present'],
          'polite_negative': verb['polite_negative'],
          'polite_past': verb['polite_past'],
          'polite_past_negative': verb['polite_past_negative'],
          'te_form': verb['te_form'],
          'volitional': verb['volitional'],
          'created_at': verb['created_at'],
          'updated_at': verb['updated_at'],
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getAllVerbsRaw() async {
    final db = await database();

    return await db.query('verbs', orderBy: 'id ASC');
  }


  Future<String?> getLatestUpdatedAt() async {
    final db = await database();

    // We only need the updated_at column from the top row
    final List<Map<String, dynamic>> maps = await db.query(
      'verbs',
      columns: ['updated_at'],
      orderBy: 'updated_at DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return maps.first['updated_at'] as String;
    }

    // return null; // Table is empty
    return null;
  }



}


