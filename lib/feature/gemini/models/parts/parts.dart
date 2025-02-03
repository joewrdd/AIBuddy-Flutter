class Parts {
  final String? text;

  Parts({
    this.text,
  });

  factory Parts.fromJson(Map<String, dynamic> json) {
    return Parts(
      text: json['text'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }

  static List<Parts> jsonToList(List list) =>
      list.map((e) => Parts.fromJson(e as Map<String, dynamic>)).toList();

  Parts copyWith({
    String? text,
  }) {
    return Parts(
      text: text ?? this.text,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Parts && other.text == text;
  }

  @override
  int get hashCode => text.hashCode;

  @override
  String toString() => 'Parts(text: $text)';
}
