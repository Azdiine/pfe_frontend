import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/apple_theme.dart';
import '../../../../shared/widgets/apple_widgets.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../data/tracking_service.dart';
import '../widgets/meal_type_picker.dart';

class SuiviPage extends ConsumerStatefulWidget {
  const SuiviPage({super.key});

  @override
  ConsumerState<SuiviPage> createState() => _SuiviPageState();
}

class _SuiviPageState extends ConsumerState<SuiviPage> {
  final TrackingService _trackingService = TrackingService();

  int _selectedPeriod = 0; // 0=Jour, 1=Semaine, 2=Mois

  static const _dayNames = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

  // Objectifs journaliers : calculés par le backend depuis le profil
  // (Mifflin-St Jeor), avec repli sur les valeurs standard 2000 kcal.
  Map<String, dynamic> get _targets =>
      (_today['targets'] as Map<String, dynamic>?) ?? const {};
  double get _goalKcal =>
      _num(_targets['calories']) > 0 ? _num(_targets['calories']) : 2000;
  double get _goalProteinsG =>
      _num(_targets['proteinsG']) > 0 ? _num(_targets['proteinsG']) : 125;
  double get _goalCarbsG =>
      _num(_targets['carbsG']) > 0 ? _num(_targets['carbsG']) : 225;
  double get _goalFatsG =>
      _num(_targets['fatsG']) > 0 ? _num(_targets['fatsG']) : 67;
  int get _goalWaterMl =>
      _num(_targets['waterMl']) > 0 ? _num(_targets['waterMl']).toInt() : 2000;
  bool get _targetsPersonalized => _targets['personalized'] == true;

  // Repas du jour groupés par type (depuis le résumé backend)
  Map<String, List<Map<String, dynamic>>> get _meals {
    final raw = _today['meals'];
    if (raw is! Map) return {};
    return {
      for (final e in raw.entries)
        e.key.toString(): List<Map<String, dynamic>>.from(
          (e.value as List?) ?? const [],
        ),
    };
  }

