import 'package:flutter/material.dart';
import 'package:incident_tracker/utils/theme.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  const LoadingShimmer(
      {super.key,
      this.height = 40,
      this.width = double.infinity,
      this.borderRadius = 5});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.white,
          border: Border.all(
            color: primaryGrey4,
          ),
        ),
      ),
    );
  }
}
