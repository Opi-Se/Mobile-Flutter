import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opi_se/core/functions/validate_language.dart';
import '../../../../../../core/utils/styling/styles.dart';
import '../../../../../../core/widgets/text_fields/auth_text_field.dart';

class LanguageWidget extends StatelessWidget {
  const LanguageWidget({
    super.key,
    required this.languageType,
    required this.languageController,
    required this.levelController,
  });

  final String languageType;
  final TextEditingController languageController;
  final TextEditingController levelController;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 190.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$languageType Language',
                style: AppStyles.textStyle16.copyWith(
                  fontSize: 14.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              AuthTextField(
                controller: languageController,
                hintText: 'Your Language',
                obscureText: false,
                prefixIcon: Icon(
                  Icons.language_outlined,
                  size: 21.sp,
                  color: const Color(0xff036666),
                ),
                validator: (value) {
                  if (languageType == 'Native') {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Required';
                    } else if (value!.length < 3 || value.contains(RegExp(r"[0-9]")) || !validateLanguage(value)) {
                      return 'Not a valid language';
                    }
                  } else {
                    if (value != null && value.trim().isNotEmpty && (value.length < 3 || value.contains(RegExp(r'[0-9]')) || !validateLanguage(value))) {
                      return 'Not a valid language';
                    }
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Level',
              style: AppStyles.textStyle16.copyWith(
                fontSize: 14.sp,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            SizedBox(
              height: 75.h,
              child: DropdownMenu(
                controller: levelController,
                textStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 14.sp,
                ),
                width: 120.w,
                hintText: 'Select',
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.sp),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.sp),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.w,
                    ),
                  ),
                ),
                menuStyle: MenuStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 8.h),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  elevation: MaterialStateProperty.all(4.sp),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.sp),
                    ),
                  ),
                ),
                menuHeight: 200.h,
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: '1', label: '1'),
                  DropdownMenuEntry(value: '2', label: '2'),
                  DropdownMenuEntry(value: '3', label: '3'),
                ],
                onSelected: (value) {
                  levelController.text = value.toString();
                },
                initialSelection: languageType == 'Native' ? '3' : '1',
              ),
            ),
          ],
        )
      ],
    );
  }
}
