extension RegExtention on String {
  bool get isValid {
    return contains(RegExp(r'^[a-zA-Z _@./#;&+-]*$'));
  }
}
