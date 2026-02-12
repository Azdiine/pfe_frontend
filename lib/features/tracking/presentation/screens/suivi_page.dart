import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/apple_theme.dart';
import '../../../../shared/widgets/apple_widgets.dart';

class SuiviPage extends StatefulWidget {
  const SuiviPage({super.key});

  @override
  State<SuiviPage> createState() => _SuiviPageState();
}

class _SuiviPageState extends State<SuiviPage> {
  int _selectedPeriod = 1; // 0=Jour, 1=Semaine, 2=Mois, 3=Année

  final Map<int, Widget> _periods = const {
    0: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text('Jour'),
    ),
    1: Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Text('Semaine'),
    ),
    2: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text('Mois'),
    ),
    3: Padding(
      padding: EdgeInsets.symmetric(horizontal: 14),
      child: Text('Année'),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppleTheme.secondaryBackgroundLight,
      body: CustomScrollView(
        slivers: [
          // iOS 18 Navigation Bar
          CupertinoSliverNavigationBar(
            backgroundColor: AppleTheme.backgroundLight.withOpacity(
              0.92,
            ), // iOS 18
            border: Border(
              bottom: BorderSide(
                color: AppleTheme.separator.withOpacity(0.2), // iOS 18
                width: 0.33, // iOS 18
              ),
            ),
            largeTitle: Text(
              'Suivi',
              style: AppleTheme.largeTitleEmphasized.copyWith(
                // iOS 18
                color: AppleTheme.label,
              ),
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 0,
              onPressed: () {},
              child: const Icon(
                CupertinoIcons.calendar,
                color: AppColors.lightPrimary,
                size: 22,
              ),
            ),
          ),

          // Period selector iOS 18
          SliverToBoxAdapter(
            child: Container(
              color: AppleTheme.backgroundLight,
              padding: const EdgeInsets.fromLTRB(
                AppleTheme.spacing20, // iOS 18: 20pt
                AppleTheme.spacing12,
                AppleTheme.spacing20,
                AppleTheme.spacing20, // iOS 18: 20pt
              ),
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: _selectedPeriod,
                children: _periods,
                onValueChanged: (value) {
                  setState(() {
                    _selectedPeriod = value ?? 1;
                  });
                },
                backgroundColor: AppleTheme.secondaryBackgroundLight,
                thumbColor: AppleTheme.backgroundLight,
                padding: const EdgeInsets.all(4),
              ),
            ),
          ),

          // Content iOS 18
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(
                AppleTheme.spacing24,
              ), // iOS 18: 24pt
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calories card iOS 18
                  Container(
                    padding: const EdgeInsets.all(
                      AppleTheme.spacing24,
                    ), // iOS 18: 24pt
                    decoration: BoxDecoration(
                      gradient: AppColors.lightFreshGradient,
                      borderRadius: BorderRadius.circular(
                        AppleTheme.radiusCard,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Calories cette semaine',
                              style: AppleTheme.callout.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const Icon(
                              CupertinoIcons.flame_fill,
                              color: Colors.white,
                              size: 24,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppleTheme.spacing16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '10,250',
                              style: AppleTheme.largeTitle.copyWith(
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                            Text(
                              ' kcal',
                              style: AppleTheme.body.copyWith(
                                color: Colors.white.withOpacity(0.75),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppleTheme.spacing8),
                        Text(
                          'Objectif: 14,000 kcal',
                          style: AppleTheme.subhead.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: AppleTheme.spacing16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppleTheme.radiusSmall,
                          ),
                          child: LinearProgressIndicator(
                            value: 0.73,
                            backgroundColor: Colors.white.withOpacity(0.25),
                            valueColor: const AlwaysStoppedAnimation(
                              Colors.white,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppleTheme.spacing24),

                  // Stats grid iOS
                  Text(
                    'Statistiques',
                    style: AppleTheme.title3.copyWith(
                      color: AppleTheme.label,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppleTheme.spacing16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          '💧',
                          'Eau',
                          '10.5 L',
                          'cette semaine',
                          AppleTheme.systemBlue,
                        ),
                      ),
                      const SizedBox(width: AppleTheme.spacing12),
                      Expanded(
                        child: _buildStatCard(
                          '🏃',
                          'Activité',
                          '3.2 h',
                          'cette semaine',
                          AppColors.lightPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppleTheme.spacing12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          '⚖️',
                          'Poids',
                          '72.5 kg',
                          '-1.5 kg',
                          AppleTheme.systemPurple,
                        ),
                      ),
                      const SizedBox(width: AppleTheme.spacing12),
                      Expanded(
                        child: _buildStatCard(
                          '⭐',
                          'Score moyen',
                          '8.7/10',
                          'très bien',
                          AppleTheme.systemOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppleTheme.spacing24),

                  // Weekly summary iOS
                  Text(
                    'Résumé hebdomadaire',
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
                        _buildDayRow('Lun', 1850, 2000, 0.92),
                        const SizedBox(height: AppleTheme.spacing12),
                        _buildDayRow('Mar', 1920, 2000, 0.96),
                        const SizedBox(height: AppleTheme.spacing12),
                        _buildDayRow('Mer', 1780, 2000, 0.89),
                        const SizedBox(height: AppleTheme.spacing12),
                        _buildDayRow('Jeu', 2050, 2000, 1.0),
                        const SizedBox(height: AppleTheme.spacing12),
                        _buildDayRow('Ven', 1900, 2000, 0.95),
                        const SizedBox(height: AppleTheme.spacing12),
                        _buildDayRow('Sam', 1950, 2000, 0.97),
                        const SizedBox(height: AppleTheme.spacing12),
                        _buildDayRow('Dim', 1800, 2000, 0.90),
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
    );
  }

  Widget _buildStatCard(
    String emoji,
    String label,
    String value,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppleTheme.spacing16),
      decoration: BoxDecoration(
        color: AppleTheme.backgroundLight,
        borderRadius: BorderRadius.circular(AppleTheme.radiusCard),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: AppleTheme.spacing12),
          Text(
            label,
            style: AppleTheme.subhead.copyWith(
              color: AppleTheme.secondaryLabel,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppleTheme.title2.copyWith(
              fontWeight: FontWeight.w800,
              color: AppleTheme.label,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppleTheme.caption1.copyWith(
              fontWeight: FontWeight.w500,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDayRow(String day, int consumed, int target, double progress) {
    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Text(
            day,
            style: AppleTheme.subhead.copyWith(
              fontWeight: FontWeight.w600,
              color: AppleTheme.secondaryLabel,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '$consumed kcal',
                      style: AppleTheme.subhead.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppleTheme.label,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '$target kcal',
                    style: AppleTheme.footnote.copyWith(
                      color: AppleTheme.tertiaryLabel,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppleTheme.radiusSmall),
                child: LinearProgressIndicator(
                  value: progress > 1 ? 1 : progress,
                  backgroundColor: AppleTheme.secondaryBackgroundLight,
                  valueColor: AlwaysStoppedAnimation(
                    progress > 1
                        ? AppleTheme.systemRed
                        : AppColors.lightSecondary,
                  ),
                  minHeight: 4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
