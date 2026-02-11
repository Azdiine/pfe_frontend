import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../application/subscriptions_provider.dart';
import '../widgets/subscription_card.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/empty_state.dart';

class SubscriptionsScreen extends ConsumerStatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  ConsumerState<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends ConsumerState<SubscriptionsScreen> {
  @override
  void initState() {
    super.initState();
    // Load subscriptions on init
    Future.microtask(() {
      ref.read(subscriptionsProvider.notifier).loadSubscriptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionsState = ref.watch(subscriptionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Abonnements'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to add subscription
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ajouter un abonnement')),
              );
            },
          ),
        ],
      ),
      body: subscriptionsState.isLoading
          ? const LoadingIndicator(message: 'Chargement des abonnements...')
          : subscriptionsState.hasError
              ? EmptyState(
                  icon: Icons.error_outline,
                  title: 'Erreur',
                  message: subscriptionsState.error,
                  actionText: 'Réessayer',
                  onAction: () {
                    ref.read(subscriptionsProvider.notifier).loadSubscriptions();
                  },
                )
              : subscriptionsState.subscriptions.isEmpty
                  ? EmptyState(
                      icon: Icons.subscriptions_outlined,
                      title: 'Aucun abonnement',
                      message: 'Vous n\'avez pas encore d\'abonnement actif',
                      actionText: 'Ajouter un abonnement',
                      onAction: () {
                        // TODO: Navigate to add subscription
                      },
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await ref.read(subscriptionsProvider.notifier).loadSubscriptions();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: subscriptionsState.subscriptions.length,
                        itemBuilder: (context, index) {
                          final subscription = subscriptionsState.subscriptions[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: SubscriptionCard(
                              subscription: subscription,
                              onTap: () {
                                // TODO: Navigate to subscription details
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Détails: ${subscription.name}'),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
