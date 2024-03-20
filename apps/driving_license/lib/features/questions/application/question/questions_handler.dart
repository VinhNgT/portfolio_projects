import 'dart:async';

import 'package:collection/collection.dart';
import 'package:driving_license/features/chapters/domain/chapter.dart';
import 'package:driving_license/features/questions/data/question/questions_repository.dart';
import 'package:driving_license/features/questions/domain/question.dart';

abstract class QuestionsHandler {
  FutureOr<Question> getQuestion(int questionIndex);
  FutureOr<List<Question>> getQuestionsPage(int pageIndex);
  FutureOr<int> getQuestionCount();
}

class FullQuestionsHandler implements QuestionsHandler {
  FullQuestionsHandler({required this.questionsRepository});
  final QuestionsRepository questionsRepository;

  @override
  FutureOr<Question> getQuestion(int questionIndex) {
    return questionsRepository.getQuestion(questionIndex);
  }

  @override
  FutureOr<List<Question>> getQuestionsPage(int pageIndex) {
    return questionsRepository.getQuestionsPage(pageIndex);
  }

  @override
  FutureOr<int> getQuestionCount() {
    return questionsRepository.getQuestionCount();
  }
}

class ChapterQuestionsHandler implements QuestionsHandler {
  ChapterQuestionsHandler({
    required this.questionsRepository,
    required this.chapter,
  });
  final QuestionsRepository questionsRepository;
  final Chapter chapter;

  @override
  FutureOr<Question> getQuestion(int questionIndex) {
    return questionsRepository.getQuestionByChapter(chapter, questionIndex);
  }

  @override
  FutureOr<List<Question>> getQuestionsPage(int pageIndex) {
    return questionsRepository.getQuestionsPageByChapter(chapter, pageIndex);
  }

  @override
  FutureOr<int> getQuestionCount() {
    return questionsRepository.getQuestionCountByChapter(chapter);
  }
}

class CustomQuestionListQuestionHandler implements QuestionsHandler {
  CustomQuestionListQuestionHandler({
    required this.questionsRepository,
    required this.sortedQuestionDbIndexes,
  }) : assert(sortedQuestionDbIndexes.isSorted((a, b) => a - b));

  final QuestionsRepository questionsRepository;
  final List<int> sortedQuestionDbIndexes;

  @override
  FutureOr<Question> getQuestion(int questionIndex) {
    return questionsRepository
        .getQuestionByDbIndex(sortedQuestionDbIndexes[questionIndex]);
  }

  @override
  FutureOr<List<Question>> getQuestionsPage(int pageIndex) {
    return questionsRepository.getQuestionsPageByDbIndexes(
      sortedQuestionDbIndexes,
      pageIndex,
    );
  }

  @override
  FutureOr<int> getQuestionCount() {
    return Future.value(sortedQuestionDbIndexes.length);
  }
}