  bool _loading = true;
  String? _error;
  Map<String, dynamic> _today = {};
  List<Map<String, dynamic>> _range = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  double _num(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        _trackingService.getDay(),
        _trackingService.getRange(days: 30),
      ]);
      if (!mounted) return;
      setState(() {
        _today = results[0] as Map<String, dynamic>;
        _range = results[1] as List<Map<String, dynamic>>;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Impossible de charger votre suivi.';
        _loading = false;
      });
    }
  }

  // ─── Actions rapides ──────────────────────────────────────────────────────

  /// Applique un résumé de jour renvoyé par l'API : met à jour `_today`
  /// et synchronise la ligne correspondante de `_range` (sans re-fetch).
  void _applyDaySummary(Map<String, dynamic> day) {
    if (!mounted) return;
    setState(() {
      _today = day;
      final key = day['logDate']?.toString();
      if (key == null || key.length < 10) return;
      final dateKey = key.substring(0, 10);
      final patch = {
        'caloriesIn': day['caloriesIn'],
        'proteinsG': day['proteinsG'],
        'carbsG': day['carbsG'],
        'fatsG': day['fatsG'],
        'waterMl': day['waterMl'],
        'weightKg': day['weightKg'],
        'caloriesBurned': day['caloriesBurned'],
      };
      final idx = _range.indexWhere(
          (l) => l['logDate']?.toString().substring(0, 10) == dateKey);
      if (idx >= 0) {
        _range[idx] = {..._range[idx], ...patch};
      } else {
        _range.add({'logDate': dateKey, ...patch});
      }
    });
  }

  Future<void> _addWater() async {
    HapticFeedback.lightImpact();
    try {
      final log = await _trackingService.addWater(250);
      _applyDaySummary(log);
    } catch (_) {}
  }

  Future<void> _deleteMealEntry(Map<String, dynamic> entry) async {
    HapticFeedback.lightImpact();
    try {
      final day = await _trackingService.deleteMeal(entry['id'].toString());
      _applyDaySummary(day);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Suppression impossible, réessayez.')),
      );
    }
  }

  /// Saisie manuelle d'un repas (nom + kcal + macros optionnelles).
  Future<void> _addManualMeal(String mealType) async {
    final nameController = TextEditingController();
    final kcalController = TextEditingController();
    final proteinsController = TextEditingController();
    final carbsController = TextEditingController();
    final fatsController = TextEditingController();

    double parse(TextEditingController c) =>
        double.tryParse(c.text.trim().replaceAll(',', '.')) ?? 0;

    final saved = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('${MealTypes.emoji(mealType)} ${MealTypes.label(mealType)}'),
        content: Column(
          children: [
            const SizedBox(height: 12),
            CupertinoTextField(
              controller: nameController,
              placeholder: 'Nom du plat (ex: Salade César)',
            ),
            const SizedBox(height: 8),
            CupertinoTextField(
              controller: kcalController,
              keyboardType: TextInputType.number,
              placeholder: 'Calories (kcal)',
              autofocus: true,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CupertinoTextField(
                    controller: proteinsController,
                    keyboardType: TextInputType.number,
                    placeholder: 'Prot. g',
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: CupertinoTextField(
                    controller: carbsController,
                    keyboardType: TextInputType.number,
                    placeholder: 'Gluc. g',
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: CupertinoTextField(
                    controller: fatsController,
                    keyboardType: TextInputType.number,
                    placeholder: 'Lip. g',
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Annuler'),
            onPressed: () => Navigator.pop(context, false),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ajouter'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (saved != true) return;
    final kcal = parse(kcalController);
    if (kcal <= 0) return;

    try {
      final day = await _trackingService.addMeal(
        calories: kcal,
        proteinsG: parse(proteinsController),
        carbsG: parse(carbsController),
        fatsG: parse(fatsController),
        mealType: mealType,
        name: nameController.text.trim().isNotEmpty
            ? nameController.text.trim()
            : null,
        source: 'manual',
      );
      _applyDaySummary(day);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ajout impossible, réessayez.')),
      );
    }
  }

  Future<void> _editWeight() async {
    final controller = TextEditingController(
      text: _latestWeightValue() > 0
          ? _latestWeightValue().toStringAsFixed(1)
          : '',
    );
    final value = await showCupertinoDialog<double>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Poids du jour'),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: CupertinoTextField(
            controller: controller,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            placeholder: 'kg (ex: 72.5)',
            autofocus: true,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Annuler'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Enregistrer'),
            onPressed: () => Navigator.pop(
              context,
              double.tryParse(controller.text.replaceAll(',', '.')),
            ),
          ),
        ],
      ),
    );
    if (value == null || value < 20 || value > 500) return;
    try {
      final log = await _trackingService.updateDay({'weightKg': value});
      _applyDaySummary(log);
    } catch (_) {}
  }

  Future<void> _editActivity() async {
    final minutesController = TextEditingController(
      text: _num(_today['activityMinutes']) > 0
          ? _num(_today['activityMinutes']).toStringAsFixed(0)
          : '',
    );
    final typeController = TextEditingController(
      text: _today['activityType']?.toString() ?? '',
    );
    final saved = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Activité du jour'),
        content: Column(
          children: [
            const SizedBox(height: 12),
            CupertinoTextField(
              controller: typeController,
              placeholder: 'Type (ex: course, muscu)',
            ),
            const SizedBox(height: 8),
            CupertinoTextField(
              controller: minutesController,
              keyboardType: TextInputType.number,
              placeholder: 'Minutes',
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Annuler'),
            onPressed: () => Navigator.pop(context, false),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Enregistrer'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    if (saved != true) return;
    final minutes = int.tryParse(minutesController.text.trim());
    try {
      final log = await _trackingService.updateDay({
        'activityMinutes': ?minutes,
        if (typeController.text.trim().isNotEmpty)
          'activityType': typeController.text.trim(),
      });
      _applyDaySummary(log);
    } catch (_) {}
  }

  // ─── Données dérivées ─────────────────────────────────────────────────────

  int get _periodDays => _selectedPeriod == 0 ? 1 : (_selectedPeriod == 1 ? 7 : 30);

  List<Map<String, dynamic>> get _periodLogs {
    final since = DateTime.now().subtract(Duration(days: _periodDays - 1));
    final cutoff = DateTime(since.year, since.month, since.day);
    return _range.where((log) {
      final d = DateTime.tryParse(log['logDate']?.toString() ?? '');
      return d != null && !d.isBefore(cutoff);
    }).toList();
  }

  double _periodSum(String field) =>
      _selectedPeriod == 0
          ? _num(_today[field])
          : _periodLogs.fold(0.0, (sum, log) => sum + _num(log[field]));

  double _latestWeightValue() {
    double w = _num(_today['weightKg']);
    if (w == 0) {
      for (final log in _range.reversed) {
        w = _num(log['weightKg']);
        if (w > 0) break;
      }
    }
    return w;
  }

  List<double> get _weightSeries => _range
      .map((log) => _num(log['weightKg']))
      .where((w) => w > 0)
      .toList();

  /// Jours consécutifs (en remontant depuis aujourd'hui) avec un repas loggé.
  int get _streakDays {
    final logged = <String>{};
    for (final log in _range) {
      if (_num(log['caloriesIn']) > 0) {
        logged.add(log['logDate'].toString().substring(0, 10));
      }
    }
    int streak = 0;
    var day = DateTime.now();
    while (true) {
      final key = day.toIso8601String().substring(0, 10);
      if (logged.contains(key)) {
        streak++;
        day = day.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  String _formatKcal(double v) {
    final s = v.toStringAsFixed(0);
    return s.replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(locale);

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary(context),
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            backgroundColor:
                AppColors.background(context).withValues(alpha: 0.92),
            border: Border(
              bottom: BorderSide(
                color: AppleTheme.adaptiveSeparator(context)
                    .withValues(alpha: 0.2),
                width: 0.33,
              ),
            ),
            largeTitle: Text(
              l10n.tracking,
              style: AppleTheme.largeTitleEmphasized.copyWith(
                color: AppleTheme.adaptiveLabel(context),
              ),
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _loadData,
              child: Icon(
                CupertinoIcons.refresh,
                color: AppColors.primary(context),
                size: 22,
              ),
            ),
          ),
          CupertinoSliverRefreshControl(onRefresh: _loadData),

          // Sélecteur de période
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.background(context),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: _selectedPeriod,
                children: {
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
                },
                onValueChanged: (value) {
                  setState(() => _selectedPeriod = value ?? 0);
                },
                backgroundColor: AppColors.backgroundSecondary(context),
                thumbColor: AppColors.surface(context),
                padding: const EdgeInsets.all(4),
              ),
            ),
          ),

          if (_loading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CupertinoActivityIndicator(radius: 14)),
            )
          else if (_error != null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('😔', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: AppleTheme.body.copyWith(
                      color: AppleTheme.adaptiveSecondaryLabel(context),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CupertinoButton(
                    color: AppColors.primary(context),
                    borderRadius: BorderRadius.circular(12),
                    onPressed: _loadData,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            )
          else
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCaloriesCard(l10n),
                    if (_selectedPeriod == 0) ...[
                      const SizedBox(height: 12),
                      _buildMealsCard(),
                    ],
                    const SizedBox(height: 12),
                    _buildMacrosCard(),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildWaterCard()),
                        const SizedBox(width: 12),
                        Expanded(child: _buildActivityCard()),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _buildWeightCard()),
                        const SizedBox(width: 12),
                        Expanded(flex: 2, child: _buildStreakCard()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Historique',
                      style: AppleTheme.title3.copyWith(
                        color: AppleTheme.adaptiveLabel(context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildHistoryCard(l10n),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Carte calories : anneau de progression + repères ─────────────────────

  Widget _buildCaloriesCard(AppLocalizations l10n) {
    final consumed = _periodSum('caloriesIn');
    final burned = _periodSum('caloriesBurned');
    final goal = _goalKcal * _periodDays;
    final remaining = (goal - consumed).clamp(0, goal);
    final progress = goal > 0 ? (consumed / goal).clamp(0.0, 1.0) : 0.0;
    final over = consumed > goal;

    return AppleCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Anneau
          SizedBox(
            width: 132,
            height: 132,
            child: CustomPaint(
              painter: _RingPainter(
                progress: progress,
                color: over ? AppleTheme.systemRed : AppColors.primary(context),
                track: AppColors.backgroundSecondary(context),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatKcal(consumed),
                      style: AppleTheme.title1.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppleTheme.adaptiveLabel(context),
                        height: 1,
                      ),
                    ),
                    Text(
                      l10n.kcalUnit,
                      style: AppleTheme.caption1.copyWith(
                        color: AppleTheme.adaptiveSecondaryLabel(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Repères chiffrés
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _kv('🎯 ${l10n.goal}', '${_formatKcal(goal)} ${l10n.kcalUnit}'),
                const SizedBox(height: 10),
                _kv(
                  over ? '⚠️ Dépassement' : '🍽️ Restant',
                  over
                      ? '+${_formatKcal(consumed - goal)} ${l10n.kcalUnit}'
                      : '${_formatKcal(remaining.toDouble())} ${l10n.kcalUnit}',
                  valueColor: over ? AppleTheme.systemRed : null,
                ),
                if (burned > 0) ...[
                  const SizedBox(height: 10),
                  _kv('🔥 Brûlées', '${_formatKcal(burned)} ${l10n.kcalUnit}'),
                ],
                const SizedBox(height: 10),
                _kv(
                  '📈 Progression',
                  '${(progress * 100).toStringAsFixed(0)} %',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kv(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: AppleTheme.subhead.copyWith(
              color: AppleTheme.adaptiveSecondaryLabel(context),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value,
          style: AppleTheme.subheadEmphasized.copyWith(
            color: valueColor ?? AppleTheme.adaptiveLabel(context),
          ),
        ),
      ],
    );
  }

  // ─── Repas du jour : entrées groupées par type, ajout et suppression ──────

  Widget _buildMealsCard() {
    final meals = _meals;

    return AppleCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Repas du jour',
                style: AppleTheme.subheadEmphasized.copyWith(
                  color: AppleTheme.adaptiveLabel(context),
                ),
              ),
              Text(
                _targetsPersonalized
                    ? 'Objectifs personnalisés'
                    : 'Objectifs standard',
                style: AppleTheme.caption2.copyWith(
                  color: _targetsPersonalized
                      ? AppColors.success
                      : AppleTheme.adaptiveTertiaryLabel(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          for (final (type, emoji, label) in MealTypes.all) ...[
            const SizedBox(height: 10),
            _buildMealTypeSection(
              type: type,
              emoji: emoji,
              label: label,
              entries: meals[type] ?? const [],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMealTypeSection({
    required String type,
    required String emoji,
    required String label,
    required List<Map<String, dynamic>> entries,
  }) {
    final subtotal =
        entries.fold<double>(0, (sum, e) => sum + _num(e['calories']));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppleTheme.subhead.copyWith(
                fontWeight: FontWeight.w600,
                color: AppleTheme.adaptiveLabel(context),
              ),
            ),
            const Spacer(),
            if (subtotal > 0)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  '${subtotal.toStringAsFixed(0)} kcal',
                  style: AppleTheme.footnote.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppleTheme.adaptiveSecondaryLabel(context),
                  ),
                ),
              ),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                _addManualMeal(type);
              },
              child: Icon(
                CupertinoIcons.plus_circle_fill,
                size: 22,
                color: AppColors.primary(context),
              ),
            ),
          ],
        ),
        if (entries.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 26, top: 2),
            child: Text(
              'Rien d\'enregistré',
              style: AppleTheme.caption1.copyWith(
                color: AppleTheme.adaptiveTertiaryLabel(context),
              ),
            ),
          )
        else
          for (final entry in entries)
            Padding(
              padding: const EdgeInsets.only(left: 26, top: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      entry['name']?.toString().isNotEmpty == true
                          ? entry['name'].toString()
                          : 'Repas',
                      style: AppleTheme.subhead.copyWith(
                        color: AppleTheme.adaptiveLabel(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_num(entry['calories']).toStringAsFixed(0)} kcal',
                    style: AppleTheme.footnote.copyWith(
                      color: AppleTheme.adaptiveSecondaryLabel(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _deleteMealEntry(entry),
                    child: Icon(
                      CupertinoIcons.minus_circle,
                      size: 19,
                      color: AppColors.error.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }

  // ─── Macros : 3 jauges à identité fixe ────────────────────────────────────

  Widget _buildMacrosCard() {
    final macros = [
      ('Protéines', _periodSum('proteinsG'), _goalProteinsG * _periodDays,
          AppColors.primary(context)),
      ('Glucides', _periodSum('carbsG'), _goalCarbsG * _periodDays,
          AppleTheme.systemOrange),
      ('Lipides', _periodSum('fatsG'), _goalFatsG * _periodDays,
          AppleTheme.systemPurple),
    ];

    return AppleCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Macronutriments',
            style: AppleTheme.subheadEmphasized.copyWith(
              color: AppleTheme.adaptiveLabel(context),
            ),
          ),
          const SizedBox(height: 14),
          for (final (label, value, goal, color) in macros) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration:
                          BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: AppleTheme.footnote.copyWith(
                        color: AppleTheme.adaptiveSecondaryLabel(context),
                      ),
                    ),
                  ],
                ),
                Text(
                  '${value.toStringAsFixed(0)} / ${goal.toStringAsFixed(0)} g',
                  style: AppleTheme.footnote.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppleTheme.adaptiveLabel(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: goal > 0 ? (value / goal).clamp(0.0, 1.0) : 0,
                backgroundColor: AppColors.backgroundSecondary(context),
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 6,
              ),
            ),
            if (label != 'Lipides') const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  // ─── Eau : jauge en verres ────────────────────────────────────────────────

  Widget _buildWaterCard() {
    final ml = _num(_today['waterMl']).toInt();
    final glasses = (ml / 250).floor().clamp(0, 8);

    return AppleCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '💧 Eau',
                style: AppleTheme.subheadEmphasized.copyWith(
                  color: AppleTheme.adaptiveLabel(context),
                ),
              ),
              GestureDetector(
                onTap: _addWater,
                child: Icon(
                  CupertinoIcons.plus_circle_fill,
                  size: 24,
                  color: AppleTheme.systemBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${(ml / 1000).toStringAsFixed(2)} L',
            style: AppleTheme.title2.copyWith(
              fontWeight: FontWeight.w800,
              color: AppleTheme.adaptiveLabel(context),
            ),
          ),
          Text(
            'sur ${(_goalWaterMl / 1000).toStringAsFixed(0)} L aujourd\'hui',
            style: AppleTheme.caption1.copyWith(
              color: AppleTheme.adaptiveSecondaryLabel(context),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(8, (i) {
              final filled = i < glasses;
              return Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  filled
                      ? CupertinoIcons.drop_fill
                      : CupertinoIcons.drop,
                  size: 15,
                  color: filled
                      ? AppleTheme.systemBlue
                      : AppleTheme.adaptiveTertiaryLabel(context)
                          .withValues(alpha: 0.4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ─── Activité ─────────────────────────────────────────────────────────────

  Widget _buildActivityCard() {
    final minutes = _num(_today['activityMinutes']).toInt();
    final type = _today['activityType']?.toString() ?? '';

    return AppleCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🏃 Activité',
                style: AppleTheme.subheadEmphasized.copyWith(
                  color: AppleTheme.adaptiveLabel(context),
                ),
              ),
              GestureDetector(
                onTap: _editActivity,
                child: Icon(
                  CupertinoIcons.pencil_circle_fill,
                  size: 24,
                  color: AppColors.primary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            minutes > 0 ? '$minutes min' : '—',
            style: AppleTheme.title2.copyWith(
              fontWeight: FontWeight.w800,
              color: AppleTheme.adaptiveLabel(context),
            ),
          ),
          Text(
            type.isNotEmpty ? type : 'aujourd\'hui',
            style: AppleTheme.caption1.copyWith(
              color: AppleTheme.adaptiveSecondaryLabel(context),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (minutes / 60).clamp(0.0, 1.0),
              backgroundColor: AppColors.backgroundSecondary(context),
              valueColor: AlwaysStoppedAnimation(AppColors.primary(context)),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'objectif 60 min',
            style: AppleTheme.caption2.copyWith(
              color: AppleTheme.adaptiveTertiaryLabel(context),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Poids : valeur + tendance 30 jours ───────────────────────────────────

  Widget _buildWeightCard() {
    final weight = _latestWeightValue();
    final series = _weightSeries;
    final delta = series.length >= 2 ? series.last - series.first : 0.0;

    return GestureDetector(
      onTap: _editWeight,
      child: AppleCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '⚖️ Poids',
                  style: AppleTheme.subheadEmphasized.copyWith(
                    color: AppleTheme.adaptiveLabel(context),
                  ),
                ),
                Icon(
                  CupertinoIcons.pencil_circle_fill,
                  size: 24,
                  color: AppleTheme.systemPurple,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  weight > 0 ? weight.toStringAsFixed(1) : '—',
                  style: AppleTheme.title2.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppleTheme.adaptiveLabel(context),
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'kg',
                    style: AppleTheme.caption1.copyWith(
                      color: AppleTheme.adaptiveSecondaryLabel(context),
                    ),
                  ),
                ),
                const Spacer(),
                if (series.length >= 2)
                  Text(
                    '${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(1)} kg / 30j',
                    style: AppleTheme.caption1.copyWith(
                      fontWeight: FontWeight.w600,
                      color: delta <= 0
                          ? AppColors.success
                          : AppleTheme.systemOrange,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 36,
              width: double.infinity,
              child: series.length >= 2
                  ? CustomPaint(
                      painter: _SparklinePainter(
                        values: series,
                        color: AppleTheme.systemPurple,
                      ),
                    )
                  : Center(
                      child: Text(
                        'Enregistrez votre poids pour voir la tendance',
                        style: AppleTheme.caption2.copyWith(
                          color: AppleTheme.adaptiveTertiaryLabel(context),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Série de jours suivis ────────────────────────────────────────────────

  Widget _buildStreakCard() {
    final streak = _streakDays;
    return AppleCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🔥 Série',
            style: AppleTheme.subheadEmphasized.copyWith(
              color: AppleTheme.adaptiveLabel(context),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$streak',
            style: AppleTheme.title1.copyWith(
              fontWeight: FontWeight.w800,
              color: AppleTheme.adaptiveLabel(context),
            ),
          ),
          Text(
            streak > 1 ? 'jours d\'affilée' : 'jour suivi',
            style: AppleTheme.caption1.copyWith(
              color: AppleTheme.adaptiveSecondaryLabel(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            streak == 0
                ? 'Ajoutez un repas pour démarrer !'
                : 'Continuez comme ça 💪',
            style: AppleTheme.caption2.copyWith(
              color: AppleTheme.adaptiveTertiaryLabel(context),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Historique ───────────────────────────────────────────────────────────

  Widget _buildHistoryCard(AppLocalizations l10n) {
    final logs =
        _periodLogs.reversed.take(_selectedPeriod == 2 ? 30 : 7).toList();

    if (logs.isEmpty) {
      return AppleCard(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              const Text('🍽️', style: TextStyle(fontSize: 32)),
              const SizedBox(height: 8),
              Text(
                'Aucun repas enregistré sur cette période.\nAjoutez un plat depuis les recettes ou le chatbot !',
                textAlign: TextAlign.center,
                style: AppleTheme.subhead.copyWith(
                  color: AppleTheme.adaptiveSecondaryLabel(context),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return AppleCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (var i = 0; i < logs.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            _buildDayRow(logs[i], l10n),
          ],
        ],
      ),
    );
  }

  Widget _buildDayRow(Map<String, dynamic> log, AppLocalizations l10n) {
    final date = DateTime.tryParse(log['logDate']?.toString() ?? '');
    final dayLabel =
        date != null ? '${_dayNames[date.weekday - 1]} ${date.day}' : '—';
    final consumed = _num(log['caloriesIn']);
    final progress = consumed / _goalKcal;

    return Row(
      children: [
        SizedBox(
          width: 56,
          child: Text(
            dayLabel,
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
                      '${consumed.toStringAsFixed(0)} ${l10n.kcalUnit}',
                      style: AppleTheme.subhead.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppleTheme.adaptiveLabel(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${_goalKcal.toStringAsFixed(0)} ${l10n.kcalUnit}',
                    style: AppleTheme.footnote.copyWith(
                      color: AppleTheme.adaptiveTertiaryLabel(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
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

// ─── Anneau de progression (trait fin, bouts arrondis) ──────────────────────

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color track;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.track,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 7;
    const stroke = 11.0;

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = track;
    canvas.drawCircle(center, radius, trackPaint);

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress || old.color != color || old.track != track;
}

// ─── Sparkline sobre (ligne 2px, sans grille) ────────────────────────────────

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  final Color color;

  _SparklinePainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final min = values.reduce(math.min);
    final max = values.reduce(math.max);
    final span = (max - min).abs() < 0.001 ? 1.0 : max - min;

    Offset point(int i) {
      final x = i / (values.length - 1) * size.width;
      // Marge verticale pour que la ligne ne colle pas aux bords
      final y = size.height - 4 -
          ((values[i] - min) / span) * (size.height - 8);
      return Offset(x, y);
    }

    final path = Path()..moveTo(point(0).dx, point(0).dy);
    for (var i = 1; i < values.length; i++) {
      path.lineTo(point(i).dx, point(i).dy);
    }

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = color,
    );

    // Point sur la dernière valeur
    canvas.drawCircle(point(values.length - 1), 3.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter old) =>
      old.values != values || old.color != color;
}
