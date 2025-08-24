import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';

class CustomDropdownWidget<T> extends StatefulWidget {
  final double height;
  final Color? color;
  final List<T> items;
  final T? initialValue;
  final String Function(T) itemLabel;
  final ValueChanged<T> onChanged;
  final String hintText;
  final Color? hintTextColor;
  final String? Function(T?)? validator; // 👈 FIXED here

  const CustomDropdownWidget({
    super.key,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.initialValue,
    required this.height,
    required this.hintText,
    this.hintTextColor,
    this.color,
    this.validator,
  });

  @override
  CustomDropdownWidgetState<T> createState() => CustomDropdownWidgetState<T>();
}

class CustomDropdownWidgetState<T> extends State<CustomDropdownWidget<T>> {
  T? selectedItem;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.initialValue;
  }

  @override
Widget build(BuildContext context) {
  return FormField<T>(
    validator: widget.validator,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    builder: (FormFieldState<T> field) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompositedTransformTarget(
            link: _layerLink,
            child: GestureDetector(
              onTap: _toggleDropdown,
              child: Container(
                height: widget.height,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: widget.color ?? ThemeHelper.getCardColor(context),
                  border: Border.all(
                    color: field.hasError
                        ? Colors.red
                        : ThemeHelper.getFieldBorderColor(context),
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        selectedItem != null
                            ? widget.itemLabel(selectedItem as T)
                            : widget.hintText,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: selectedItem != null
                              ? ThemeHelper.getTabbarTextColor(context, false)
                              : widget.hintTextColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: ThemeHelper.getTabbarTextColor(context, false),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (field.hasError)
            Padding(
              padding: EdgeInsets.only(left: 8.w, top: 4.h),
              child: Text(
                field.errorText ?? '',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 10.sp,
                ),
              ),
            ),
        ],
      );
    },
  );
}


  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _isDropdownOpen = true;
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isDropdownOpen = false;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: _closeDropdown,
              behavior: HitTestBehavior.translucent,
              child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            Positioned(
              width: size.width,
              left: offset.dx,
              top: offset.dy + size.height,
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 10,
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children:
                      widget.items.map((item) {
                        return ListTile(
                          title: Text(
                            widget.itemLabel(item),
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          onTap: () {
                            setState(() {
                              selectedItem = item;
                            });
                            widget.onChanged(item);
                            _closeDropdown();
                          },
                        );
                      }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
