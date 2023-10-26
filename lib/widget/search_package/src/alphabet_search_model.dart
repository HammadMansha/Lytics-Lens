import 'package:lytics_lens/widget/search_package/src/constants.dart';

class AlphabetSearchModel {
  AlphabetSearchModel({
    required this.title,
    this.subtitle,
  }) : letter = LetterCharExt.fromString(title);

  final String title;
  final String? subtitle;
  final LetterChar letter;
}
