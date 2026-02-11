import '../../../data/models/user_model.dart';

class ProfileRepository {
  // Simulated get profile method
  Future<UserModel> getProfile() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // TODO: Replace with actual API call
    // Simulated success response
    return UserModel(
      id: '1',
      email: 'user@example.com',
      name: 'John Doe',
      avatarUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      lastLoginAt: DateTime.now(),
    );

    // Simulated error (uncomment to test error handling)
    // throw Exception('Failed to load profile');
  }

  // Simulated update profile method
  Future<void> updateProfile(UserModel user) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // TODO: Replace with actual API call
    // Success
  }

  // Simulated update avatar method
  Future<void> updateAvatar(String avatarUrl) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // TODO: Replace with actual API call
    // Success
  }

  // Simulated change password method
  Future<void> changePassword(String oldPassword, String newPassword) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // TODO: Replace with actual API call
    // Verify old password and update to new password
    // Success or throw error
  }

  // Simulated delete account method
  Future<void> deleteAccount(String password) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // TODO: Replace with actual API call
    // Verify password and delete account
    // Success or throw error
  }
}
