import 'dart:io';

import 'package:ai_buddy/core/config/assets_constants.dart';
import 'package:ai_buddy/core/config/mellowtel.dart';
import 'package:ai_buddy/core/config/type_of_bot.dart';
import 'package:ai_buddy/core/extension/context.dart';
import 'package:ai_buddy/feature/chat/provider/message_provider.dart';
import 'package:ai_buddy/feature/chat/widgets/chat_interface_widget.dart';
import 'package:ai_buddy/feature/home/provider/chat_bot_provider.dart';
import 'package:ai_buddy/feature/home/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChatPage extends ConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatBot = ref.watch(messageListProvider);
    final color = chatBot.typeOfBot == TypeOfBot.pdf
        ? context.colorScheme.primary
        : chatBot.typeOfBot == TypeOfBot.text
            ? context.colorScheme.secondary
            : context.colorScheme.tertiary;
    final imagePath = chatBot.typeOfBot == TypeOfBot.pdf
        ? AssetConstants.pdfLogo
        : chatBot.typeOfBot == TypeOfBot.image
            ? AssetConstants.imageLogo
            : AssetConstants.textLogo;
    final title = chatBot.typeOfBot == TypeOfBot.pdf
        ? 'PDF'
        : chatBot.typeOfBot == TypeOfBot.image
            ? 'Image'
            : 'Text';

    final List<types.Message> messages = chatBot.messagesList.map((msg) {
      return types.TextMessage(
        author: types.User(id: msg['typeOfMessage'] as String),
        createdAt:
            DateTime.parse(msg['createdAt'] as String).millisecondsSinceEpoch,
        id: msg['id'] as String,
        text: msg['text'] as String,
      );
    }).toList()
      ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                left: -200,
                top: -100,
                child: Container(
                  height: 400,
                  width: 500,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        color.withOpacity(0.15),
                        context.colorScheme.background.withOpacity(0.1),
                      ],
                      radius: 1.2,
                    ),
                  ),
                ),
              ),
              CustomPaint(
                painter: BackgroundCurvesPainter(),
                size: Size.infinite,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: context.colorScheme.surface.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: color.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: context.colorScheme.onSurface,
                              size: 20,
                            ),
                            onPressed: () {
                              ref
                                  .read(chatBotListProvider.notifier)
                                  .updateChatBotOnHomeScreen(chatBot);
                              context.pop();
                              startMellowtel(context, showConsentDialog: true);
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: context.colorScheme.surface.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: color.withOpacity(0.2),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.1),
                                offset: const Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                imagePath,
                                width: 20,
                                height: 20,
                                color: color,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$title Buddy',
                                style: context.textTheme.titleMedium!.copyWith(
                                  color: context.colorScheme.onSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (chatBot.typeOfBot == TypeOfBot.image)
                          CircleAvatar(
                            maxRadius: 21,
                            backgroundImage: FileImage(
                              File(chatBot.attachmentPath!),
                            ),
                            child: TextButton(
                              onPressed: () {
                                showDialog<AlertDialog>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: SingleChildScrollView(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Image.file(
                                            File(chatBot.attachmentPath!),
                                          ),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Close'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const SizedBox.shrink(),
                            ),
                          )
                        else
                          const SizedBox(width: 42),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ChatInterfaceWidget(
                        messages: messages,
                        chatBot: chatBot,
                        color: color,
                        imagePath: imagePath,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
