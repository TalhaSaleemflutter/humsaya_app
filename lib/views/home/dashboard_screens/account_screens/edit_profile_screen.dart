import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/providers/auth_provider.dart' show AuthProvider;
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_ad_textfield.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_button.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_dropdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  String? selectedGender;
  String? _imagePath;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<File?> _compressImage(String imagePath) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(
        dir.path,
        '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      final result = await FlutterImageCompress.compressAndGetFile(
        imagePath,
        targetPath,
        quality: 70, 
        minWidth: 1024, 
        minHeight: 1024, 
      );
      return result != null ? File(result.path) : null;
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final compressedFile = await _compressImage(pickedFile.path);
      if (compressedFile != null && mounted) {
        setState(() {
          _imagePath = compressedFile.path;
        });
      }
    } else {
      print('No image selected.');
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final compressedFile = await _compressImage(pickedFile.path);
      if (compressedFile != null && mounted) {
        setState(() {
          _imagePath = compressedFile.path;
        });
      }
    } else {
      print('No photo taken');
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _takePhoto();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> _uploadImage() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (_imagePath == null) return null;
    try {
      
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${authProvider.currentUser.uid}.jpg');
      await ref.putFile(File(_imagePath!));
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _saveProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    String finalName =
        nameController.text.isNotEmpty
            ? nameController.text
            : authProvider.currentUser.name;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      String? imageUrl;
      if (_imagePath != null) {
        imageUrl = await _uploadImage();
      }
      await authProvider.updateProfileFields(
        userId: authProvider.currentUser.uid,
        newName: finalName,
        newGender: selectedGender,
        newProfileImage: imageUrl,
      );

      Navigator.pop(context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarHeight: 45.h,
        title: 'Edit Profile',
        textStyle: AppTextStyles.appBarHeadingText(context),
        leadingIcon: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppAssets.icBack,
              height: 20.h,
              width: 20.w,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
          ),
        ),
        trailingIcon: SizedBox(),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16.h, right: 16.h),
        child: Consumer<AuthProvider>(
          builder: (BuildContext context, authProvider, Widget? child) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 40.h),
                  GestureDetector(
                    onTap: () => _showPicker(context),
                    child: CircleAvatar(
                      radius: 45.r,
                      backgroundImage:
                          _imagePath != null
                              ? FileImage(File(_imagePath!))
                              : (authProvider.currentUser.profileImage != null
                                  ? NetworkImage(
                                    authProvider.currentUser.profileImage!,
                                  )
                                  : AssetImage(AppAssets.girl2)
                                      as ImageProvider),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: Text(
                      'Edit Image',
                      style: AppTextStyles.bodyText2(
                        context,
                      ).copyWith(color: blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  CustomAdTextField(
                    controller:
                        nameController
                          ..text =
                              authProvider
                                  .currentUser
                                  .name, // Set initial value
                    onPrefixIconTap: () {},
                    hintTextColor: Theme.of(context).textTheme.bodyLarge?.color,
                  ),

                  CustomDropdownWidget(
                    hintText: authProvider.currentUser.gender.toString(),
                    height: 60.h,
                    initialValue: selectedGender,
                    itemLabel: (item) => item,
                    onChanged: (value) {
                      // authProvider.updateCurrentUserFields(
                      //   'gender',
                      //   selectedGender = value,
                      // );
                    },
                    items: const ['Male', 'Female'],
                  ),
                  SizedBox(height: 380.h),
                  CustomButton(
                    txtColor: white,
                    bgColor: primary,
                    text: 'Save',
                    onTap: () async {
                      _saveProfile();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
