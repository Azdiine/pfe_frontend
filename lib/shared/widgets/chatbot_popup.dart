import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/apple_theme.dart';
import '../../features/chatbot/data/chatbot_service.dart';
import '../../features/fridge/presentation/widgets/recipe_details_popup.dart'
    show RecipeImage;
import 'meatay_assistant_avatar.dart';

class ChatbotPopup extends StatefulWidget {
  const ChatbotPopup({super.key});

  @override
  State<ChatbotPopup> createState() => _ChatbotPopupState();
}

class _ChatMessage {
  final String text;
  final bool isBot;
  final String time;
  final bool isError;
  final List<Map<String, dynamic>> recipes;

  _ChatMessage(
    this.text,
    this.isBot, {
    this.isError = false,
    this.recipes = const [],
  }) : time =
            '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}';
}

class _ChatbotPopupState extends State<ChatbotPopup> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatbotService _chatbotService = ChatbotService();

  final List<_ChatMessage> _messages = [];
  String? _sessionId; // une nouvelle session à chaque ouverture du popup
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages.add(_ChatMessage(
      'Bonjour ! Je suis **Meatay Assistant** 🥩 Dites-moi quels ingrédients '
      'vous avez ou posez-moi vos questions cuisine et nutrition !',
      true,
    ));
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isTyping) return;

    setState(() {
      _messages.add(_ChatMessage(text, false));
      _isTyping = true;
    });
    _messageController.clear();
    _scrollToBottom();

    try {
      final result =
          await _chatbotService.sendMessage(text, sessionId: _sessionId);

      if (!mounted) return;
      setState(() {
        _sessionId = result['sessionId'] as String?;
        _messages.add(_ChatMessage(
          (result['botMessage']?['content'] ?? '...') as String,
          true,
          recipes: List<Map<String, dynamic>>.from(result['recipes'] ?? []),
        ));
        _isTyping = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(_ChatMessage(
          'Oups, je n\'arrive pas à joindre le serveur 😔 '
          'Vérifiez votre connexion et réessayez.',
          true,
          isError: true,
        ));
        _isTyping = false;
      });
    }
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: BoxDecoration(
        color: AppleTheme.adaptiveBackground(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppleTheme.adaptiveBackground(context),
              border: Border(
                bottom: BorderSide(
                  color: AppleTheme.adaptiveSeparator(context)
                      .withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                const MeatayAssistantAvatar(size: 44),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Meatay Assistant',
                        style: AppleTheme.headline.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        _isTyping ? 'En train d\'écrire...' : 'En ligne',
                        style: AppleTheme.caption1.copyWith(
                          color: _isTyping
                              ? AppColors.warning
                              : AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color: AppleTheme.adaptiveTertiaryLabel(context),
                    size: 28,
                  ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return _AnimatedEntrance(child: _buildTypingIndicator());
                }
                return _AnimatedEntrance(
                  child: _buildMessageBubble(_messages[index]),
                );
              },
            ),
          ),

          // Input Field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppleTheme.adaptiveBackground(context),
              border: Border(
                top: BorderSide(
                  color: AppleTheme.adaptiveSeparator(context)
                      .withValues(alpha: 0.3),
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
                        color: AppleTheme.adaptiveSecondaryBackground(context),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: _isTyping
                              ? 'Meatay prépare sa réponse...'
                              : 'Votre message...',
                          hintStyle: AppleTheme.body.copyWith(
                            color: AppleTheme.adaptiveTertiaryLabel(context),
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
                  Semantics(
                    label: 'Send message',
                    button: true,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: _isTyping
                          ? null
                          : () {
                              HapticFeedback.lightImpact();
                              _sendMessage();
                            },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: _isTyping
                              ? null
                              : AppColors.primaryGradient(context),
                          color: _isTyping
                              ? AppleTheme.adaptiveSecondaryBackground(context)
                              : null,
                          shape: BoxShape.circle,
                        ),
                        child: _isTyping
                            ? const CupertinoActivityIndicator(radius: 10)
                            : const Icon(
                                CupertinoIcons.arrow_up,
                                color: Colors.white,
                                size: 24,
                              ),
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

  // ─── Bulles de message ────────────────────────────────────────────────────

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: MeatayAssistantAvatar(size: 30),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppleTheme.adaptiveSecondaryBackground(context),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: const _TypingDots(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage message) {
    final isBot = message.isBot;
    final bubbleRadius = BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft: Radius.circular(isBot ? 6 : 20),
      bottomRight: Radius.circular(isBot ? 20 : 6),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isBot)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: MeatayAssistantAvatar(size: 30),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: message.isError
                        ? AppColors.error.withValues(alpha: 0.12)
                        : isBot
                            ? AppleTheme.adaptiveSecondaryBackground(context)
                            : AppColors.primary(context),
                    borderRadius: bubbleRadius,
                  ),
                  child: _MarkdownLite(
                    text: message.text,
                    style: AppleTheme.body.copyWith(
                      color: isBot
                          ? AppleTheme.adaptiveLabel(context)
                          : Colors.white,
                      height: 1.35,
                    ),
                  ),
                ),

                // Cartes recettes du catalogue Meatay
                if (message.recipes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ...message.recipes.map(
                    (recipe) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: _RecipeCard(
                        recipe: recipe,
                        onTap: () => _showRecipeDetails(recipe),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 4),
                Text(
                  message.time,
                  style: AppleTheme.caption2.copyWith(
                    color: AppleTheme.adaptiveTertiaryLabel(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRecipeDetails(Map<String, dynamic> recipe) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RecipeDetailsSheet(recipe: recipe),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// ─── Rendu texte : gras **markdown** de Gemini ──────────────────────────────

class _MarkdownLite extends StatelessWidget {
  final String text;
  final TextStyle style;

  const _MarkdownLite({required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    final parts = text.split('**');
    for (var i = 0; i < parts.length; i++) {
      if (parts[i].isEmpty) continue;
      spans.add(TextSpan(
        text: parts[i],
        style: i.isOdd ? style.copyWith(fontWeight: FontWeight.w700) : style,
      ));
    }
    return Text.rich(TextSpan(children: spans, style: style));
  }
}

// ─── Carte recette cliquable ────────────────────────────────────────────────

class _RecipeCard extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final VoidCallback onTap;

  // Orange du logo Meatay, accent de marque du chatbot
  static const Color _accent = Color(0xFFE0731D);

  const _RecipeCard({required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final name = (recipe['name'] ?? '') as String;
    final ingredients = (recipe['ingredients'] ?? '') as String;
    final imageUrl = (recipe['image_url'] ?? '') as String;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppleTheme.adaptiveSecondaryBackground(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _accent.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 54,
              height: 54,
              child: imageUrl.isNotEmpty
                  ? RecipeImage(
                      imageUrl: imageUrl,
                      height: 54,
                      name: name,
                      borderRadius: BorderRadius.circular(10),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: _accent.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        CupertinoIcons.book_fill,
                        color: _accent,
                        size: 20,
                      ),
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppleTheme.subhead.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    ingredients,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppleTheme.caption1.copyWith(
                      color: AppleTheme.adaptiveSecondaryLabel(context),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: AppleTheme.adaptiveTertiaryLabel(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Fiche détail d'une recette ─────────────────────────────────────────────

class _RecipeDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const _RecipeDetailsSheet({required this.recipe});

  List<String> get _ingredientsList {
    final raw = (recipe['ingredients'] ?? '') as String;
    return raw
        .split(RegExp(r'\s{2,}'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  List<String> get _stepsList {
    final raw = (recipe['etapes'] ?? '') as String;
    return raw
        .split(RegExp(r'(?<=[.!])\s+'))
        .map((e) => e.trim())
        .where((e) => e.length > 3)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final name = (recipe['name'] ?? '') as String;
    final etapes = (recipe['etapes'] ?? '') as String;
    final imageUrl = (recipe['image_url'] ?? '') as String;
    final ingredients = _ingredientsList;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.80,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppleTheme.adaptiveBackground(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Photo du plat
          if (imageUrl.isNotEmpty)
            RecipeImage(imageUrl: imageUrl, height: 160, name: name),
          const SizedBox(height: 8),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppleTheme.adaptiveTertiaryLabel(context)
                  .withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                const MeatayAssistantAvatar(size: 36),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppleTheme.headline.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color: AppleTheme.adaptiveTertiaryLabel(context),
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              shrinkWrap: true,
              children: [
                if (ingredients.isNotEmpty) ...[
                  Text(
                    'Ingrédients',
                    style: AppleTheme.subhead.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _RecipeCard._accent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...ingredients.map(
                    (ing) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 7, right: 8),
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: _RecipeCard._accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(ing, style: AppleTheme.subhead),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (etapes.isNotEmpty) ...[
                  Text(
                    'Préparation',
                    style: AppleTheme.subhead.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _RecipeCard._accent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._stepsList.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: _RecipeCard._accent,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${entry.key + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Text(
                                    entry.value,
                                    style: AppleTheme.subhead
                                        .copyWith(height: 1.4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Animation d'entrée des messages ────────────────────────────────────────

class _AnimatedEntrance extends StatelessWidget {
  final Widget child;

  const _AnimatedEntrance({required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 8 * (1 - value)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

// ─── Trois points animés « Meatay écrit... » ────────────────────────────────

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final phase = (_controller.value * 3 - i).clamp(0.0, 1.0);
            final bounce = phase < 0.5 ? phase * 2 : (1 - phase) * 2;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.5),
              child: Transform.translate(
                offset: Offset(0, -3 * bounce),
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: AppleTheme.adaptiveTertiaryLabel(context),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

void showChatbotPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: const ChatbotPopup(),
    ),
  );
}
