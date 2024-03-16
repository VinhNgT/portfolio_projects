import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_answer.freezed.dart';
part 'user_answer.g.dart';

@freezed
abstract class UserAnswer with _$UserAnswer {
  factory UserAnswer({
    required int questionDbIndex,
    required int selectedAnswerIndex,
  }) = _UserAnswer;

  factory UserAnswer.fromJson(Map<String, dynamic> json) =>
      _$UserAnswerFromJson(json);
}