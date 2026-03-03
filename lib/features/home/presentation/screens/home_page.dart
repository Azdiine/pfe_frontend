import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/apple_theme.dart';
import '../../../../shared/widgets/apple_widgets.dart';
import 'package:go_router/go_router.dart';
import '../../../fridge/presentation/screens/barcode_scanner_page.dart';
import '../../../../shared/widgets/chatbot_popup.dart';
import '../../../../shared/widgets/notifications_popup.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../../core/localization/app_localizations.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _getTodayDate(AppLocalizations l10n) {
    final now = DateTime.now();
    final days = [
      l10n.monday,
      l10n.tuesday,
      l10n.wednesday,
      l10n.thursday,
      l10n.friday,
      l10n.saturday,
      l10n.sunday,
    ];
    final months = [
      l10n.january,
      l10n.february,
      l10n.march,
      l10n.april,
      l10n.may,
      l10n.june,
      l10n.july,
      l10n.august,
      l10n.september,
      l10n.october,
      l10n.november,
      l10n.december,
    ];
    return '${days[now.weekday - 1]} ${now.day} ${months[now.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(locale);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Header iOS 18 Style - Plus généreux
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppleTheme.spacing24, // iOS 18: 24pt
                    AppleTheme.spacing20, // iOS 18: 20pt
                    AppleTheme.spacing24,
                    AppleTheme.spacing20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Bar iOS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 🎯 Greeting avec scroll horizontal (marquee style)
                                SizedBox(
                                  height: 32, // Hauteur fixe pour le texte
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    child: Row(
                                      children: [
                                        Text(
                                          '👋 ${l10n.greeting} ',
                                          style: AppleTheme.title2.copyWith(
                                            color: AppleTheme.adaptiveLabel(
                                              context,
                                            ),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'Ezedine',
                                          style: AppleTheme.title2.copyWith(
                                            color: AppColors.secondary(context),
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _getTodayDate(l10n),
                                  style: AppleTheme.subhead.copyWith(
                                    color: AppleTheme.adaptiveSecondaryLabel(
                                      context,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Semantics(
                                label: 'Notifications',
                                button: true,
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    showNotificationsPopup(context);
                                  },
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: AppColors.surface(context),
                                          borderRadius: BorderRadius.circular(
                                            AppleTheme
                                                .radiusLarge, // iOS 18: 14pt
                                          ),
                                          border: Border.all(
                                            color:
                                                AppleTheme.adaptiveSeparator(
                                                  context,
                                                ).withOpacity(
                                                  0.2,
                                                ), // iOS 18: Plus subtil
                                            width: 0.5,
                                          ),
                                          boxShadow: AppleTheme
                                              .cardShadow, // iOS 18: Shadow
                                        ),
                                        child: Icon(
                                          CupertinoIcons.bell,
                                          size: 20,
                                          color: AppleTheme.adaptiveLabel(
                                            context,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 2,
                                        top: 2,
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: AppColors.error,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppColors.background(
                                                context,
                                              ),
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppleTheme.spacing8),
                              Semantics(
                                label: 'AI Chat',
                                button: true,
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    showChatbotPopup(context);
                                  },
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      gradient: AppColors.aiGradient(context),
                                      borderRadius: BorderRadius.circular(
                                        AppleTheme.radiusLarge, // iOS 18: 14pt
                                      ),
                                      boxShadow: AppleTheme
                                          .floatingShadow, // iOS 18: Shadow
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.chat_bubble_text,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: AppleTheme.spacing20,
                      ), // iOS 18: 20pt
                      // Smart info pill — Modern glassmorphism
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppleTheme.spacing16,
                          vertical: AppleTheme.spacing12,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary(context).withOpacity(0.08),
                              AppColors.secondary(context).withOpacity(0.06),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppleTheme.radiusCard,
                          ),
                          border: Border.all(
                            color: AppColors.primary(context).withOpacity(0.12),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient(context),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                CupertinoIcons.flame_fill,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: AppleTheme.spacing12),
                            Expanded(
                              child: Text(
                                l10n.caloriesRemaining,
                                style: AppleTheme.calloutEmphasized.copyWith(
                                  color: AppColors.textPrimary(context),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              CupertinoIcons.chevron_right,
                              size: 14,
                              color: AppColors.textTertiary(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppleTheme.spacing24,
                    ), // iOS 18: 24pt
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: AppleTheme.spacing8,
                        ), // iOS 18: Réduit
                        // Résumé nutrition iOS 18 Style - Plus arrondi
                        Container(
                          padding: const EdgeInsets.all(
                            AppleTheme.spacing24,
                          ), // iOS 18: 24pt
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient(context),
                            borderRadius: BorderRadius.circular(
                              AppleTheme
                                  .radiusXLarge, // iOS 18: 16pt pour cards prominentes
                            ),
                            boxShadow: AppleTheme
                                .floatingShadow, // iOS 18: Shadow plus prononcée
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.dailyNutrition,
                                    style: AppleTheme.headline.copyWith(
                                      color: Colors.white,
                                      fontWeight:
                                          FontWeight.w700, // iOS 18: Bold
                                    ),
                                  ),
                                  const Icon(
                                    CupertinoIcons.flame_fill,
                                    color: Colors.white,
                                    size: 26, // iOS 18: Icônes plus grandes
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: AppleTheme.spacing20,
                              ), // iOS 18
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '1450',
                                    style: AppleTheme.largeTitle.copyWith(
                                      fontSize: 44,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      height: 1,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      ' / 2000 ${l10n.kcalUnit}',
                                      style: AppleTheme.bodyEmphasized.copyWith(
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: AppleTheme.spacing16,
                              ), // iOS 18: 16pt
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppleTheme.radiusSmall, // iOS 18: 10pt
                                ),
                                child: LinearProgressIndicator(
                                  value: 0.725,
                                  backgroundColor: Colors.white.withOpacity(
                                    0.2,
                                  ), // iOS 18: Plus subtil
                                  valueColor: const AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                  minHeight: 8, // iOS 18: Plus épais
                                ),
                              ),
                              const SizedBox(height: AppleTheme.spacing20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: _buildMacroItem(
                                      l10n.proteins,
                                      '80g',
                                      '120g',
                                    ),
                                  ),
                                  Container(
                                    width: 0.5,
                                    height: 40,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  Expanded(
                                    child: _buildMacroItem(
                                      l10n.carbs,
                                      '150g',
                                      '200g',
                                    ),
                                  ),
                                  Container(
                                    width: 0.5,
                                    height: 40,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  Expanded(
                                    child: _buildMacroItem(
                                      l10n.fats,
                                      '60g',
                                      '80g',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: AppleTheme.spacing28,
                        ), // iOS 18: 28pt entre sections
                        // Actions rapides iOS 18 Style
                        Text(
                          l10n.quickActions,
                          style: AppleTheme.title3.copyWith(
                            color: AppleTheme.adaptiveLabel(context),
                            fontWeight: FontWeight.w800, // iOS 18: Plus bold
                          ),
                        ),
                        const SizedBox(
                          height: AppleTheme.spacing20,
                        ), // iOS 18: 20pt
                        // 🎯 HERO ACTION - Scanner (Full Width)
                        AppleQuickActionCard(
                          icon: CupertinoIcons.barcode_viewfinder,
                          title: l10n.scan,
                          subtitle: l10n.food,
                          isHero: true, // Mode Hero!
                          onTap: () async {
                            final result = await Navigator.of(context, rootNavigator: true)
                                .push(
                                  PageRouteBuilder(
                                    opaque: true,
                                    barrierDismissible: false,
                                    barrierColor: Colors.black,
                                    fullscreenDialog: true,
                                    pageBuilder: (context, animation, secondaryAnimation) =>
                                        const BarcodeScannerPage(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                            if (result != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${l10n.productScanned}: $result',
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: AppleTheme.spacing16), // iOS 18: 16pt spacing moderne
                        // 🎯 ACTIONS SECONDAIRES - Chat IA + Mon Frigo
                        Row(
                          children: [
                            Expanded(
                              child: AppleQuickActionCard(
                                icon: CupertinoIcons.chat_bubble_text,
                                title: l10n.chatAI,
                                subtitle: l10n.advice,
                                isPrimary: false, // Action secondaire
                              ),
                            ),
                            const SizedBox(width: AppleTheme.spacing16), // iOS 18: 16pt
                            Expanded(
                              child: AppleQuickActionCard(
                                icon: CupertinoIcons.cube_box,
                                title: l10n.myFridge,
                                subtitle: l10n.ingredients,
                                isPrimary: false, // Action secondaire
                                onTap: () => context.go('/frigo'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppleTheme.spacing24),

                        // Recette recommandée IA iOS Style
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.recommendedForYou,
                                style: AppleTheme.title3.copyWith(
                                  color: AppleTheme.adaptiveLabel(context),
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: AppleTheme.spacing8),
                            AppleBadge(
                              text: '⭐ IA',
                              backgroundColor: AppleTheme.systemPurple,
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppleTheme.spacing16),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface(context),
                            borderRadius: BorderRadius.circular(
                              AppleTheme.radiusCard,
                            ),
                            border: Border.all(
                              color: AppleTheme.adaptiveSeparator(
                                context,
                              ).withOpacity(0.3),
                              width: 0.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 160,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.secondary(
                                        context,
                                      ).withOpacity(0.3),
                                      AppColors.secondary(
                                        context,
                                      ).withOpacity(0.1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(AppleTheme.radiusCard),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Icon(
                                        CupertinoIcons
                                            .square_fill_on_square_fill,
                                        size: 80,
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                    Positioned(
                                      top: AppleTheme.spacing12,
                                      right: AppleTheme.spacing12,
                                      child: CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {},
                                        child: Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: AppColors.surface(context),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            CupertinoIcons.heart,
                                            size: 20,
                                            color: AppleTheme.adaptiveLabel(
                                              context,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(
                                  AppleTheme.spacing16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.chickenCurry,
                                      style: AppleTheme.headline.copyWith(
                                        color: AppleTheme.adaptiveLabel(
                                          context,
                                        ),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: AppleTheme.spacing8),
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.clock,
                                          size: 16,
                                          color:
                                              AppleTheme.adaptiveSecondaryLabel(
                                                context,
                                              ),
                                        ),
                                        const SizedBox(width: 4),
                                        Flexible(
                                          child: Text(
                                            '20 ${l10n.minutes}',
                                            style: AppleTheme.subhead.copyWith(
                                              color:
                                                  AppleTheme.adaptiveSecondaryLabel(
                                                    context,
                                                  ),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: AppleTheme.spacing16,
                                        ),
                                        Icon(
                                          CupertinoIcons.flame_fill,
                                          size: 16,
                                          color: AppColors.secondary(context),
                                        ),
                                        const SizedBox(width: 4),
                                        Flexible(
                                          child: Text(
                                            '480 ${l10n.kcalUnit}',
                                            style: AppleTheme.subhead.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.secondary(
                                                context,
                                              ),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: AppleTheme.spacing12,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: AppleButton(
                                        text: l10n.cook,
                                        backgroundColor: AppColors.secondary(
                                          context,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppleTheme.spacing24),

                        // À cuisiner avec tes ingrédients iOS Style
                        Text(
                          l10n.cookWithYourIngredients,
                          style: AppleTheme.title3.copyWith(
                            color: AppleTheme.adaptiveLabel(context),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppleTheme.spacing16),
                        SizedBox(
                          height: 230,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildRecipeCard(
                                l10n.caesarSalad,
                                '15 ${l10n.minutes}',
                                '320 ${l10n.kcalUnit}',
                              ),
                              const SizedBox(width: AppleTheme.spacing12),
                              _buildRecipeCard(
                                l10n.veggiesOmelette,
                                '10 ${l10n.minutes}',
                                '280 ${l10n.kcalUnit}',
                              ),
                              const SizedBox(width: AppleTheme.spacing12),
                              _buildRecipeCard(
                                l10n.pastaCarbonara,
                                '25 ${l10n.minutes}',
                                '550 ${l10n.kcalUnit}',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppleTheme.spacing24),

                        // Suivi du jour iOS Style
                        Text(
                          l10n.dailyTracking,
                          style: AppleTheme.title3.copyWith(
                            color: AppleTheme.adaptiveLabel(context),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppleTheme.spacing16),
                        AppleCard(
                          padding: const EdgeInsets.all(AppleTheme.spacing16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: _buildStatItem(
                                      '🍽️',
                                      l10n.meals,
                                      '3/3',
                                    ),
                                  ),
                                  Container(
                                    width: 0.5,
                                    height: 40,
                                    color: AppleTheme.adaptiveSeparator(
                                      context,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildStatItem(
                                      '💧',
                                      l10n.water,
                                      '1.5L',
                                    ),
                                  ),
                                  Container(
                                    width: 0.5,
                                    height: 40,
                                    color: AppleTheme.adaptiveSeparator(
                                      context,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildStatItem(
                                      '⭐',
                                      l10n.score,
                                      '8.5/10',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppleTheme.spacing16),
                              Container(
                                padding: const EdgeInsets.all(
                                  AppleTheme.spacing12,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.secondary(
                                        context,
                                      ).withOpacity(0.15),
                                      AppColors.secondary(
                                        context,
                                      ).withOpacity(0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppleTheme.radiusLarge,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.flame_fill,
                                      color: AppColors.secondary(context),
                                      size: 20,
                                    ),
                                    const SizedBox(width: AppleTheme.spacing8),
                                    Flexible(
                                      child: Text(
                                        '🔥 ${l10n.healthyDaysStreak}',
                                        style: AppleTheme.callout.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.secondary(context),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppleTheme.spacing24),

                        // Chatbot teaser iOS Style
                        Container(
                          padding: const EdgeInsets.all(AppleTheme.spacing20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppleTheme.systemPurple,
                                AppleTheme.systemPurple.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppleTheme.radiusCard,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '🤖',
                                      style: TextStyle(fontSize: 32),
                                    ),
                                    const SizedBox(height: AppleTheme.spacing8),
                                    Text(
                                      l10n.needIdeas,
                                      style: AppleTheme.headline.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      l10n.askMeRecipe,
                                      style: AppleTheme.subhead.copyWith(
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AppleTheme.spacing12),
                              CupertinoButton(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppleTheme.spacing20,
                                  vertical: AppleTheme.spacing12,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  AppleTheme.radiusButton,
                                ),
                                onPressed: () {},
                                child: Text(
                                  l10n.openChat,
                                  style: AppleTheme.callout.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppleTheme.systemPurple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem(String label, String value, String total) {
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(locale);

    return Column(
      children: [
        Text(
          label,
          style: AppleTheme.caption1.copyWith(
            color: Colors.white.withOpacity(0.75),
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppleTheme.headline.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${l10n.outOf} $total',
          style: AppleTheme.caption2.copyWith(
            color: Colors.white.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildRecipeCard(String title, String time, String calories) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 170,
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(AppleTheme.radiusXLarge),
        border: Border.all(
          color: AppColors.divider(context).withOpacity(0.3),
          width: 0.5,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary(context).withOpacity(0.15),
                  AppColors.primary(context).withOpacity(0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppleTheme.radiusXLarge),
              ),
            ),
            child: Center(
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  CupertinoIcons.heart_fill,
                  size: 24,
                  color: AppColors.primary(context).withOpacity(0.7),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppleTheme.spacing12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppleTheme.calloutEmphasized.copyWith(
                    color: AppleTheme.adaptiveLabel(context),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppleTheme.spacing8),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.clock,
                      size: 12,
                      color: AppleTheme.adaptiveSecondaryLabel(context),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: AppleTheme.caption1.copyWith(
                        color: AppleTheme.adaptiveSecondaryLabel(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      CupertinoIcons.flame_fill,
                      size: 12,
                      color: AppColors.primary(context),
                    ),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        calories,
                        style: AppleTheme.caption1.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String emoji, String label, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppleTheme.footnote.copyWith(
            color: AppleTheme.adaptiveSecondaryLabel(context),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppleTheme.headline.copyWith(
            fontWeight: FontWeight.w700,
            color: AppleTheme.adaptiveLabel(context),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
