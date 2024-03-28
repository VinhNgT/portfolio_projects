import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:driving_license/features/chapters/domain/chapter.dart';
import 'package:driving_license/features/licenses/domain/license.dart';
import 'package:driving_license/features/questions/data/question/k_test_questions.dart';
import 'package:driving_license/features/questions/data/question/questions_repository.dart';
import 'package:driving_license/features/questions/domain/question.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// This value must match the PRAGMA user_version of the database in the assets
/// otherwise an Exception will be thrown
const _dataBaseUserVersionConst = 2;

class SqliteQuestionsRepository implements QuestionsRepository {
  final Database database;
  SqliteQuestionsRepository(this.database);

  static Future<SqliteQuestionsRepository> makeDefault() async {
    return SqliteQuestionsRepository(await _initDatabase());
  }

  static Future<Database> _initDatabase() async {
    final databasesDir = await getDatabasesPath();
    final dbPath = join(databasesDir, 'questions.db');

    // Check if the database exists
    final exists = await databaseExists(dbPath);

    // If the database doesn't exist, create a new copy from the asset
    if (!exists) {
      debugPrint(
        'Database does not exist, creating new database copy from asset',
      );
      await _createNewDbFromAsset(dbPath);
      return openDatabase(dbPath, readOnly: true);
    }

    // Check if the database is outdated
    final userVersion = await _getDbUserVersion(dbPath);
    if (userVersion != _dataBaseUserVersionConst) {
      debugPrint(
        'Existing database is outdated, creating new database copy '
        'from asset',
      );
      await _createNewDbFromAsset(dbPath);
      return openDatabase(dbPath, readOnly: true);
    }

    // Open the database
    debugPrint('Opening existing database');
    return openDatabase(dbPath, readOnly: true);
  }

  static Future<int> _getDbUserVersion(String dbPath) async {
    final db = await openDatabase(dbPath, readOnly: true);
    final version = await db.getVersion();
    await db.close();
    return version;
  }

  static Future<void> _createNewDbFromAsset(String dbPath) async {
    // Make sure the parent directory exists
    try {
      await Directory(dirname(dbPath)).create(recursive: true);
    } catch (_) {
      debugPrint('Failed to create database directory');
    }

    // Delete the old database if it exists
    if (await File(dbPath).exists()) {
      await File(dbPath).delete();
    }

    // Copy from asset
    final ByteData data = await rootBundle.load(join('assets', 'questions.db'));
    final List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write and flush the bytes written
    await File(dbPath).writeAsBytes(bytes, flush: true);

    // Check the user_version of the database
    final dbVersion = await _getDbUserVersion(dbPath);
    if (dbVersion != _dataBaseUserVersionConst) {
      throw Exception('The database\'s user_version from asset does not match '
          'the expected value \'$_dataBaseUserVersionConst\'');
    }
  }

  @override
  Future<Question> get(int index) async {
    return getByDbIndex(index + 1);
  }

  @override
  Future<Question> getByDbIndex(int dbIndex) async {
    final List<Map<String, dynamic>> queryResult = await database.query(
      'question',
      where: 'question_index = ?',
      whereArgs: [dbIndex],
    );

    if (queryResult.isNotEmpty) {
      final questionMap =
          convertDatabaseMapToQuestionObjectMap(queryResult.first);
      return Question.fromJson(questionMap);
    } else {
      throw Exception('question_index $dbIndex not found');
    }
  }

  @override
  Future<int> getCount() async {
    final List<Map<String, dynamic>> queryResult =
        await database.rawQuery('SELECT COUNT(*) AS count FROM question');
    return queryResult.first['count'] as int;
  }

  @override
  Future<List<Question>> getPage(int pageNumber) async {
    final List<Map<String, dynamic>> queryResult = await database.query(
      'question',
      orderBy: 'question_index ASC',
      limit: QuestionsRepository.pageSize,
      offset: pageNumber * QuestionsRepository.pageSize,
    );

    return [
      for (final questionMap in queryResult)
        Question.fromJson(convertDatabaseMapToQuestionObjectMap(questionMap)),
    ];
  }

  @override
  Future<Question> getByLicenseAndChapter(
    License license,
    Chapter chapter,
    int index,
  ) async {
    final chapterQuestionOffset = await database
        .query(
          'question',
          where: 'chapter_index = ?'._addLicenseWhereClause(license),
          whereArgs: [chapter.chapterDbIndex],
          orderBy: 'question_index ASC',
          limit: 1,
        )
        .then((value) => value.first['question_index'] as int);

    final List<Map<String, dynamic>> queryResult = await database.query(
      'question',
      where: 'chapter_index = ? AND question_index = ?'
          ._addLicenseWhereClause(license),
      whereArgs: [chapter.chapterDbIndex, chapterQuestionOffset + index],
    );

    if (queryResult.isNotEmpty) {
      final questionMap =
          convertDatabaseMapToQuestionObjectMap(queryResult.first);
      return Question.fromJson(questionMap);
    } else {
      throw Exception('question_index ${index + 1} not found');
    }
  }

  @override
  Future<List<Question>> getPageByLicenseAndChapter(
    License license,
    Chapter chapter,
    int pageNumber,
  ) async {
    final List<Map<String, dynamic>> queryResult = await database.query(
      'question',
      where: 'chapter_index = ?'._addLicenseWhereClause(license),
      whereArgs: [chapter.chapterDbIndex],
      orderBy: 'question_index ASC',
      limit: QuestionsRepository.pageSize,
      offset: pageNumber * QuestionsRepository.pageSize,
    );

    return [
      for (final questionMap in queryResult)
        Question.fromJson(convertDatabaseMapToQuestionObjectMap(questionMap)),
    ];
  }

