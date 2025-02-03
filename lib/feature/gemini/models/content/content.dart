import 'package:ai_buddy/feature/gemini/models/parts/parts.dart';

class Content {
  final List<Parts>? parts;
  final String? role;

  Content({
    this.parts,
    this.role,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      parts: json['parts'] != null
          ? (json['parts'] as List<dynamic>)
              .map((e) => Parts.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parts': parts?.map((e) => e.toJson()).toList(),
      'role': role,
    };
  }

  static List<Content> jsonToList(List list) =>
      list.map((e) => Content.fromJson(e as Map<String, dynamic>)).toList();

  Content copyWith({
    List<Parts>? parts,
    String? role,
  }) {
    return Content(
      parts: parts ?? this.parts,
      role: role ?? this.role,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Content &&
        _listEquals(other.parts, parts) &&
        other.role == role;
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
        parts == null ? null : Object.hashAll(parts!),
        role,
      );

  @override
  String toString() => 'Content(parts: $parts, role: $role)';
}
