import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/apple_theme.dart';
import '../../../../shared/widgets/apple_widgets.dart';
import 'package:go_router/go_router.dart';
import '../../../fridge/presentation/screens/barcode_scanner_page.dart';
import '../../../../shared/widgets/chatbot_popup.dart';
import '../../../../shared/widgets/notifications_popup.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _getTodayDate() {
    final now = DateTime.now();
    final days = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche',
    ];
    final months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre',
    ];
    return '${days[now.weekday - 1]} ${now.day} ${months[now.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '👋 Bonjour ',
                                    style: AppleTheme.title2.copyWith(
                                      color: AppleTheme.label,
                                      fontWeight: FontWeight.w600, // iOS 18
                                    ),
                                  ),
                                  Text(
                                    'Ezedine',
                                    style: AppleTheme.title2.copyWith(
                                      color: AppColors.lightSecondary,
                                      fontWeight:
                                          FontWeight.w800, // iOS 18: Plus bold
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ), // iOS 18: Plus d'espace
                              Text(
                                _getTodayDate(),
                                style: AppleTheme.subhead.copyWith(
                                  color: AppleTheme.secondaryLabel,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () =>
                                    showNotificationsPopup(context),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: AppleTheme.backgroundLight,
                                        borderRadius: BorderRadius.circular(
                                          AppleTheme
                                              .radiusLarge, // iOS 18: 14pt
                                        ),
                                        border: Border.all(
                                          color: AppleTheme.separator
                                              .withOpacity(
                                                0.2,
                                              ), // iOS 18: Plus subtil
                                          width: 0.5,
                                        ),
                                        boxShadow: AppleTheme
                                            .cardShadow, // iOS 18: Shadow
                                      ),
                                      child: const Icon(
                                        CupertinoIcons.bell,
                                        size: 20,
                                        color: AppleTheme.label,
                                      ),
                                    ),
                                    Positioned(
                                      right: 2,
                                      top: 2,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.lightBackground,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AppleTheme.spacing8),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () => showChatbotPopup(context),
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.lightAIGradient,
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
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: AppleTheme.spacing20,
                      ), // iOS 18: 20pt
                      // Smart info pill iOS 18
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppleTheme.spacing20, // iOS 18: 20pt
                          vertical: AppleTheme.spacing16, // iOS 18: 16pt
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightSecondary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(
                            AppleTheme.radiusLarge, // iOS 18: 14pt
                          ),
                          border: Border.all(
                            color: AppColors.lightSecondary.withOpacity(
                              0.2,
                            ), // iOS 18: Plus subtil
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              CupertinoIcons.flame,
                              color: AppColors.lightSecondary,
                              size: 18,
                            ),
                            const SizedBox(width: AppleTheme.spacing8),
                            Expanded(
                              child: Text(
                                'Il te reste 650 kcal aujourd\'hui',
                                style: AppleTheme.calloutEmphasized.copyWith(
                                  // iOS 18: CalloutEmphasized
                                  color: AppColors.lightSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
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
                            gradient: AppColors.lightFreshGradient,
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
                                    'Nutrition du jour',
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
                                      fontSize: 44, // iOS 18: Encore plus grand
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      height: 1,
                                    ),
                                  ),
                                  Text(
                                    ' / 2000 kcal',
                                    style: AppleTheme.bodyEmphasized.copyWith(
                                      // iOS 18
                                      color: Colors.white.withOpacity(
                                        0.8,
                                      ), // iOS 18: Meilleur contraste
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
                                      '🥩 Protéines',
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
                                      '🍞 Glucides',
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
                                      '🥑 Lipides',
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
                          'Actions rapides',
                          style: AppleTheme.title3.copyWith(
                            color: AppleTheme.label,
                            fontWeight: FontWeight.w800, // iOS 18: Plus bold
                          ),
                        ),
                        const SizedBox(
                          height: AppleTheme.spacing20,
                        ), // iOS 18: 20pt
                        Row(
                          children: [
                            Expanded(
                              child: AppleQuickActionCard(
                                emoji: '📷',
                                title: 'Scanner',
                                subtitle: 'aliment',
                                accentColor: AppColors.lightPrimary,
                                onTap: () async {
                                  final result = await Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const BarcodeScannerPage(),
                                        ),
                                      );
                                  if (result != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Produit scanné: $result',
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: AppleTheme.spacing12),
                            Expanded(
                              child: AppleQuickActionCard(
                                emoji: '➕',
                                title: 'Ajouter',
                                subtitle: 'repas',
                                accentColor: AppleTheme.systemBlue,
                                onTap: () => context.go('/recettes'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppleTheme.spacing12),
                        Row(
                          children: [
                            Expanded(
                              child: AppleQuickActionCard(
                                emoji: '🤖',
                                title: 'Chat IA',
                                subtitle: 'conseils',
                                accentColor: AppleTheme.systemPurple,
                              ),
                            ),
                            const SizedBox(width: AppleTheme.spacing12),
                            Expanded(
                              child: AppleQuickActionCard(
                                emoji: '🧊',
                                title: 'Mon frigo',
                                subtitle: 'ingrédients',
                                accentColor: AppleTheme.systemOrange,
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
                                'Recette recommandée pour toi',
                                style: AppleTheme.title3.copyWith(
                                  color: AppleTheme.label,
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
                            color: AppleTheme.backgroundLight,
                            borderRadius: BorderRadius.circular(
                              AppleTheme.radiusCard,
                            ),
                            border: Border.all(
                              color: AppleTheme.separator.withOpacity(0.3),
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
                                      AppColors.lightSecondary.withOpacity(0.3),
                                      AppColors.lightSecondary.withOpacity(0.1),
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
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: AppleTheme.backgroundLight,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            CupertinoIcons.heart,
                                            size: 18,
                                            color: AppleTheme.label,
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
                                      '🍝 Poulet curry healthy',
                                      style: AppleTheme.headline.copyWith(
                                        color: AppleTheme.label,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: AppleTheme.spacing8),
                                    Row(
                                      children: [
                                        const Icon(
                                          CupertinoIcons.clock,
                                          size: 16,
                                          color: AppleTheme.secondaryLabel,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '20 min',
                                          style: AppleTheme.subhead.copyWith(
                                            color: AppleTheme.secondaryLabel,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: AppleTheme.spacing16,
                                        ),
                                        const Icon(
                                          CupertinoIcons.flame_fill,
                                          size: 16,
                                          color: AppColors.lightSecondary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '480 kcal',
                                          style: AppleTheme.subhead.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.lightSecondary,
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
                                        text: 'Cuisiner',
                                        backgroundColor:
                                            AppColors.lightSecondary,
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
                          'À cuisiner avec tes ingrédients',
                          style: AppleTheme.title3.copyWith(
                            color: AppleTheme.label,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppleTheme.spacing16),
                        SizedBox(
                          height: 200,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildRecipeCard(
                                'Salade César',
                                '15 min',
                                '320 kcal',
                              ),
                              const SizedBox(width: AppleTheme.spacing12),
                              _buildRecipeCard(
                                'Omelette légumes',
                                '10 min',
                                '280 kcal',
                              ),
                              const SizedBox(width: AppleTheme.spacing12),
                              _buildRecipeCard(
                                'Pâtes carbonara',
                                '25 min',
                                '550 kcal',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppleTheme.spacing24),

                        // Suivi du jour iOS Style
                        Text(
                          'Suivi du jour',
                          style: AppleTheme.title3.copyWith(
                            color: AppleTheme.label,
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
                                  _buildStatItem('🍽️', 'Repas', '3/3'),
                                  Container(
                                    width: 0.5,
                                    height: 40,
                                    color: AppleTheme.separator,
                                  ),
                                  _buildStatItem('💧', 'Eau', '1.5L'),
                                  Container(
                                    width: 0.5,
                                    height: 40,
                                    color: AppleTheme.separator,
                                  ),
                                  _buildStatItem('⭐', 'Score', '8.5/10'),
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
                                      AppColors.lightSecondary.withOpacity(
                                        0.15,
                                      ),
                                      AppColors.lightSecondary.withOpacity(
                                        0.05,
                                      ),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppleTheme.radiusLarge,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      CupertinoIcons.flame_fill,
                                      color: AppColors.lightSecondary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: AppleTheme.spacing8),
                                    Flexible(
                                      child: Text(
                                        '🔥 5 jours healthy d\'affilée',
                                        style: AppleTheme.callout.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.lightSecondary,
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
                                      'Besoin d\'idées ?',
                                      style: AppleTheme.headline.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Demande-moi une recette',
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
                                  'Ouvrir chat',
                                  style: AppleTheme.callout.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppleTheme.systemPurple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100),
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
          'sur $total',
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
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: AppleTheme.backgroundLight,
        borderRadius: BorderRadius.circular(AppleTheme.radiusCard),
        border: Border.all(
          color: AppleTheme.separator.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.lightPrimary.withOpacity(0.2),
                  AppColors.lightPrimary.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppleTheme.radiusCard),
              ),
            ),
            child: Center(
              child: Icon(
                CupertinoIcons.square_fill_on_square_fill,
                size: 40,
                color: AppColors.lightPrimary.withOpacity(0.6),
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
                  style: AppleTheme.callout.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppleTheme.label,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppleTheme.spacing8),
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.clock,
                      size: 12,
                      color: AppleTheme.secondaryLabel,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: AppleTheme.caption1.copyWith(
                        color: AppleTheme.secondaryLabel,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.flame_fill,
                      size: 12,
                      color: AppColors.lightSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      calories,
                      style: AppleTheme.caption1.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightSecondary,
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
          style: AppleTheme.footnote.copyWith(color: AppleTheme.secondaryLabel),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppleTheme.headline.copyWith(
            fontWeight: FontWeight.w700,
            color: AppleTheme.label,
          ),
        ),
      ],
    );
  }
}
