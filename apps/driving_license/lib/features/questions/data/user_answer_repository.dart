import 'package:driving_license/features/questions/domain/user_answer.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

part 'user_answer_repository.g.dart';

class UserAnswerRepository {
  UserAnswerRepository(this.db);

  final Database db;
  final allAnswersStore = intMapStoreFactory.store('all_answers');

  static Future<UserAnswerRepository> makeDefault() async {
    return UserAnswerRepository(await _createDatabase('user_answers.db'));
  }

  static Future<Database> _createDatabase(String filename) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    return databaseFactoryIo.openDatabase(join(appDocDir.path, filename));
  }

  Future<void> saveUserAnswer(
    Question question,
    int selectedAnswerIndex,
  ) async {
    final userAnswer = UserAnswer(
      questionDbIndex: question.questionDbIndex,
      selectedAnswerIndex: selectedAnswerIndex,
    );

    await allAnswersStore
        .record(question.questionDbIndex)
        .put(db, userAnswer.toJson());
  }

  Future<void> deleteUserAnswer(Question question) async {
    await allAnswersStore.record(question.questionDbIndex).delete(db);
  }

  Future<void> deleteAllUserAnswers() async {
    await allAnswersStore.delete(db);
  }

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
}

@Riverpod(keepAlive: true)
UserAnswerRepository userAnswerRepository(UserAnswerRepositoryRef ref) {
  //* Override this in the main method to select the correct implementation
  throw UnimplementedError();
}
