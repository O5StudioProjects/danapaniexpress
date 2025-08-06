

import 'package:danapaniexpress/core/common_imports.dart';

class FeedbackItemModel {

  final String titleUrdu;
  final String titleEnglish;
  final String icon;

  FeedbackItemModel(
      this.titleUrdu,
      this.titleEnglish,
      this.icon);

}

var feedbackItemList = [
  FeedbackItemModel('عمدہ', 'Excellent', icExcellent),
  FeedbackItemModel('بہت اچھا', 'Very Good', icGood),
  FeedbackItemModel('درمیانہ', 'Neutral', icNeutral),
  FeedbackItemModel('کمزور', 'Poor', icPoor),
  FeedbackItemModel('بہت کمزور', 'Very Poor', icVeryPoor),

];