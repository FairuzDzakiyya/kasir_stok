import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kas_mini_flutter_app/utils/colors.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:sizer/sizer.dart';

class MainCard extends StatelessWidget {
  final String? title;
  final Color? color;
  final String? imagePath;
  final VoidCallback? onTap;

  const MainCard(
      {super.key, this.title, this.imagePath, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22.w, // Menyesuaikan agar bisa 4 kolom dalam satu baris
      child: Column(
        children: [
          Card(
            color: cardColor,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
            child: ZoomTapAnimation(
              onTap: onTap,
              child: Container(
                width: 18.w,
                height: 18.w,
                padding: EdgeInsets.all(2.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      imagePath!,
                      width: 10.w,
                      height: 10.w,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Gap(2),
          Tooltip(
            message: title,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Text(
                title!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
