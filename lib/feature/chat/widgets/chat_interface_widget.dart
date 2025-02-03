import 'package:ai_buddy/core/config/type_of_message.dart';
import 'package:ai_buddy/core/extension/context.dart';
import 'package:ai_buddy/feature/chat/provider/message_provider.dart';
import 'package:ai_buddy/feature/hive/model/chat_bot/chat_bot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatInterfaceWidget extends ConsumerWidget {
  const ChatInterfaceWidget({
    required this.messages,
    required this.chatBot,
    required this.color,
    required this.imagePath,
    super.key,
  });

  final List<types.Message> messages;
  final ChatBot chatBot;
  final Color color;
  final String imagePath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Chat(
      messages: messages,
      onSendPressed: (text) =>
          ref.watch(messageListProvider.notifier).handleSendPressed(
                text: text.text,
                imageFilePath: chatBot.attachmentPath,
              ),
      user: const types.User(id: TypeOfMessage.user),
      showUserAvatars: true,
      avatarBuilder: (user) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Image.asset(
            imagePath,
            width: 24,
            height: 24,
            color: color,
          ),
        ),
      ),
      theme: DefaultChatTheme(
        backgroundColor: Colors.transparent,
        primaryColor: context.colorScheme.surface.withOpacity(0.8),
        secondaryColor: color.withOpacity(0.1),
        inputBackgroundColor: context.colorScheme.surface.withOpacity(0.8),
        inputTextColor: context.colorScheme.onSurface,
        sendingIcon: Icon(
          Icons.send_rounded,
          color: color,
          size: 20,
        ),
        inputTextCursorColor: color,
        receivedMessageBodyTextStyle: TextStyle(
          color: context.colorScheme.onSurface,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
        sentMessageBodyTextStyle: TextStyle(
          color: context.colorScheme.onSurface,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
        dateDividerTextStyle: TextStyle(
          color: context.colorScheme.onSurface.withOpacity(0.6),
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        inputTextStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          height: 1.4,
          color: context.colorScheme.onSurface,
        ),
        inputTextDecoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: color.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          fillColor: context.colorScheme.surface.withOpacity(0.8),
          filled: true,
        ),
        inputBorderRadius: BorderRadius.circular(12),
        messageBorderRadius: 12,
        messageInsetsHorizontal: 16,
        messageInsetsVertical: 12,
      ),
    );
  }
}
