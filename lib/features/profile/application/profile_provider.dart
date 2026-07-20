import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/profile_repository.dart';

// Profile State
class ProfileState {
  final Map<String, dynamic>? profileData;
  final bool isLoading;
  final String? error;

  ProfileState({
    this.profileData,
    this.isLoading = false,
    this.error,
  });

  bool get hasError => error != null;

  // Convenience getters for profile fields
  String? get name => profileData?['profile']?['name'] as String?;
  String? get email => profileData?['email'] as String?;
  String? get birthDate => profileData?['profile']?['birthDate'] as String?;
  String? get gender => profileData?['profile']?['gender'] as String?;
  String? get goal => profileData?['profile']?['goal'] as String?;
  String? get activityLevel => profileData?['profile']?['activityLevel'] as String?;
  String? get dietType => profileData?['profile']?['dietType'] as String?;
  String? get avatarUrl => profileData?['profile']?['avatarUrl'] as String?;
  bool get onboardingDone => profileData?['profile']?['onboardingDone'] == true;
  List<String> get allergies =>
      (profileData?['profile']?['allergies'] as List<dynamic>?)?.cast<String>() ?? [];
  List<String> get healthConditions =>
      (profileData?['profile']?['healthConditions'] as List<dynamic>?)?.cast<String>() ?? [];
  List<String> get cuisinePrefs =>
      (profileData?['profile']?['cuisinePrefs'] as List<dynamic>?)?.cast<String>() ?? [];

  num? get _weightKg {
    final w = profileData?['profile']?['weightKg'];
    if (w == null) return null;
    return num.tryParse(w.toString());
  }
  num? get _heightCm {
    final h = profileData?['profile']?['heightCm'];
    if (h == null) return null;
    return num.tryParse(h.toString());
  }
  num? get _targetWeightKg {
    final t = profileData?['profile']?['targetWeightKg'];
    if (t == null) return null;
    return num.tryParse(t.toString());
  }

  String get weightDisplay => _weightKg != null ? '${_weightKg!.toStringAsFixed(1)} kg' : '--';
  String get heightDisplay => _heightCm != null ? '${_heightCm!.toStringAsFixed(0)} cm' : '--';
  String get targetWeightDisplay => _targetWeightKg != null ? '${_targetWeightKg!.toStringAsFixed(1)} kg' : '--';

  ProfileState copyWith({
    Map<String, dynamic>? profileData,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      profileData: profileData ?? this.profileData,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Profile Provider
class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _repository;

  ProfileNotifier(this._repository) : super(ProfileState());

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _repository.getProfile();
      state = ProfileState(profileData: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.updateProfile(data);
      await loadProfile();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
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
