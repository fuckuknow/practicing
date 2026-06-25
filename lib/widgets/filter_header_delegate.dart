import 'package:flutter/material.dart';

class AdvancedFilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  AdvancedFilterHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight; // 접혔을 때 최소 높이 (필터 칩 크기)

  @override
  double get maxExtent => maxHeight; // 펼쳐졌을 때 최대 높이 (필터 칩 + 체크박스)

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overridesOverlap) {
    return ClipRect(
      child: SizedBox(
        height: maxHeight,
        child: OverflowBox(
          minHeight: minHeight,
          maxHeight: maxHeight,
          alignment: Alignment.topCenter,
          child: child,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant AdvancedFilterHeaderDelegate oldDelegate) {
    return oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.child != child;
  }
}