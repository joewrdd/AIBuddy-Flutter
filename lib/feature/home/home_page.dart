// ignore_for_file: use_build_context_synchronously

import 'package:ai_buddy/core/config/assets_constants.dart';
import 'package:ai_buddy/core/config/mellowtel.dart';
import 'package:ai_buddy/core/config/type_of_bot.dart';
import 'package:ai_buddy/core/extension/context.dart';
import 'package:ai_buddy/core/navigation/route.dart';
import 'package:ai_buddy/core/util/secure_storage.dart';
import 'package:ai_buddy/feature/chat/provider/message_provider.dart';
import 'package:ai_buddy/feature/hive/model/chat_bot/chat_bot.dart';
import 'package:ai_buddy/feature/home/provider/chat_bot_provider.dart';
import 'package:ai_buddy/feature/home/widgets/widgets.dart';
import 'package:ai_buddy/feature/welcome/widgets/api_key_bottom_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uuid/uuid.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final uuid = const Uuid();

  bool _isBuildingChatBot = false;
  String currentState = '';

  @override
  void initState() {
    super.initState();
    ref.read(chatBotListProvider.notifier).fetchChatBots();
    startMellowtel(context);
  }

  Widget _buildLoadingIndicator(String currentState) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitDoubleBounce(
            color: context.colorScheme.onSurface,
          ),
          const SizedBox(height: 8),
          Text(currentState, style: context.textTheme.titleMedium),
        ],
      ),
    );
  }

  void _showAllHistory(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final chatBotsList = ref.watch(chatBotListProvider);
            return Column(
              children: [
                Container(
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                    color: context.colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  margin: const EdgeInsets.only(top: 8, bottom: 16),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ListView.separated(
                      itemCount: chatBotsList.length,
                      itemBuilder: (context, index) {
                        final chatBot = chatBotsList[index];
                        final imagePath = chatBot.typeOfBot == TypeOfBot.pdf
                            ? AssetConstants.pdfLogo
                            : chatBot.typeOfBot == TypeOfBot.image
                                ? AssetConstants.imageLogo
                                : AssetConstants.textLogo;
                        final tileColor = chatBot.typeOfBot == TypeOfBot.pdf
                            ? context.colorScheme.primary
                            : chatBot.typeOfBot == TypeOfBot.text
                                ? context.colorScheme.secondary
                                : context.colorScheme.tertiary;
                        return HistoryItem(
                          imagePath: imagePath,
                          label: chatBot.title,
                          color: tileColor,
                          chatBot: chatBot,
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 4),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatBotsList = ref.watch(chatBotListProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: _isBuildingChatBot
          ? _buildLoadingIndicator(currentState)
          : SafeArea(
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
                            context.colorScheme.primary.withOpacity(0.15),
                            context.colorScheme.background.withOpacity(0.05),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 60,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: context.colorScheme.surface
                                    .withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: context.colorScheme.primary
                                      .withOpacity(0.2),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: context.colorScheme.primary
                                        .withOpacity(0.1),
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Personal AI Buddy',
                                    style: TextStyle(
                                      color: context.colorScheme.onSurface,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Image.asset(
                                    AssetConstants.aiStarLogo,
                                    width: 20,
                                    height: 20,
                                    color: context.colorScheme.primary,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: context.colorScheme.surface
                                    .withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: context.colorScheme.primary
                                      .withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  CupertinoIcons.settings,
                                  size: 18,
                                  color: context.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                                onPressed: () async {
                                  final apiKey =
                                      await SecureStorage().getApiKey();
                                  final TextEditingController apiKeyController =
                                      TextEditingController(text: apiKey);
                                  await showModalBottomSheet<void>(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    builder: (context) {
                                      return APIKeyBottomSheet(
                                        apiKeyController: apiKeyController,
                                        isCalledFromHomePage: true,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'How may I help\nyou today?',
                              style: context.textTheme.headlineMedium!.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                color: context.colorScheme.onBackground
                                    .withOpacity(0.9),
                                height: 1.2,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: CardButton(
                                title: 'Chat\nwith PDF',
                                color: context.colorScheme.primary,
                                imagePath: AssetConstants.pdfLogo,
                                isMainButton: true,
                                onPressed: () async {
                                  final result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf'],
                                  );
                                  if (result != null) {
                                    final filePath = result.files.single.path;
                                    setState(() {
                                      _isBuildingChatBot = true;
                                      currentState = 'Extracting data';
                                    });

                                    await Future<void>.delayed(
                                      const Duration(milliseconds: 100),
                                    );

                                    final textChunks = await ref
                                        .read(chatBotListProvider.notifier)
                                        .getChunksFromPDF(filePath!);

                                    setState(() {
                                      currentState = 'Building chatBot';
                                    });

                                    final embeddingsMap = await ref
                                        .read(chatBotListProvider.notifier)
                                        .batchEmbedChunks(textChunks);

                                    final chatBot = ChatBot(
                                      messagesList: [],
                                      id: uuid.v4(),
                                      title: '',
                                      typeOfBot: TypeOfBot.pdf,
                                      attachmentPath: filePath,
                                      embeddings: embeddingsMap,
                                    );

                                    await ref
                                        .read(chatBotListProvider.notifier)
                                        .saveChatBot(chatBot);
                                    await ref
                                        .read(messageListProvider.notifier)
                                        .updateChatBot(chatBot);

                                    AppRoute.chat.push(context);
                                    setState(() {
                                      _isBuildingChatBot = false;
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                children: [
                                  CardButton(
                                    title: 'Chat with AI',
                                    color: context.colorScheme.secondary,
                                    imagePath: AssetConstants.textLogo,
                                    isMainButton: false,
                                    onPressed: () {
                                      final chatBot = ChatBot(
                                        messagesList: [],
                                        id: uuid.v4(),
                                        title: '',
                                        typeOfBot: TypeOfBot.text,
                                      );
                                      ref
                                          .read(chatBotListProvider.notifier)
                                          .saveChatBot(chatBot);
                                      ref
                                          .read(messageListProvider.notifier)
                                          .updateChatBot(chatBot);
                                      AppRoute.chat.push(context);
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  CardButton(
                                    title: 'Ask Image',
                                    color: context.colorScheme.tertiary,
                                    imagePath: AssetConstants.imageLogo,
                                    isMainButton: false,
                                    onPressed: () async {
                                      final pickedFile = await ref
                                          .read(chatBotListProvider.notifier)
                                          .attachImageFilePath();
                                      if (pickedFile != null) {
                                        final chatBot = ChatBot(
                                          messagesList: [],
                                          id: uuid.v4(),
                                          title: '',
                                          typeOfBot: TypeOfBot.image,
                                          attachmentPath: pickedFile,
                                        );
                                        await ref
                                            .read(chatBotListProvider.notifier)
                                            .saveChatBot(chatBot);
                                        await ref
                                            .read(messageListProvider.notifier)
                                            .updateChatBot(chatBot);
                                        AppRoute.chat.push(context);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'History',
                                    style:
                                        context.textTheme.titleLarge!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: context.colorScheme.onBackground
                                          .withOpacity(0.9),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => _showAllHistory(context),
                                    style: TextButton.styleFrom(
                                      foregroundColor:
                                          context.colorScheme.primary,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      'See all',
                                      style: context.textTheme.labelLarge!
                                          .copyWith(
                                        color: context.colorScheme.primary
                                            .withOpacity(0.8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (chatBotsList.isEmpty)
                              Center(
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 32),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.surface
                                        .withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: context.colorScheme.primary
                                          .withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        CupertinoIcons.chat_bubble_2,
                                        color: context.colorScheme.onSurface
                                            .withOpacity(0.6),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'No chats yet',
                                        style: context.textTheme.titleMedium!
                                            .copyWith(
                                          color: context.colorScheme.onSurface
                                              .withOpacity(0.8),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: chatBotsList.length > 3
                                    ? 3
                                    : chatBotsList.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 4),
                                itemBuilder: (context, index) {
                                  final chatBot = chatBotsList[index];
                                  final imagePath =
                                      chatBot.typeOfBot == TypeOfBot.pdf
                                          ? AssetConstants.pdfLogo
                                          : chatBot.typeOfBot == TypeOfBot.image
                                              ? AssetConstants.imageLogo
                                              : AssetConstants.textLogo;
                                  final tileColor =
                                      chatBot.typeOfBot == TypeOfBot.pdf
                                          ? context.colorScheme.primary
                                          : chatBot.typeOfBot == TypeOfBot.text
                                              ? context.colorScheme.secondary
                                              : context.colorScheme.tertiary;
                                  return HistoryItem(
                                    label: chatBot.title,
                                    imagePath: imagePath,
                                    color: tileColor,
                                    chatBot: chatBot,
                                  );
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class CardButton extends StatelessWidget {
  final String title;
  final Color color;
  final String imagePath;
  final bool isMainButton;
  final VoidCallback onPressed;

  const CardButton({
    Key? key,
    required this.title,
    required this.color,
    required this.imagePath,
    required this.isMainButton,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isMainButton ? 160 : 76,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colorScheme.surface.withOpacity(0.8),
          elevation: 0,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: isMainButton
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: color.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Image.asset(
                    imagePath,
                    width: 20,
                    height: 20,
                    color: color,
                  ),
                ),
                if (!isMainButton) const SizedBox(width: 12),
                if (!isMainButton)
                  Expanded(
                    child: Text(
                      title,
                      style: context.textTheme.titleMedium!.copyWith(
                        color: context.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
            if (isMainButton)
              Text(
                title,
                style: context.textTheme.headlineSmall!.copyWith(
                  color: context.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
