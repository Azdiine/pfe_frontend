import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/subscriptions_repository.dart';
import '../../../data/models/subscription_model.dart';

// Subscriptions State
class SubscriptionsState {
  final List<SubscriptionModel> subscriptions;
  final bool isLoading;
  final String? error;

  SubscriptionsState({
    this.subscriptions = const [],
    this.isLoading = false,
    this.error,
  });

  bool get hasError => error != null;

  SubscriptionsState copyWith({
    List<SubscriptionModel>? subscriptions,
    bool? isLoading,
    String? error,
  }) {
    return SubscriptionsState(
      subscriptions: subscriptions ?? this.subscriptions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Subscriptions Provider
class SubscriptionsNotifier extends StateNotifier<SubscriptionsState> {
  final SubscriptionsRepository _repository;

  SubscriptionsNotifier(this._repository) : super(SubscriptionsState());

  // Load all subscriptions
  Future<void> loadSubscriptions() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final subscriptions = await _repository.getSubscriptions();
      state = SubscriptionsState(
        subscriptions: subscriptions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Add a new subscription
  Future<void> addSubscription(SubscriptionModel subscription) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.addSubscription(subscription);
      await loadSubscriptions(); // Reload after adding
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Cancel a subscription
  Future<void> cancelSubscription(String subscriptionId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.cancelSubscription(subscriptionId);
      await loadSubscriptions(); // Reload after canceling
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Get active subscriptions
  List<SubscriptionModel> getActiveSubscriptions() {
    return state.subscriptions.where((sub) => sub.isActive).toList();
  }

  // Get inactive subscriptions
  List<SubscriptionModel> getInactiveSubscriptions() {
    return state.subscriptions.where((sub) => !sub.isActive).toList();
  }
}

// Provider instances
final subscriptionsRepositoryProvider = Provider<SubscriptionsRepository>((ref) {
  return SubscriptionsRepository();
});

final subscriptionsProvider = StateNotifierProvider<SubscriptionsNotifier, SubscriptionsState>((ref) {
  return SubscriptionsNotifier(ref.watch(subscriptionsRepositoryProvider));
});
