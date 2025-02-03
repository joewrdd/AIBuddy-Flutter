import 'package:ai_buddy/feature/gemini/models/content/content.dart';

class Candidates {
  final Content? content;
  final String? finishReason;
  final int? index;

  Candidates({
    this.content,
    this.finishReason,
    this.index,
  });

  factory Candidates.fromJson(Map<String, dynamic> json) {
    return Candidates(
      content: json['content'] == null
          ? null
          : Content.fromJson(json['content'] as Map<String, dynamic>),
      finishReason: json['finishReason'] as String?,
      index: json['index'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content?.toJson(),
      'finishReason': finishReason,
      'index': index,
    };
  }

  static List<Candidates> jsonToList(List list) =>
      list.map((e) => Candidates.fromJson(e as Map<String, dynamic>)).toList();

  Candidates copyWith({
    Content? content,
    String? finishReason,
    int? index,
  }) {
    return Candidates(
      content: content ?? this.content,
      finishReason: finishReason ?? this.finishReason,
      index: index ?? this.index,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Candidates &&
        other.content == content &&
        other.finishReason == finishReason &&
        other.index == index;
  }

  @override
  int get hashCode => Object.hash(content, finishReason, index);

  @override
  String toString() =>
      'Candidates(content: $content, finishReason: $finishReason, index: $index)';
}
