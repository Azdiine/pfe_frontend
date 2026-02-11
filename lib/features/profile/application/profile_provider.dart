import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/profile_repository.dart';
import '../../../data/models/user_model.dart';

// Profile State
class ProfileState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  ProfileState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  bool get hasError => error != null;

  ProfileState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Profile Provider
class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _repository;

  ProfileNotifier(this._repository) : super(ProfileState());

  // Load profile
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _repository.getProfile();
      state = ProfileState(
        user: user,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Update profile
  Future<void> updateProfile(UserModel user) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.updateProfile(user);
      state = ProfileState(
        user: user,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Update avatar
  Future<void> updateAvatar(String avatarUrl) async {
    if (state.user == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.updateAvatar(avatarUrl);
      final updatedUser = state.user!.copyWith(avatarUrl: avatarUrl);
      state = ProfileState(
        user: updatedUser,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Change password
  Future<void> changePassword(String oldPassword, String newPassword) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.changePassword(oldPassword, newPassword);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

// Provider instances
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier(ref.watch(profileRepositoryProvider));
});
