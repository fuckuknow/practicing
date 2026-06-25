import 'package:flutter/material.dart';
import '../utils/text_utils.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: isSelected ? Colors.black : Colors.black54,
      fontSize: 15,
      fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
    );
    final underlineWidth = measureTextWidth(label, textStyle);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: textStyle),
          const SizedBox(height: 8),
          Container(
            height: 3,
            width: underlineWidth,
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
