import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/apple_theme.dart';

class NotificationsPopup extends StatelessWidget {
  const NotificationsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'icon': CupertinoIcons.checkmark_seal_fill,
        'color': AppColors.success,
        'title': 'Recette ajoutée',
        'message': 'Votre recette préférée a été ajoutée avec succès!',
        'time': 'Il y a 5 min',
        'isNew': true,
      },
      {
        'icon': CupertinoIcons.star_fill,
        'color': AppColors.lightSecondary,
        'title': 'Nouvelle recette tendance',
        'message': 'Découvrez la recette du jour: Pad Thai aux crevettes',
        'time': 'Il y a 1h',
        'isNew': true,
      },
      {
        'icon': CupertinoIcons.bell_fill,
        'color': AppColors.lightPrimary,
        'title': 'Rappel de courses',
        'message': 'N\'oubliez pas d\'acheter les ingrédients pour ce soir',
        'time': 'Il y a 3h',
        'isNew': false,
      },
      {
        'icon': CupertinoIcons.heart_fill,
        'color': Colors.pink,
        'title': 'Recette recommandée',
        'message': 'Vous pourriez aimer la Tarte aux pommes caramélisées',
        'time': 'Hier',
        'isNew': false,
      },
      {
        'icon': CupertinoIcons.flame_fill,
        'color': Colors.deepOrange,
        'title': 'Défi complété',
        'message':
            'Bravo! Vous avez cuisiné 5 nouvelles recettes cette semaine',
        'time': 'Il y a 2 jours',
        'isNew': false,
      },
    ];

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
                Expanded(
                  child: Text(
                    'Notifications',
                    style: AppleTheme.largeTitle.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    // Marquer toutes comme lues
                  },
                  child: Text(
                    'Tout lire',
                    style: AppleTheme.body.copyWith(
                      color: AppColors.lightPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
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

          // Notifications List
          Expanded(
            child: notifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notif = notifications[index];
                      return _buildNotificationItem(
                        notif['icon'] as IconData,
                        notif['color'] as Color,
                        notif['title'] as String,
                        notif['message'] as String,
                        notif['time'] as String,
                        notif['isNew'] as bool,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    IconData icon,
    Color color,
    String title,
    String message,
    String time,
    bool isNew,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isNew
            ? AppColors.lightPrimary.withOpacity(0.05)
            : AppleTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppleTheme.separator.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.all(16),
        onPressed: () {
          // Action sur clic notification
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppleTheme.subhead.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppleTheme.label,
                          ),
                        ),
                      ),
                      if (isNew)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.lightPrimary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: AppleTheme.callout.copyWith(
                      color: AppleTheme.secondaryLabel,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    time,
                    style: AppleTheme.caption1.copyWith(
                      color: AppleTheme.tertiaryLabel,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppleTheme.secondaryBackgroundLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              CupertinoIcons.bell,
              size: 40,
              color: AppleTheme.tertiaryLabel,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune notification',
            style: AppleTheme.title2.copyWith(
              fontWeight: FontWeight.w700,
              color: AppleTheme.label,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vous êtes à jour!',
            style: AppleTheme.body.copyWith(color: AppleTheme.secondaryLabel),
          ),
        ],
      ),
    );
  }
}

void showNotificationsPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const NotificationsPopup(),
  );
}
