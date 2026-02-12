import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/apple_theme.dart';

class ChatbotPopup extends StatefulWidget {
  const ChatbotPopup({super.key});

  @override
  State<ChatbotPopup> createState() => _ChatbotPopupState();
}

class _ChatbotPopupState extends State<ChatbotPopup> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text':
          'Bonjour! Comment puis-je vous aider avec vos recettes aujourd\'hui?',
      'isBot': true,
      'time': '10:30',
    },
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': _messageController.text,
        'isBot': false,
        'time': '${DateTime.now().hour}:${DateTime.now().minute}',
      });
    });

    _messageController.clear();

    // Simulation de réponse du bot
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add({
          'text':
              'Merci pour votre message! Je cherche des recettes pour vous...',
          'isBot': true,
          'time': '${DateTime.now().hour}:${DateTime.now().minute}',
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppleTheme.backgroundLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppleTheme.backgroundLight,
              border: Border(
                bottom: BorderSide(
                  color: AppleTheme.separator.withOpacity(0.3),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AppColors.lightFreshGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    CupertinoIcons.chat_bubble_text_fill,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assistant Recettes',
                        style: AppleTheme.headline.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'En ligne',
                        style: AppleTheme.caption1.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color: AppleTheme.tertiaryLabel,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(
                  message['text'],
                  message['isBot'],
                  message['time'],
                );
              },
            ),
          ),

          // Input Field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppleTheme.backgroundLight,
              border: Border(
                top: BorderSide(
                  color: AppleTheme.separator.withOpacity(0.3),
                  width: 0.5,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppleTheme.secondaryBackgroundLight,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Votre message...',
                          hintStyle: AppleTheme.body.copyWith(
                            color: AppleTheme.tertiaryLabel,
                          ),
                          border: InputBorder.none,
                        ),
                        style: AppleTheme.body,
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: AppColors.lightFreshGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        CupertinoIcons.arrow_up,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isBot, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isBot
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isBot)
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                gradient: AppColors.lightFreshGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.sparkles,
                color: Colors.white,
                size: 16,
              ),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: isBot
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isBot
                        ? AppleTheme.secondaryBackgroundLight
                        : AppColors.lightPrimary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    text,
                    style: AppleTheme.body.copyWith(
                      color: isBot ? AppleTheme.label : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: AppleTheme.caption2.copyWith(
                    color: AppleTheme.tertiaryLabel,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

void showChatbotPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const ChatbotPopup(),
  );
}
