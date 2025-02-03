class ChatMessage {
  final String id;
  final String text;
  final DateTime createdAt;
  final String typeOfMessage;
  final String chatBotId;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.typeOfMessage,
    required this.chatBotId,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      typeOfMessage: json['typeOfMessage'] as String,
      chatBotId: json['chatBotId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'typeOfMessage': typeOfMessage,
      'chatBotId': chatBotId,
    };
  }

  static List<ChatMessage> jsonToList(List<dynamic> list) =>
      list.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>)).toList();

  ChatMessage copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    String? typeOfMessage,
    String? chatBotId,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      typeOfMessage: typeOfMessage ?? this.typeOfMessage,
      chatBotId: chatBotId ?? this.chatBotId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessage &&
        other.id == id &&
        other.text == text &&
        other.createdAt == createdAt &&
        other.typeOfMessage == typeOfMessage &&
        other.chatBotId == chatBotId;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      text,
      createdAt,
      typeOfMessage,
      chatBotId,
    );
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, text: $text, createdAt: $createdAt, typeOfMessage: $typeOfMessage, chatBotId: $chatBotId)';
  }
}
