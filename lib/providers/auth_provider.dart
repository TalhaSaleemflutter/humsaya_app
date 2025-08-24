import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:humsaya_app/database/hive/user_hive.dart';
import 'package:humsaya_app/models/location_model.dart';
import 'package:humsaya_app/models/user_model.dart';
import 'package:humsaya_app/views/auth/login_screen.dart';
import 'package:humsaya_app/views/home/dashboard_screen.dart';
import 'package:humsaya_app/widgets/custom_dialogs/custom_cupertino_dialog.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  LocationModel? location;

  String? _currentAddress;
  String? get currentAddress => _currentAddress;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _verificationId;
  Position? currentPosition;

  void setCurrentUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void printUserData(UserModel user) {
    print(user);
  }

  void updateSelectedLocation(String address, double? lat, double? lng) {
    var selectedLocation = {'address': address, 'lat': lat, 'lng': lng};
    notifyListeners();
  }

  Future<void> addUserToFirestore(UserModel user, BuildContext context) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
      await UserHiveStorage().storeUserData(user);
      setCurrentUser(user);
    } catch (e) {
      throw Exception('Failed to handle user in Firestore: $e');
    }
  }

  UserModel _currentUser = UserModel(
    uid: '',
    name: '',
    phoneNo: '',
    email: '',
    password: '',
    location: LocationModel(
      neighborLocation: '',
      streetNumber: '',
      houseAddress: '',
      city: '',
      state: '',
      zipCode: '',
      country: '',
    ),
    isActive: true,
    profileImage: '',
    gender: '',
    createdAt: DateTime.now(),
  );
  UserModel get currentUser => _currentUser;

  Future<void> clearUser() async {
    await UserHiveStorage().clearUserData();
    _currentUser = UserModel(
      uid: '',
      name: '',
      phoneNo: '',
      email: '',
      password: '',
      location: LocationModel(
        neighborLocation: '',
        streetNumber: '',
        houseAddress: '',
        city: '',
        state: '',
        zipCode: '',
        country: '',
      ),
      isActive: true,
      profileImage: '',
      gender: '',
      createdAt: DateTime.now(),
    );
    notifyListeners();
  }

  void updateCurrentUserFields(String field, dynamic value) {
    if (_currentUser == null) {
      _currentUser = UserModel(
        name: '',
        phoneNo: '',
        email: '',
        password: '',
        uid: '',
        location: null,
        isActive: true,
        profileImage: '',
        gender: '',
        createdAt: DateTime.now(),
      );
    }
    _currentUser = _currentUser.copyWith(
      name: field == 'name' ? value as String : _currentUser.name,
      phoneNo: field == 'phoneNo' ? value as String : _currentUser.phoneNo,
      email: field == 'email' ? value as String : _currentUser.email,
      password: field == 'password' ? value as String : _currentUser.password,
      gender: field == 'gender' ? value as String : _currentUser.gender,
    );
    notifyListeners();
  }

  Future<void> updateProfileFields({
    required String userId,
    String? newName,
    String? newGender,
    String? newProfileImage,
  }) async {
    try {
      final updateData = {
        if (newName != null) 'name': newName,
        if (newGender != null) 'gender': newGender,
        if (newProfileImage != null) 'profileImage': newProfileImage,
      };
      await _firestore.collection('users').doc(userId).update(updateData);
      if (_currentUser.uid == userId) {
        _currentUser = _currentUser.copyWith(
          name: newName ?? _currentUser.name,
          gender: newGender ?? _currentUser.gender,
          profileImage: newProfileImage ?? _currentUser.profileImage,
        );
        await UserHiveStorage().storeUserData(_currentUser);
      }
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  Future<void> signUp({
    required UserModel userModel,
    required BuildContext context,
    required String confirmPassword,
  }) async {
    if (userModel.password != confirmPassword) {
      cupertinoDialog(context, 'Confirm Password does not match');
      return;
    }
    try {
      _isLoading = true;
      notifyListeners();
      List<String> providers = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(userModel.email);
      if (providers.isNotEmpty) {
        cupertinoDialog(
          context,
          'Email is already registered. Please sign in instead.',
        );
        _isLoading = false;
        notifyListeners();
        return;
      }
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: userModel.email.toString(),
            password: userModel.password.toString(),
          );
      userModel.uid = userCredential.user?.uid ?? '';
      print('UserModel: ${userModel.toMap()}');

      await addUserToFirestore(userModel, context);
      print('User added to Firestore');

      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        cupertinoDialog(
          context,
          'Email is already registered. Please sign in instead.',
        );
      } else {
        cupertinoDialog(context, 'Error: ${e.message}');
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error during signUp: $e');
      cupertinoDialog(context, "Error: ${e.toString()}");
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyPhoneNumber(
    String phoneNumber,
    BuildContext context,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();
      if (phoneNumber.isEmpty) {
        throw Exception("Phone number is empty");
      }
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
          _isLoading = false;
          notifyListeners();
        },
        verificationFailed: (FirebaseAuthException e) {
          cupertinoDialog(context, "Verification Failed: ${e.message}");
          _isLoading = false;
          notifyListeners();
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _isLoading = false;
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      cupertinoDialog(context, "Error: ${e.toString()}");
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyOTP(String otp, BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      await _firebaseAuth.signInWithCredential(credential);
      //await _firebaseAuth.signOut();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      cupertinoDialog(context, 'Error: ${e.toString()}');
      return false;
    }
  }

  Future<String> loginWithPhoneNumberAndPassword({
    required String phoneNo,
    required String password,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final QuerySnapshot result =
          await FirebaseFirestore.instance
              .collection('users')
              .where('phoneNo', isEqualTo: phoneNo)
              .where('password', isEqualTo: password)
              .limit(1)
              .get();
      if (result.docs.isNotEmpty) {
        final userDoc = result.docs.first;
        final userData = userDoc.data() as Map<String, dynamic>;
        print('Login successful for user: ${userData['phoneNo']}');
        _isLoading = false;
        notifyListeners();
        return 'Login successful';
      } else {
        cupertinoDialog(context, 'Invalid phone number or password.');
        _isLoading = false;
        notifyListeners();
        return 'Invalid phone number or password';
      }
    } catch (e) {
      print('Error during login: ${e.toString()}');
      cupertinoDialog(context, 'Error: ${e.toString()}');
      _isLoading = false;
      notifyListeners();
      return 'Error during login';
    }
  }

  // Future<String> signInWithEmail({
  //   required UserModel userModel,
  //   required BuildContext context,
  // }) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   try {
  //     if (userModel.email.isNotEmpty && userModel.password.isNotEmpty) {
  //       var userCredential = await _firebaseAuth.signInWithEmailAndPassword(
  //         email: userModel.email.toString(),
  //         password: userModel.password.toString(),
  //       );
  //       await fetchUserData(userCredential.user?.uid ?? '', context);
  //       _isLoading = false;
  //       notifyListeners();
  //       return 'Sign in successful';
  //     } else {
  //       cupertinoDialog(context, 'Write the Email and Password');
  //     }
  //   } catch (e) {
  //     cupertinoDialog(context, 'Error: ${e.toString()}');
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  //   return '';
  // }

  Future<String> signInWithEmail({
    required UserModel userModel, 
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (userModel.email.isNotEmpty && userModel.password.isNotEmpty) {
        var userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: userModel.email.toString(),
          password: userModel.password.toString(),
        );
        bool isActiveUser = await fetchUserData(
          userCredential.user?.uid ?? '',
          context,
        );
        if (!isActiveUser) {
          _isLoading = false;
          notifyListeners();
          return 'Account deactivated';
        }
        _isLoading = false;
        notifyListeners();
        return 'Sign in successful';
      } else {
        cupertinoDialog(context, 'Write the Email and Password');
      }
    } catch (e) {
      cupertinoDialog(context, 'This User has Blocked');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return '';
  }

  Future<bool> fetchUserData(String uid, BuildContext context) async {
    bool isUserAvailable = false;
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(uid).get();

      if (snapshot.exists) {
        final user = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);

        if (user.isActive == false) {
          cupertinoDialog(
            context,
            'Your account is deactivated. Contact support for assistance.',
          );
          return false;
        }

        user.uid = uid;
        await UserHiveStorage().storeUserData(user);
        setCurrentUser(user);
        isUserAvailable = true;
      }
      return isUserAvailable;
    } catch (e) {
      cupertinoDialog(context, 'Error fetching data: ${e.toString()}');
      rethrow;
    }
  }

  //  Future<bool> fetchUserData(String uid, BuildContext context) async {
  //   bool isUserAvailable = false;
  //   try {
  //     DocumentSnapshot snapshot =
  //         await _firestore.collection('users').doc(uid).get();
  //     if (snapshot.exists) {
  //       final user = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
  //       user.uid = uid;
  //       await UserHiveStorage().storeUserData(user);
  //       setCurrentUser(user);
  //       isUserAvailable = true;
  //     }
  //     return isUserAvailable;
  //   } catch (e) {
  //     cupertinoDialog(context, 'Error fetching data: ${e.toString()}');
  //     rethrow;
  //   }
  // }

  Future<void> changeAuthPassword({
    required String currentPassword,
    required String newPassword,
    required BuildContext context,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception("User not authenticated");
      }
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      _isLoading = false;
      notifyListeners();

      cupertinoDialog(context, "Password updated successfully");
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      String errorMessage = "Error changing password";
      if (e.code == 'wrong-password') {
        errorMessage = "Current password is incorrect";
      } else if (e.code == 'weak-password') {
        errorMessage = "New password is too weak";
      }
      cupertinoDialog(context, errorMessage);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      cupertinoDialog(context, "Error: ${e.toString()}");
    }
  }

  Future<void> updateFirestorePassword({
    required String userId,
    required String newPassword,
    required BuildContext context,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _firestore.collection('users').doc(userId).update({
        'password': newPassword,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      cupertinoDialog(
        context,
        "Error updating password in database: ${e.toString()}",
      );
    }
  }

  Future<void> sendPasswordResetEmail({
    required String email,
    required BuildContext context,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      final trimmedEmail = email.trim();
      final authUserExists =
          (await _firebaseAuth.fetchSignInMethodsForEmail(
            trimmedEmail,
          )).isNotEmpty;
      final firestoreUserExists = await _checkEmailInFirestore(trimmedEmail);
      if (!authUserExists && !firestoreUserExists) {
        if (context.mounted) {
          cupertinoDialog(context, 'No user found with this email address.');
        }
        _isLoading = false;
        notifyListeners();
        return;
      }
      await _firebaseAuth.sendPasswordResetEmail(email: trimmedEmail);
      _isLoading = false;
      notifyListeners();
      if (context.mounted) {
        cupertinoDialog(
          context,
          'Password reset email sent successfully. Please check your email.',
        );
      }
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email address.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Too many requests. Please try again later.';
      }
      if (context.mounted) {
        cupertinoDialog(context, errorMessage);
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      if (context.mounted) {
        cupertinoDialog(
          context,
          'An unexpected error occurred. Please try again.',
        );
      }
    }
  }

  Future<bool> _checkEmailInFirestore(String email) async {
    try {
      final query =
          await _firestore
              .collection('users')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      return query.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  void updateCurrentLocationField(String field, dynamic value) {
    if (_currentUser != null) {
      if (field.startsWith('location.')) {
        final locationField = field.split('.').last;
        _currentUser = _currentUser.copyWith(
          location: _currentUser.location?.copyWith(
            neighborLocation:
                locationField == 'neighborLocation'
                    ? value as String
                    : _currentUser.location!.neighborLocation,
            streetNumber:
                locationField == 'streetNumber'
                    ? value as String
                    : _currentUser.location!.streetNumber,
            houseAddress:
                locationField == 'houseAddress'
                    ? value as String
                    : _currentUser.location!.houseAddress,
            city:
                locationField == 'city'
                    ? value as String
                    : _currentUser.location!.city,
            state:
                locationField == 'state'
                    ? value as String
                    : _currentUser.location!.state,
            zipCode:
                locationField == 'zipCode'
                    ? value as String
                    : _currentUser.location!.zipCode,
            country:
                locationField == 'country'
                    ? value as String
                    : _currentUser.location!.country,
          ),
        );
        notifyListeners();
      } else {
        throw ArgumentError('Field "$field" is not a valid location field.');
      }
    } else {
      throw StateError('No current user is set');
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    currentPosition = position;
  }

  Future<void> fetchCurrentLocationWithAddress() async {
    try {
      await getCurrentLocation();
      if (currentPosition != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition!.latitude,
          currentPosition!.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks[0];
          _currentAddress =
              "${placemark.street}, ${placemark.locality}, ${placemark.country}";
          print("Current location selected: $_currentAddress");
        } else {
          _currentAddress = "Address not found";
          print("Failed to fetch address: No placemarks found");
        }
      } else {
        _currentAddress = "Failed to fetch location";
        print("Failed to fetch location: Position is null");
      }
    } catch (e) {
      _currentAddress = "Error fetching location: $e";
      print("Error fetching location: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      // if (_currentUser?.accountType == 'Google Sign-In') {
      //   final googleSignIn = GoogleSignIn();
      //   // await googleSignIn.disconnect();
      //   await googleSignIn.signOut();
      // } else if (_currentUser?.accountType == 'Email') {
      //   await FirebaseAuth.instance.signOut();
      // }
      await clearUser();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  Future<void> googleSignIn({required BuildContext context}) async {
    try {
      _isLoading = true;
      notifyListeners();
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        cupertinoDialog(context, 'Google Sign-In Cancelled');
        return;
      }
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;
      if (user == null) {
        cupertinoDialog(context, 'Google Sign-In Failed');
        return;
      }
      final userModel = UserModel(
        uid: user.uid,
        name: user.displayName ?? 'No Name',
        phoneNo: '',
        email: user.email ?? 'No Email',
        password: '',
        location: location,
        isActive: true,
        profileImage: '',
        gender: '',
        createdAt: DateTime.now(),
      );
      bool isUserSignedUp = await fetchUserData(userModel.uid, context);
      if (!isUserSignedUp) {
        await addUserToFirestore(userModel, context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Sign-Up Successful')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Sign-In Successful')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } catch (e) {
      cupertinoDialog(context, 'Error: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
