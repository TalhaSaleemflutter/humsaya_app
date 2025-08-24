import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';

class PhoneTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final double? height;
  final Function(String)? onChanged; // Add this callback

  PhoneTextField({
    super.key,
    required this.controller,
    this.hintText = " (xxx) xxx - xxx", // Adjusted hint text
    this.onTap,
    this.validator,
    this.fillColor,
    this.height = 65,
    this.onChanged, // Initialize the callback
  });

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _getUserCountry(); // Automatically detect the user's country
  }

  // Function to get the user's country based on their location
  Future<void> _getUserCountry() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Handle case where location services are disabled
        return;
      }

      // Check for location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Handle case where permissions are denied
          return;
        }
      }

      // Get the user's current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Convert the position into a list of placemarks
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        // Extract the country code from the first placemark
        String countryCode =
            placemarks.first.isoCountryCode ??
            'ES'; // Default to Spain if no country code is found

        // Find the corresponding country using the country_picker package
        Country? country = Country.tryParse(countryCode);

        if (country != null) {
          setState(() {
            _selectedCountry = country; // Update the selected country
          });
        }
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print("Error detecting country: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(),
      child: TextFormField(
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        onTap: widget.onTap,
        controller: widget.controller,
        keyboardType: TextInputType.number,
        textAlignVertical: TextAlignVertical.center,
        onChanged: (value) {
          // Combine the country code and the user's input
          if (_selectedCountry != null && value.isNotEmpty) {
            String formattedNumber = "+${_selectedCountry!.phoneCode}$value";
            if (widget.onChanged != null) {
              widget.onChanged!(formattedNumber); // Return the formatted number
            }
          }
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.fillColor,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 18.h,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ThemeHelper.getFieldBorderColor(context),
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(10.r),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10.r),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(10.r),
          ),
          hintText: widget.hintText,
          hintStyle: AppTextStyles.fieldText(context),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 10.w, right: 5.w), // Adjust padding
            child: GestureDetector(
              onTap: () {
                // Show country picker dialog
                showCountryPicker(
                  context: context,
                  onSelect: (Country country) {
                    setState(() {
                      _selectedCountry = country; // Update selected country
                    });
                  },
                );
              },
              child: Row(
                mainAxisSize:
                    MainAxisSize.min, // Ensure the row takes minimal space
                children: [
                  SizedBox(width: 5.w),
                  // Display selected country flag or default flag
                  Text(
                    _selectedCountry != null
                        ? _selectedCountry!.flagEmoji
                        : "🇪🇸", // Default to Spain flag
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  SizedBox(width: 5.w),
                  // Display country code
                  Text(
                    _selectedCountry != null
                        ? "+${_selectedCountry!.phoneCode}"
                        : "+34",
                    style: AppTextStyles.fieldText(context),
                  ),
                ],
              ),
            ),
          ),
        ),
        validator: widget.validator,
      ),
    );
  }
}
