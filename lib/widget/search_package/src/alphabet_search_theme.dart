// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

class AlphabetSearchConfig {
  AlphabetSearchConfig._internal({
    required this.withSearch,
    required this.titleTextStyle,
    required this.subtitleTextStyle,
    required this.letterHeaderTextStyle,
    this.dividerThickness = 1,
    required this.color,
    required this.backgroundColor,
  });

  final bool withSearch;
  final TextStyle titleTextStyle;
  final TextStyle subtitleTextStyle;
  final TextStyle letterHeaderTextStyle;
  final double dividerThickness;
  final Color color;
  final Color backgroundColor;

  factory AlphabetSearchConfig.fromContext(
    BuildContext context, {
    bool withSearch = true,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    TextStyle? letterHeaderTextStyle,
    double? dividerThickness,
    Color? color,
    Color? backgroundColor,
  }) {
    final _color = color ?? _defaultColor(context);
    return AlphabetSearchConfig._internal(
      withSearch: withSearch,
      titleTextStyle: titleStyle ?? _defaultTitleTextStyle(context),
      subtitleTextStyle: subtitleStyle ?? _defaultSubtitleTextStyle(context),
      letterHeaderTextStyle: letterHeaderTextStyle ??
          _defaultLetterHeaderTextStyle(
            context,
            color: _color,
          ),
      dividerThickness: dividerThickness ?? 1,
      backgroundColor: backgroundColor ?? _defaultBackgroundColor(context),
      color: _color,
    );
  }

  factory AlphabetSearchConfig.fromDefault(BuildContext context) {
    return AlphabetSearchConfig.fromContext(context);
  }

  static TextStyle _defaultTitleTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.subtitle1 ??
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        );
  }

  static TextStyle _defaultSubtitleTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyText2 ??
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        );
  }

  static TextStyle _defaultLetterHeaderTextStyle(
    BuildContext context, {
    required Color color,
  }) {
    return Theme.of(context).textTheme.headline2?.copyWith(color: color) ??
        TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: color);
  }

  static Color _defaultColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  static Color _defaultBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }
}
