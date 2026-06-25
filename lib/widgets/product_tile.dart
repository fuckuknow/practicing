import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    const double imageHeight = 90.0;

    return GestureDetector(
      onTap: () {
        // 상품 타일 클릭 시 이벤트 처리
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 상품 이미지
            Container(
              width: imageHeight,
              height: imageHeight,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6F8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image, color: Colors.grey, size: 30),
            ),
            const SizedBox(width: 16),
            
            // 2. 상품 정보
            Expanded(
              child: SizedBox(
                height: imageHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '상품 아이템 #${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${(index + 1) * 10000}원',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // 3. 우측 하트 아이콘
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.favorite_border, size: 22, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}