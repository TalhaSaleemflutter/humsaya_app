import 'package:hive/hive.dart';
import 'package:humsaya_app/models/user_model.dart';

class UserHiveStorage {
  Future<void> storeUserData(UserModel user) async {
    final box = await Hive.openBox<UserModel>('userBox');
    await box.put('currentUser', user);
    print('Stored User Data: ${user.toMap()}');
  }

  Future<UserModel?> getUserData() async {
    final box = await Hive.openBox<UserModel>('userBox');
    final user = box.get('currentUser');
    return user;
  }

  Future<void> clearUserData() async {
    final box = await Hive.openBox<UserModel>('userBox');
    await box.delete('currentUser');
  }

  Future<void> clearUserId() async {
    final box = await Hive.openBox<UserModel>('userBox');
    await box.delete('currentUser');
  }

  Future<void> updateUserDetails({
    String? name,
    String? phoneNo,
    String? email,
    String? profileImage,
    String? gender,
    bool? isActive,
  }) async {
    final box = await Hive.openBox<UserModel>('userBox');
    final currentUser = box.get('currentUser');
    
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(
        name: name ?? currentUser.name,
        phoneNo: phoneNo ?? currentUser.phoneNo,
        email: email ?? currentUser.email,
        profileImage: profileImage ?? currentUser.profileImage,
        gender: gender ?? currentUser.gender,
        isActive: isActive ?? currentUser.isActive,
      );

      await box.put('currentUser', updatedUser);
      print('Updated Basic User Data in Hive: ${updatedUser.toMap()}');
    }
  }
}
