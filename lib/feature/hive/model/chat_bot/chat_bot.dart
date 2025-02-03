import 'package:hive/hive.dart';

class ChatBot extends HiveObject {
  ChatBot({
    required this.messagesList,
    required this.id,
    required this.title,
    required this.typeOfBot,
    this.attachmentPath,
    this.embeddings,
  });

  final String id;
  final String? attachmentPath;
  final String title;
  final String typeOfBot;
  final List<Map<String, dynamic>> messagesList;
  final Map<String, List<num>>? embeddings;

// Add inside ChatBot class, after the constructor
  ChatBot copyWith({
    String? id,
    String? title,
    String? typeOfBot,
    List<Map<String, dynamic>>? messagesList,
    String? attachmentPath,
    Map<String, List<num>>? embeddings,
    String? error,
  }) =>
      ChatBot(
        id: id ?? this.id,
        title: title ?? this.title,
        typeOfBot: typeOfBot ?? this.typeOfBot,
        messagesList: messagesList ?? this.messagesList,
        attachmentPath: attachmentPath ?? this.attachmentPath,
        embeddings: embeddings ?? this.embeddings,
      );
  // Manual serialization for Hive
  void serialize(BinaryWriter writer) {
    writer.writeByte(6);
    writer.writeByte(0);
    writer.write(id);
    writer.writeByte(1);
    writer.write(attachmentPath);
    writer.writeByte(2);
    writer.write(title);
    writer.writeByte(3);
    writer.write(typeOfBot);
    writer.writeByte(4);
    writer.write(messagesList);
    writer.writeByte(5);
    writer.write(embeddings);
  }

  // Manual deserialization for Hive
  static ChatBot deserialize(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return ChatBot(
      id: fields[0] as String,
      attachmentPath: fields[1] as String?,
      title: fields[2] as String,
      typeOfBot: fields[3] as String,
      messagesList: (fields[4] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      embeddings: (fields[5] as Map?)?.map(
        (dynamic k, dynamic v) =>
            MapEntry(k as String, (v as List).cast<num>()),
      ),
    );
  }

  // Manually register the adapter
  static void registerAdapter() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(_ChatBotAdapter());
    }
  }

  // Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatBot &&
        other.id == id &&
        other.attachmentPath == attachmentPath &&
        other.title == title &&
        other.typeOfBot == typeOfBot &&
        other.messagesList == messagesList &&
        other.embeddings == embeddings;
  }

  // Hash code
  @override
  int get hashCode {
    return Object.hash(
      id,
      attachmentPath,
      title,
      typeOfBot,
      messagesList,
      embeddings,
    );
  }

  // ToString method
  @override
  String toString() {
    return 'ChatBot(id: $id, attachmentPath: $attachmentPath, title: $title, typeOfBot: $typeOfBot, messagesList: $messagesList, embeddings: $embeddings)';
  }
}

// Custom adapter implementation
class _ChatBotAdapter extends TypeAdapter<ChatBot> {
  @override
  final int typeId = 0;

  @override
  ChatBot read(BinaryReader reader) => ChatBot.deserialize(reader);

  @override
  void write(BinaryWriter writer, ChatBot obj) => obj.serialize(writer);
}
