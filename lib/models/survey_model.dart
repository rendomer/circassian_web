class Survey {
  final String id;
  final String title;
  final String description;
  final bool isActive; // ← добавлено!
  final List<SurveyQuestion> questions;

  Survey({
    required this.id,
    required this.title,
    required this.description,
    required this.isActive,
    required this.questions,
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isActive: json['is_active'] ?? true, // ← добавлено!
      questions: (json['questions'] as List<dynamic>? ?? [])
          .map((q) => SurveyQuestion.fromJson(q))
          .toList(),
    );
  }
}

class SurveyQuestion {
  final String id;
  final String questionText;
  final List<SurveyAnswer> answers;

  SurveyQuestion({
    required this.id,
    required this.questionText,
    required this.answers,
  });

  factory SurveyQuestion.fromJson(Map<String, dynamic> json) {
    return SurveyQuestion(
      id: json['id'] ?? '',
      questionText: json['question_text'] ?? '',
      answers: (json['answers'] as List<dynamic>? ?? [])
          .map((a) => SurveyAnswer.fromJson(a))
          .toList(),
    );
  }
}

class SurveyAnswer {
  final String id;
  final String answerText;
  int votes;

  SurveyAnswer({
    required this.id,
    required this.answerText,
    this.votes = 0,
  });

  factory SurveyAnswer.fromJson(Map<String, dynamic> json) {
    return SurveyAnswer(
      id: json['id'] ?? '',
      answerText: json['answer_text'] ?? '',
      votes: json['votes'] ?? 0,
    );
  }
}

class SurveyResults {
  final String surveyTitle;
  final List<QuestionResults> results;

  SurveyResults({
    required this.surveyTitle,
    required this.results,
  });

  factory SurveyResults.fromJson(Map<String, dynamic> json) {
    return SurveyResults(
      surveyTitle: json['survey_title'] ?? '',
      results: (json['results'] as List<dynamic>? ?? [])
          .map((q) => QuestionResults.fromJson(q))
          .toList(),
    );
  }
}

class QuestionResults {
  final String question;
  final List<AnswerResult> answers;

  QuestionResults({
    required this.question,
    required this.answers,
  });

  factory QuestionResults.fromJson(Map<String, dynamic> json) {
    return QuestionResults(
      question: json['question'] ?? '',
      answers: (json['answers'] as List<dynamic>? ?? [])
          .map((a) => AnswerResult.fromJson(a))
          .toList(),
    );
  }
}

class AnswerResult {
  final String answer;
  final int count;

  AnswerResult({
    required this.answer,
    required this.count,
  });

  factory AnswerResult.fromJson(Map<String, dynamic> json) {
    return AnswerResult(
      answer: json['answer'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}
