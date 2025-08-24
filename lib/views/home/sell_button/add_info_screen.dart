import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/models/category_model.dart';
import 'package:humsaya_app/providers/ad_provider.dart';
import 'package:humsaya_app/providers/auth_provider.dart';
import 'package:humsaya_app/providers/category_provider.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/views/home/dash_board_navigation_page.dart';
import 'package:humsaya_app/widgets/custom_dialogs/text_box.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_ad_textfield.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_button.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_dropdown.dart';
import 'package:humsaya_app/widgets/custom_widgets/full_image_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddInfoScreen extends StatefulWidget {
  const AddInfoScreen({super.key});
  @override
  State<AddInfoScreen> createState() => _AddInfoScreenState();
}

class _AddInfoScreenState extends State<AddInfoScreen> {
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final discountPriceController = TextEditingController();
  final locationController = TextEditingController();
  final brandController = TextEditingController();
  final urlController = TextEditingController();
  String? selectedGender;
  String? selectedType;

  List<String> _imagePaths = []; // List to store multiple image paths
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _imagePaths.addAll(pickedFiles.map((file) => file.path).toList());
        context.read<AdProvider>().updateCurrentAdField(
          'listOfImages',
          _imagePaths,
        );
      });
    } else {
      print('No images selected.');
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imagePaths.add(pickedFile.path); // Add the new image path to the list
        // Update the list of images in the provider
        context.read<AdProvider>().updateCurrentAdField(
          'listOfImages',
          _imagePaths,
        );
      });
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

  // void showDialoug(String title, Function(String) onTextEnteredCallback) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return CenteredTextBox(
  //         heading: title,
  //         onTextEntered: (String enteredText) {
  //           onTextEnteredCallback(enteredText);
  //         },
  //       );
  //     },
  //   );
  // }

          Future<void> createAd() async {
            final adProvider = Provider.of<AdProvider>(context, listen: false);
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            try {
              adProvider.updateCurrentAdField(
                'location',
                authProvider.currentUser.location!.neighborLocation,
              );
              adProvider.setLoading(true);
              await adProvider.createAd(
                authProvider.currentUser?.uid ?? '',
                adProvider.currentAds,
              );
              adProvider.clearCurrentAd(false);
              adProvider.setLoading(false);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardNavigationPage()),
              );
            } catch (e) {
              adProvider.setLoading(false);
              print('Error adding product: $e');
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Failed to add product: $e')));
            }
          }

  // void initState() {
  //   super.initState();
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   locationController.text =
  //       authProvider.currentUser.location!.neighborLocation;
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final addProvider = Provider.of<AdProvider>(context, listen: false);
  //     addProvider.updateCurrentAdField('location', locationController.text);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarHeight: 45.h,
        title: 'Ad Info',
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
        padding: EdgeInsets.only(left: 22.w, right: 22.w),
        child: Consumer3<AdProvider, AuthProvider, CategoryProvider>(
          builder: (
            BuildContext context,
            addProvider,
            authProvider,
            categoryProvider,
            Widget? child,
          ) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        buildCircleAvatar(context),
                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: Text(
                            'Add Images',
                            style: AppTextStyles.fieldText(context).copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30.w, right: 30.w),
                          child: Text(
                            textAlign: TextAlign.center,
                            '5MB maximum file size accepted in jpg, jpeg, png, gif format',
                            style: AppTextStyles.fieldText(context),
                          ),
                        ),
                        SizedBox(height: 40.h),
                        CustomAdTextField(
                          controller: titleController,
                          hintText: "Title",
                          onPrefixIconTap: () {},
                          hintTextColor:
                              Theme.of(context).textTheme.bodyLarge?.color,
                          onChanged: (value) {
                            addProvider.updateCurrentAdField(
                              'title',
                              titleController.text,
                            );
                          },
                        ),
                        CustomAdTextField(
                          readOnly: true,
                          hintText:
                              categoryProvider
                                  .getCategoryById(
                                    addProvider.currentAds.categoryId,
                                  )
                                  ?.title ??
                              'Category not found',
                          onPrefixIconTap: () {},
                          hintTextColor:
                              Theme.of(context).textTheme.bodyLarge?.color,
                          onChanged: (value) {},
                        ),
                        CustomAdTextField(
                          controller: brandController,
                          hintText: "Brand Name",
                          onPrefixIconTap: () {},
                          hintTextColor:
                              Theme.of(context).textTheme.bodyLarge?.color,
                          onChanged: (value) {
                            addProvider.updateCurrentAdField(
                              'brandName',
                              brandController.text,
                            );
                          },
                        ),
                        (categoryProvider
                                            .getCategoryById(
                                              addProvider.currentAds.categoryId,
                                            )
                                            ?.categoryId ??
                                        '') ==
                                    '3' ||
                                (categoryProvider
                                            .getCategoryById(
                                              addProvider.currentAds.categoryId,
                                            )
                                            ?.categoryId ??
                                        '') ==
                                    '2'
                            ? SizedBox()
                            : CustomDropdownWidget(
                              hintText: 'Select Condition',
                              hintTextColor: ThemeHelper.getBlackWhite(context),
                              height: 56.h,
                              initialValue: selectedGender,
                              itemLabel: (item) => item,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value;
                                });
                                addProvider.updateCurrentAdField(
                                  'condition',
                                  value,
                                );
                              },
                              items: const ['New', 'Used'],
                            ),
                        (categoryProvider
                                            .getCategoryById(
                                              addProvider.currentAds.categoryId,
                                            )
                                            ?.categoryId ??
                                        '') ==
                                    '3' ||
                                (categoryProvider
                                            .getCategoryById(
                                              addProvider.currentAds.categoryId,
                                            )
                                            ?.categoryId ??
                                        '') ==
                                    '2'
                            ? SizedBox()
                            : SizedBox(height: 7.h),
                        CustomDropdownWidget(
                          hintText: 'Select Service Type',
                          hintTextColor: ThemeHelper.getBlackWhite(context),
                          height: 56.h,
                          initialValue: selectedType,
                          itemLabel: (item) => item,
                          onChanged: (value) {
                            setState(() {
                              selectedType = value;
                            });
                            addProvider.updateCurrentAdField(
                              'servicePaymentType',
                              value,
                            );
                          },
                          items: const ['Hourly', 'Fixed'],
                        ),

                        SizedBox(height: 7.h),
                        (categoryProvider
                                        .getCategoryById(
                                          addProvider.currentAds.categoryId,
                                        )
                                        ?.categoryId ??
                                    '') ==
                                '3'
                            ? SizedBox()
                            : CustomAdTextField(
                              controller: priceController,
                              hintText: "Price",
                              onPrefixIconTap: () {},
                              hintTextColor:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                              onChanged: (value) {
                                final parsedValue = double.tryParse(
                                  priceController.text,
                                );
                                if (parsedValue != null) {
                                  addProvider.updateCurrentAdField(
                                    'price',
                                    parsedValue,
                                  );
                                }
                              },
                            ),
                        CustomAdTextField(
                          controller: descriptionController,
                          hintText: "Description",
                          onPrefixIconTap: () {},
                          hintTextColor:
                              Theme.of(context).textTheme.bodyLarge?.color,
                          onChanged: (value) {
                            addProvider.updateCurrentAdField(
                              'description',
                              descriptionController.text,
                            );
                          },
                        ),
                        // CustomAdTextField(
                        //   controller: locationController,
                        //   readOnly: true,
                        //   hintText:
                        //       authProvider
                        //           .currentUser
                        //           .location!
                        //           .neighborLocation
                        //           .toString(),
                        //   onPrefixIconTap: () {},
                        //   hintTextColor:
                        //       Theme.of(context).textTheme.bodyLarge?.color,
                        //   onChanged: (value) {
                        //     print('Location changed: $value');
                        //     addProvider.updateCurrentAdField(
                        //       'location',
                        //       locationController.text,
                        //     );
                        //   },
                        // ),
                        (categoryProvider
                                        .getCategoryById(
                                          addProvider.currentAds.categoryId,
                                        )
                                        ?.categoryId ??
                                    '') ==
                                '3'
                            ? CustomAdTextField(
                              hintText: "Enter Website Url",
                              controller: urlController,
                              hintTextColor:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                              onChanged: (value) {
                                addProvider.updateCurrentAdField(
                                  'websiteUrl',
                                  urlController.text,
                                );
                              },
                            )
                            : SizedBox(),
                        CustomAdTextField(
                          controller: discountPriceController,
                          hintText: "Discounted price",
                          onPrefixIconTap: () {},
                          hintTextColor:
                              Theme.of(context).textTheme.bodyLarge?.color,
                          onChanged: (value) {
                            final parsedValue = double.tryParse(
                              discountPriceController.text,
                            );
                            if (parsedValue != null) {
                              addProvider.updateCurrentAdField(
                                'discountPrice',
                                parsedValue,
                              );
                            }
                          },
                          // addProvider.updateCurrentAdField(
                          //   'discountPrice',
                          //   discountPriceController.text,
                          // );
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
                CustomButton(
                  txtColor: white,
                  bgColor: primary,
                  text: 'Next',
                  onTap: () {
                    createAd();
                  },
                ),
                SizedBox(height: 10.h),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildCircleAvatar(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child:
          _imagePaths.isEmpty
              ? Center(
                child: GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ThemeHelper.getCardColor(context),
                    ),
                    child: Center(
                      child:
                          _imagePaths.isEmpty
                              ? Icon(
                                Icons.image,
                                size: 40,
                                color: ThemeHelper.getBlackWhite(context),
                              )
                              : Icon(
                                Icons.add,
                                size: 40,
                                color: ThemeHelper.getBlackWhite(context),
                              ),
                    ),
                  ),
                ),
              )
              : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _imagePaths.length + 1,
                itemBuilder: (context, index) {
                  if (index < _imagePaths.length) {
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => FullImageView(
                                      imageFile: File(_imagePaths[index]),
                                    ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: CircleAvatar(
                              radius: 50.r,
                              backgroundImage: FileImage(
                                File(_imagePaths[index]),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () {
                              // Remove the image from the list
                              setState(() {
                                _imagePaths.removeAt(index);
                                context.read<AdProvider>().updateCurrentAdField(
                                  'listOfImages',
                                  _imagePaths,
                                );
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 16.w,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ThemeHelper.getCardColor(context),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 40,
                              color: ThemeHelper.getBlackWhite(context),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
    );
  }
}
