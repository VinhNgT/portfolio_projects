import 'package:driving_license/features/questions/data/user_answer/user_answers_repository.dart';
import 'package:driving_license/features/questions/domain/question.dart';
import 'package:driving_license/features/questions/domain/user_answer.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

part 'sembast_user_answers_repository.g.dart';

class SembastUserAnswersRepository implements UserAnswersRepository {
  SembastUserAnswersRepository(this.db);

  final Database db;
  final allAnswersStore = intMapStoreFactory.store('all_answers');
  final answeredWrongStore = intMapStoreFactory.store('answered_wrong');

  static Future<SembastUserAnswersRepository> makeDefault() async {
    return SembastUserAnswersRepository(
      await _createDatabase('user_answers.db'),
    );
  }

  static Future<Database> _createDatabase(String filename) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    return databaseFactoryIo.openDatabase(join(appDocDir.path, filename));
  }

  @override
  Future<void> saveUserAnswer(
    Question question,
    int selectedAnswerIndex,
  ) async {
    final userAnswer = UserAnswer(
      questionDbIndex: question.questionDbIndex,
      selectedAnswerIndex: selectedAnswerIndex,
    );

    await db.transaction((txn) async {
      await allAnswersStore
          .record(question.questionDbIndex)
          .put(txn, userAnswer.toJson());

      if (question.correctAnswerIndex != selectedAnswerIndex) {
        await answeredWrongStore
            .record(question.questionDbIndex)
            .put(txn, userAnswer.toJson());
      }
    });
  }

  @override
  Future<void> deleteUserAnswer(Question question) async {
    await allAnswersStore.record(question.questionDbIndex).delete(db);
    await answeredWrongStore.record(question.questionDbIndex).delete(db);
  }

  @override
  Future<void> deleteAllUserAnswers() async {
    await allAnswersStore.delete(db);
    await answeredWrongStore.delete(db);
  }

  @override
  Stream<int?> watchUserSelectedAnswerIndex(Question question) {
    final recordSnapshot =
        allAnswersStore.record(question.questionDbIndex).onSnapshot(db);

    return recordSnapshot.map((snapshot) {
      if (snapshot == null) {
        return null;
      }

      final userAnswerJson = snapshot.value as Map<String, dynamic>;
      final userAnswer = UserAnswer.fromJson(userAnswerJson);
      return userAnswer.selectedAnswerIndex;
    });
  }

  @override
  Future<List<UserAnswer>> getAllWrongAnswers() {
    return answeredWrongStore.find(db).then((records) {
      return records
          .map((e) => UserAnswer.fromJson(e.value as Map<String, dynamic>))
          .toList();
    });
  }

  // Stream<List<UserAnswer>> watchAllWrongAnswers() {
  //   final recordSnapshot = answeredWrongStore.query().onSnapshots(db);

  //   return recordSnapshot.map((snapshot) {
  //     return snapshot
  //         .map((e) => UserAnswer.fromJson(e.value as Map<String, dynamic>))
  //         .toList();
  //   });
  // }
}

@Riverpod(keepAlive: true)
SembastUserAnswersRepository sembastUserAnswersRepository(
  SembastUserAnswersRepositoryRef ref,
) {
  //* Override this in the main method to select the correct implementation
  throw UnimplementedError();
}
