import 'package:driving_license/features/chapters/domain/chapter.dart';
import 'package:driving_license/features/licenses/domain/license.dart';
import 'package:driving_license/features/questions/data/user_answer/user_answers_repository.dart';
import 'package:driving_license/features/questions/domain/question.dart';
import 'package:driving_license/features/questions/domain/user_answer.dart';
import 'package:driving_license/features/questions/domain/user_answers_map.dart';
import 'package:driving_license/features/questions/domain/user_answers_summary.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sembast/sembast.dart';

class SembastUserAnswersRepository implements UserAnswersRepository {
  SembastUserAnswersRepository(this.db);

  final Database db;
  final allAnswersStore = intMapStoreFactory.store('all_answers');

  @override
  Future<void> saveAnswer(
    Question question,
    int selectedAnswerIndex,
  ) async {
    final userAnswer = UserAnswer(
      questionMetadata: question.metadata,
      selectedAnswerIndex: selectedAnswerIndex,
    );

    await allAnswersStore
        .record(question.questionDbIndex)
        .put(db, userAnswer.toJson());
  }

  @override
  Future<void> clearAnswer(Question question) async {
    await allAnswersStore.record(question.questionDbIndex).delete(db);
  }

  @override
  Future<void> clearAllAnswers(
    License license, {
    Chapter? chapter,
    bool filterDangerAnswers = false,
  }) async {
    await allAnswersStore.delete(
      db,
      finder: Finder(
        filter: Filter.and([
          _licenseFilter(license),
          if (chapter != null) _chapterFilter(chapter),
          if (filterDangerAnswers) _dangerQuestionsFilter,
        ]),
      ),
    );
  }

  @override
  Future<void> clearDatabase() async {
    await allAnswersStore.delete(db);
  }

  @override
  Stream<int?> watchUserSelectedAnswerIndex(Question question) {
    final recordSnapshotStream =
        allAnswersStore.record(question.questionDbIndex).onSnapshot(db);

    return recordSnapshotStream.map((snapshot) {
      if (snapshot == null) {
        return null;
      }

      final userAnswerJson = snapshot.value as Map<String, dynamic>;
      final userAnswer = UserAnswer.fromJson(userAnswerJson);
      return userAnswer.selectedAnswerIndex;
    });
  }

  @override
  Future<UserAnswersMap> getAllAnswers(
    License license, {
    Chapter? chapter,
    bool filterWrongAnswers = false,
    bool filterDangerAnswers = false,
    bool filterDifficultAnswers = false,
  }) async {
    final recordSnapshot = await allAnswersStore.find(
      db,
      finder: Finder(
        filter: Filter.and([
          _licenseFilter(license),
          if (chapter != null) _chapterFilter(chapter),
          if (filterWrongAnswers) _wrongAnswersFilter,
          if (filterDangerAnswers) _dangerQuestionsFilter,
          if (filterDifficultAnswers) _difficultQuestionsFilter,
        ]),
      ),
    );

    return UserAnswersMap.fromUserAnswers(
      recordSnapshot.map(
        (record) => UserAnswer.fromJson(record.value as Map<String, dynamic>),
      ),
    );
  }

  @override
  Stream<UserAnswersSummary> watchUserAnswersSummary(
    License license, {
    Chapter? chapter,
    bool filterDangerAnswers = false,
  }) {
    final correctAnswersCountStream = allAnswersStore
        .query(
          finder: Finder(
            filter: Filter.and([
              _licenseFilter(license),
              _correctAnswersFilter,
              if (chapter != null) _chapterFilter(chapter),
              if (filterDangerAnswers) _dangerQuestionsFilter,
            ]),
          ),
        )
        .onCount(db);

    final wrongAnswersCountStream = allAnswersStore
        .query(
          finder: Finder(
            filter: Filter.and([
              _licenseFilter(license),
              _wrongAnswersFilter,
              if (chapter != null) _chapterFilter(chapter),
              if (filterDangerAnswers) _dangerQuestionsFilter,
            ]),
          ),
        )
        .onCount(db);

    final wrongAnswerIsDangerCountStream = allAnswersStore
        .query(
          finder: Finder(
            filter: Filter.and([
              _licenseFilter(license),
              _wrongAnswersFilter,
              _dangerQuestionsFilter,
              if (chapter != null) _chapterFilter(chapter),
            ]),
          ),
        )
        .onCount(db);

    return Rx.combineLatest3(
      correctAnswersCountStream,
      wrongAnswersCountStream,
      wrongAnswerIsDangerCountStream,
      (int correct, int wrong, int danger) {
        return UserAnswersSummary(
          correctAnswers: correct,
          wrongAnswers: wrong,
          wrongAnswersIsDanger: danger,
        );
      },
    );
  }

  @override
  Future<int?> getFirstUnansweredPositionInList(Iterable<int> dbIndexes) async {
    int location = -1;

    for (final dbIndex in dbIndexes) {
      location++;

      final recordSnapshot =
          await allAnswersStore.record(dbIndex).getSnapshot(db);

      if (recordSnapshot == null) {
        return location;
      }
    }

    return null;
  }

  @override
  Future<UserAnswersMap> getAnswersByQuestionDbIndexes(
    Iterable<int> dbIndexes,
  ) async {
    final recordSnapshot = await allAnswersStore.find(
      db,
      finder: Finder(
        filter: Filter.inList(
          'questionMetadata.questionDbIndex',
          dbIndexes.toList(),
        ),
      ),
    );

    return UserAnswersMap.fromUserAnswers(
      recordSnapshot.map(
        (record) => UserAnswer.fromJson(record.value as Map<String, dynamic>),
      ),
    );
  }
}

extension _FilterExtension on SembastUserAnswersRepository {
  Filter _chapterFilter(Chapter chapter) {
    return Filter.equals(
      'questionMetadata.chapterDbIndex',
      chapter.chapterDbIndex,
    );
  }

  Filter _licenseFilter(License license) {
    if (license == License.all) {
      return Filter.custom((_) => true);
    }

    return Filter.matches(
      'questionMetadata.includedLicenses',
      license.name,
      anyInList: true,
    );
  }

  Filter get _correctAnswersFilter {
    return Filter.custom((record) {
      return record['questionMetadata.correctAnswerIndex'] ==
          record['selectedAnswerIndex'];
    });
  }

  Filter get _wrongAnswersFilter {
    return Filter.not(_correctAnswersFilter);
  }

  Filter get _difficultQuestionsFilter {
    return Filter.equals('questionMetadata.isDifficult', true);
  }

  Filter get _dangerQuestionsFilter {
    return Filter.equals('questionMetadata.isDanger', true);
  }
}
