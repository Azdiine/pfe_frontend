import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../application/profile_provider.dart';
import '../../../auth/application/auth_provider.dart';
import '../widgets/profile_card.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/custom_button.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load profile data on init
    Future.microtask(() {
      ref.read(profileProvider.notifier).loadProfile();
    });
  }

  void _handleLogout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      await ref.read(authProvider.notifier).logout();
      if (mounted) {
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit profile
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Modifier le profil')),
              );
            },
          ),
        ],
      ),
      body: profileState.isLoading
          ? const LoadingIndicator(message: 'Chargement du profil...')
          : profileState.hasError
              ? EmptyState(
                  icon: Icons.error_outline,
                  title: 'Erreur',
                  message: profileState.error,
                  actionText: 'Réessayer',
                  onAction: () {
                    ref.read(profileProvider.notifier).loadProfile();
                  },
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Profile Header
                      Center(
                        child: Column(
                          children: [
                            // Avatar
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: Text(
                                authState.user?.name.substring(0, 1).toUpperCase() ?? 'U',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Name
                            Text(
                              authState.user?.name ?? 'User',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),

                            // Email
                            Text(
                              authState.user?.email ?? 'email@example.com',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Profile Cards
                      ProfileCard(
                        icon: Icons.person,
                        title: 'Informations personnelles',
                        subtitle: 'Gérer vos informations',
                        onTap: () {
                          // TODO: Navigate to personal info
                        },
                      ),
                      const SizedBox(height: 12),

                      ProfileCard(
                        icon: Icons.lock,
                        title: 'Sécurité',
                        subtitle: 'Mot de passe et authentification',
                        onTap: () {
                          // TODO: Navigate to security settings
                        },
                      ),
                      const SizedBox(height: 12),

                      ProfileCard(
                        icon: Icons.notifications,
                        title: 'Notifications',
                        subtitle: 'Gérer vos préférences',
                        onTap: () {
                          // TODO: Navigate to notification settings
                        },
                      ),
                      const SizedBox(height: 12),

                      ProfileCard(
                        icon: Icons.language,
                        title: 'Langue',
                        subtitle: 'Français',
                        onTap: () {
                          // TODO: Navigate to language settings
                        },
                      ),
                      const SizedBox(height: 12),

                      ProfileCard(
                        icon: Icons.help,
                        title: 'Aide et support',
                        subtitle: 'FAQ et contact',
                        onTap: () {
                          // TODO: Navigate to help
                        },
                      ),
                      const SizedBox(height: 12),

                      ProfileCard(
                        icon: Icons.info,
                        title: 'À propos',
                        subtitle: 'Version 1.0.0',
                        onTap: () {
                          // TODO: Navigate to about
                        },
                      ),
                      const SizedBox(height: 32),

                      // Logout Button
                      CustomButton(
                        text: 'Se déconnecter',
                        onPressed: _handleLogout,
                        backgroundColor: Colors.red,
                        width: double.infinity,
                        icon: Icons.logout,
                      ),
                    ],
                  ),
                ),
    );
  }
}
