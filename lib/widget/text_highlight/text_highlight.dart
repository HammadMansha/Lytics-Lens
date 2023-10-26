// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'dart:math';

class TextHighlighting extends StatelessWidget {
  //DynamicTextHighlighting
  final String text;
  final List<String> highlights;
  final Color color;
  final TextStyle style;
  final bool caseSensitive;

  //RichText
  final TextAlign textAlign;

  final TextOverflow overflow;
  final double textScaleFactor;

  final TextWidthBasis textWidthBasis;

  const TextHighlighting({
    //DynamicTextHighlighting
    Key? key,
    required this.text,
    required this.highlights,
    this.color = Colors.orange,
    this.style = const TextStyle(
      color: Colors.black,
    ),
    this.caseSensitive = true,

    //RichText
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.textWidthBasis = TextWidthBasis.parent,
  })  : assert(text != null),
        assert(highlights != null),
        assert(color != null),
        assert(style != null),
        assert(caseSensitive != null),
        assert(textAlign != null),
        assert(overflow != null),
        assert(textScaleFactor != null),
        assert(textWidthBasis != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    //Controls
    if (text == '') {
      return _richText(_normalSpan(text));
    }
    if (highlights.isEmpty) {
      return _richText(_normalSpan(text));
    }
    for (int i = 0; i < highlights.length; i++) {
      if (highlights[i] == null) {
        assert(highlights[i] != null);
        return _richText(_normalSpan(text));
      }
      if (highlights[i].isEmpty) {
        assert(highlights[i].isNotEmpty);
        return _richText(_normalSpan(text));
      }
    }

    //Main code
    List<TextSpan> spans = [];
    int start = 0;

    //For "No Case Sensitive" option
    String lowerCaseText = text.toLowerCase();
    List<String> lowerCaseHighlights = [];

    for (var element in highlights) {
      lowerCaseHighlights.add(element.toLowerCase());
    }

    while (true) {
      Map<int, String> highlightsMap = {}; //key (index), value (highlight).

      if (caseSensitive) {
        for (int i = 0; i < highlights.length; i++) {
          int index = text.indexOf(highlights[i], start);
          if (index >= 0) {
            highlightsMap.putIfAbsent(index, () => highlights[i]);
          }
        }
      } else {
        for (int i = 0; i < highlights.length; i++) {
          int index = lowerCaseText.indexOf(lowerCaseHighlights[i], start);
          if (index >= 0) {
            highlightsMap.putIfAbsent(index, () => highlights[i]);
          }
        }
      }

      if (highlightsMap.isNotEmpty) {
        List<int> indexes = [];
        highlightsMap.forEach((key, value) => indexes.add(key));

        int currentIndex = indexes.reduce(min);
        String currentHighlight = text.substring(
            currentIndex, currentIndex + highlightsMap[currentIndex]!.length);

        if (currentIndex == start) {
          spans.add(_highlightSpan(currentHighlight));
          start += currentHighlight.length;
        } else {
          spans.add(_normalSpan(text.substring(start, currentIndex)));
          spans.add(_highlightSpan(currentHighlight));
          start = currentIndex + currentHighlight.length;
        }
      } else {
        spans.add(_normalSpan(text.substring(start, text.length)));
        break;
      }
    }

    return _richText(TextSpan(children: spans));
  }

  TextSpan _highlightSpan(String value) {
    if (style.color == null) {
      return TextSpan(
        text: value,
        style: style.copyWith(
          fontSize: 12,
          color: Colors.black,
          backgroundColor: color,
        ),
      );
    } else {
      return TextSpan(
        text: value,
        style: style.copyWith(
          fontSize: 12,
          backgroundColor: color,
        ),
      );
    }
  }

  TextSpan _normalSpan(String value) {
    if (style.color == null) {
      return TextSpan(
        text: value,
        style: style.copyWith(
          fontSize: 14,
          color: Colors.white,
        ),
      );
    } else {
      return TextSpan(
        text: value,
        style: style,
      );
    }
  }

  RichText _richText(TextSpan text) {
    return RichText(
      key: key,
      text: text,
      textAlign: textAlign,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      textWidthBasis: textWidthBasis,
    );
  }
}
