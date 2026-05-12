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


  Future<void> createVerbExampleTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS verb_examples (
        id TEXT PRIMARY KEY,        -- UUID (local primary key)
        verb_id TEXT NOT NULL,
        form_type TEXT NOT NULL,

        romaji TEXT NOT NULL,
        english TEXT NOT NULL,

        created_at TEXT NOT NULL,         -- ISO8601 string
        updated_at TEXT NOT NULL,
        FOREIGN KEY (verb_id)
          REFERENCES verbs(local_id)
          ON DELETE CASCADE,

        UNIQUE(romaji)
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
    //await db.execute("DROP TABLE verb_examples;");
    await createVerbExampleTable(db);
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

    await createTables(db);

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



  Future<Map<String,dynamic>> insertVerbExample(Map<String, dynamic> verbExample) async {
    final db = await database();
    final localId = Uuid().v4();

    Map<String,dynamic> row =         {
      'id': localId,
      'verb_id': verbExample['verbExampleId'],
      'form_type': verbExample['form_type'],
      'romaji': verbExample['romaji'],
      'english': verbExample['english'],
      'created_at': verbExample['created_at'],
      'updated_at': verbExample['updated_at'],
    };

    await db.insert(
      'verb_examples',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return row;
  }


  Future<List<Map<String, dynamic>>> getAllVerbExamplesRaw() async {
    final db = await database();

    return await db.query('verb_examples', orderBy: 'id ASC');
  }

  Future<List<Map<String, dynamic>>> getVerbExamplesByIdRaw(localId) async {
    final db = await database();

    return await db.query(
      'verb_examples', 
      where: "verb_id=?",
      whereArgs: [localId]
    );
  }

  Future<Map<String, dynamic>?> getVerbExampleByIdAndForm(String localId, String form) async {
    final db = await database();
    List<Map<String,dynamic>> result = await db.query(
      'verb_examples', 
      where: "verb_id = ? AND form_type = ?",
      whereArgs: [localId,form]
    );
    if(result.isNotEmpty) {
      return result[0];
    } else {
      return null;
    }
  }


}