  @override
  Future<int> getCountByLicenseAndChapter(
    License license,
    Chapter chapter,
  ) async {
    final List<Map<String, dynamic>> queryResult = await database.rawQuery(
      'SELECT COUNT(*) AS count FROM question WHERE '
      '${'chapter_index = ?'._addLicenseWhereClause(license)}',
      [chapter.chapterDbIndex],
    );
    return queryResult.first['count'] as int;
  }

  @override
  FutureOr<Question> getIsDangerByLicense(License license, int index) async {
    final List<Map<String, dynamic>> queryResult = await database.query(
      'question',
      where: 'is_danger = 1'._addLicenseWhereClause(license),
      orderBy: 'question_index ASC',
      offset: index,
      limit: 1,
    );

    if (queryResult.isNotEmpty) {
      final questionMap =
          convertDatabaseMapToQuestionObjectMap(queryResult.first);
      return Question.fromJson(questionMap);
    } else {
      throw Exception('is_danger question_index $index not found');
    }
  }

  @override
  FutureOr<List<Question>> getIsDangerPageByLicense(
    License license,
    int pageNumber,
  ) async {
    final List<Map<String, dynamic>> queryResult = await database.query(
      'question',
      where: 'is_danger = 1'._addLicenseWhereClause(license),
      orderBy: 'question_index ASC',
      limit: QuestionsRepository.pageSize,
      offset: pageNumber * QuestionsRepository.pageSize,
    );

    return [
      for (final questionMap in queryResult)
        Question.fromJson(convertDatabaseMapToQuestionObjectMap(questionMap)),
    ];
  }

  @override
  FutureOr<int> getIsDangerCountByLicense(License license) async {
    final List<Map<String, dynamic>> queryResult = await database.rawQuery(
      'SELECT COUNT(*) AS count FROM question WHERE '
      '${'is_danger = 1'._addLicenseWhereClause(license)}',
    );
    return queryResult.first['count'] as int;
  }

  @override
  FutureOr<Question> getIsDifficultByLicense(License license, int index) async {
    final List<Map<String, dynamic>> queryResult = await database.query(
      'question',
      where: 'is_difficult = 1'._addLicenseWhereClause(license),
      orderBy: 'question_index ASC',
      offset: index,
      limit: 1,
    );

    if (queryResult.isNotEmpty) {
      final questionMap =
          convertDatabaseMapToQuestionObjectMap(queryResult.first);
      return Question.fromJson(questionMap);
    } else {
      throw Exception('is_difficult question_index $index not found');
    }
  }

  @override
  FutureOr<List<Question>> getIsDifficultPageByLicense(
    License license,
    int pageNumber,
  ) async {
    final List<Map<String, dynamic>> queryResult = await database.query(
      'question',
      where: 'is_difficult = 1'._addLicenseWhereClause(license),
      orderBy: 'question_index ASC',
      limit: QuestionsRepository.pageSize,
      offset: pageNumber * QuestionsRepository.pageSize,
    );

    return [
      for (final questionMap in queryResult)
        Question.fromJson(convertDatabaseMapToQuestionObjectMap(questionMap)),
    ];
  }

  @override
  FutureOr<int> getIsDifficultCountByLicense(License license) async {
    final List<Map<String, dynamic>> queryResult = await database.rawQuery(
      'SELECT COUNT(*) AS count FROM question WHERE '
      '${'is_difficult = 1'._addLicenseWhereClause(license)}',
    );
    return queryResult.first['count'] as int;
  }

  @override
  FutureOr<List<Question>> getPageByDbIndexes(
    Iterable<int> dbIndexes,
    int pageNumber,
  ) async {
    final List<Map<String, dynamic>> queryResult = await database.query(
      'question',
      where: 'question_index IN (${dbIndexes.join(', ')})',
      orderBy: 'question_index ASC',
      limit: QuestionsRepository.pageSize,
      offset: pageNumber * QuestionsRepository.pageSize,
    );

    return [
      for (final questionMap in queryResult)
        Question.fromJson(convertDatabaseMapToQuestionObjectMap(questionMap)),
    ];
  }
}

extension QuestionsRepositoryX on QuestionsRepository {
  Map<String, dynamic> convertDatabaseMapToQuestionObjectMap(
    Map<String, dynamic> databaseMap,
  ) {
    return {
      'questionDbIndex': databaseMap['question_index'],
      'chapterDbIndex': databaseMap['chapter_index'],
      'title': databaseMap['question_text'],
      'questionImagePath': databaseMap['question_image'] == null
          ? null
          : join('assets/images', databaseMap['question_image']),
      'answers': jsonDecode(databaseMap['answers']),
      'correctAnswerIndex': databaseMap['correct_index'] - 1,
      'isDanger': databaseMap['is_danger'] == 1,
      'isDifficult': databaseMap['is_difficult'] == 1,
      'explanation': kTestQuestions[0].explanation,
      'rememberTip': kTestQuestions[0].rememberTip,
      'includedLicenses': [
        for (final license in License.values)
          if (databaseMap['is_in_${license.name}'] == 1) license.name,
      ],
    };
  }
}

extension _WhereClauseExtenstion on String {
  String _addLicenseWhereClause(License license) {
    if (license == License.all) {
      return this;
    }

    final buffer = StringBuffer('($this)');
    buffer.write(' AND is_in_${license.name} = 1');

    return buffer.toString();
  }
}
