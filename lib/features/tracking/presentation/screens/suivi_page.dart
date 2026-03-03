import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/apple_theme.dart';
import '../../../../shared/widgets/apple_widgets.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../../core/localization/app_localizations.dart';

class SuiviPage extends ConsumerStatefulWidget {
  const SuiviPage({super.key});

  @override
  ConsumerState<SuiviPage> createState() => _SuiviPageState();
}

class _SuiviPageState extends ConsumerState<SuiviPage> {
  int _selectedPeriod = 1; // 0=Jour, 1=Semaine, 2=Mois, 3=Année

  Map<int, Widget> _buildPeriods(AppLocalizations l10n) {
    return {
      0: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(l10n.day),
      ),
      1: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(l10n.week),
      ),
      2: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(l10n.month),
      ),
      3: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Text(l10n.year),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(locale);
    final periods = _buildPeriods(l10n);

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary(context),
      body: CustomScrollView(
        slivers: [
          // iOS 18 Navigation Bar
          CupertinoSliverNavigationBar(
            backgroundColor: AppColors.background(
              context,
            ).withOpacity(0.92), // iOS 18
            border: Border(
              bottom: BorderSide(
                color: AppleTheme.adaptiveSeparator(
                  context,
                ).withOpacity(0.2), // iOS 18
                width: 0.33, // iOS 18
              ),
            ),
            largeTitle: Text(
              l10n.tracking,
              style: AppleTheme.largeTitleEmphasized.copyWith(
                // iOS 18
                color: AppleTheme.adaptiveLabel(context),
              ),
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: Icon(
                CupertinoIcons.calendar,
                color: AppColors.primary(context),
                size: 22,
              ),
            ),
          ),

          // Period selector iOS 18
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.background(context),
              padding: const EdgeInsets.fromLTRB(
                AppleTheme.spacing20, // iOS 18: 20pt
                AppleTheme.spacing12,
                AppleTheme.spacing20,
                AppleTheme.spacing20, // iOS 18: 20pt
              ),
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: _selectedPeriod,
                children: periods,
                onValueChanged: (value) {
                  setState(() {
                    _selectedPeriod = value ?? 1;
                  });
                },
                backgroundColor: AppColors.backgroundSecondary(context),
                thumbColor: AppColors.surface(context),
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
                      gradient: AppColors.primaryGradient(context),
                      borderRadius: BorderRadius.circular(
                        AppleTheme.radiusXLarge,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                l10n.caloriesThisWeek,
                                style: AppleTheme.callout.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                            Flexible(
                              child: Text(
                                ' ${l10n.kcalUnit}',
                                style: AppleTheme.body.copyWith(
                                  color: Colors.white.withOpacity(0.75),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppleTheme.spacing8),
                        Text(
                          '${l10n.goal}: 14,000 ${l10n.kcalUnit}',
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
                    l10n.statistics,
                    style: AppleTheme.title3.copyWith(
                      color: AppleTheme.adaptiveLabel(context),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppleTheme.spacing16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          '💧',
                          l10n.water,
                          '10.5 L',
                          l10n.thisWeek,
                          AppleTheme.systemBlue,
                        ),
                      ),
                      const SizedBox(width: AppleTheme.spacing12),
                      Expanded(
                        child: _buildStatCard(
                          '🏃',
                          l10n.activity,
                          '3.2 h',
                          l10n.thisWeek,
                          AppColors.primary(context),
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
                          l10n.weight,
                          '72.5 kg',
                          '-1.5 kg',
                          AppleTheme.systemPurple,
                        ),
                      ),
                      const SizedBox(width: AppleTheme.spacing12),
                      Expanded(
                        child: _buildStatCard(
                          '⭐',
                          l10n.averageScore,
                          '8.7/10',
                          l10n.veryGood,
                          AppleTheme.systemOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppleTheme.spacing24),

                  // Weekly summary iOS
                  Text(
                    l10n.weeklySummary,
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
                        _buildDayRow(l10n.mondayShort, 1850, 2000, 0.92),
                        const SizedBox(height: AppleTheme.spacing12),
                        _buildDayRow(l10n.tuesdayShort, 1920, 2000, 0.96),
                        const SizedBox(height: AppleTheme.spacing12),
                        _buildDayRow(l10n.wednesdayShort, 1780, 2000, 0.89),
                        const SizedBox(height: AppleTheme.spacing12),
                        _buildDayRow(l10n.thursdayShort, 2050, 2000, 1.0),
                        const SizedBox(height: AppleTheme.spacing12),
                        _buildDayRow(l10n.fridayShort, 1900, 2000, 0.95),
                        const SizedBox(height: AppleTheme.spacing12),
                        _buildDayRow(l10n.saturdayShort, 1950, 2000, 0.97),
                        const SizedBox(height: AppleTheme.spacing12),
                        _buildDayRow(l10n.sundayShort, 1800, 2000, 0.90),
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
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(AppleTheme.radiusXLarge),
        border: Border.all(
          color: AppColors.divider(context).withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppleTheme.radiusMedium),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(height: AppleTheme.spacing12),
          Text(
            label,
            style: AppleTheme.subhead.copyWith(
              color: AppleTheme.adaptiveSecondaryLabel(context),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppleTheme.title2.copyWith(
              fontWeight: FontWeight.w800,
              color: AppleTheme.adaptiveLabel(context),
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
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(locale);

    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Text(
            day,
            style: AppleTheme.subhead.copyWith(
              fontWeight: FontWeight.w600,
              color: AppleTheme.adaptiveSecondaryLabel(context),
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
                      '$consumed ${l10n.kcalUnit}',
                      style: AppleTheme.subhead.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppleTheme.adaptiveLabel(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '$target ${l10n.kcalUnit}',
                    style: AppleTheme.footnote.copyWith(
                      color: AppleTheme.adaptiveTertiaryLabel(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppleTheme.radiusSmall),
                child: LinearProgressIndicator(
                  value: progress > 1 ? 1 : progress,
                  backgroundColor: AppColors.backgroundSecondary(context),
                  valueColor: AlwaysStoppedAnimation(
                    progress > 1
                        ? AppleTheme.systemRed
                        : AppColors.secondary(context),
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
