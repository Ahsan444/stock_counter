
class SurveyModel {
  final String surveyName,createdAt;
  final int? surveyId;

  SurveyModel({
    required this.surveyName,
    required this.createdAt,
    this.surveyId,
  });
}