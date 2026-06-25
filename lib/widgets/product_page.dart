import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'filter_header_delegate.dart'; // 💡 분리한 헤더 제어 로직 import
import 'product_tile.dart';           // 💡 분리한 상품 타일 위젯 import

class ProductPage extends StatefulWidget {
  const ProductPage({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

String _selectedSortOrder = '관심 등록순';

class _ProductPageState extends State<ProductPage> {
  bool _isBelowRetailPrice = false;
  bool _excludeOutOfStock = false;

  final List<String> _sortOptions = ['관심 등록순', '즉시 구매순'];

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  void _showSortBottomSheet(BuildContext context, double textSize) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(_sortOptions.length, (index) {
                final option = _sortOptions[index];
                final isSelected = _selectedSortOrder == option;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        option,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.black : Colors.black87,
                        ),
                      ),
                      trailing: isSelected 
                          ? const Icon(Icons.check, color: Colors.black, size: 20) 
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedSortOrder = option;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    if (index < _sortOptions.length - 1)
                      const Divider(
                        height: 1, 
                        thickness: 1, 
                        color: Color(0xFFF4F6F8),
                        indent: 16,
                        endIndent: 16,
                      ),
                  ],
                );
              }),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double topSpacing = 8.0;
    const double chipHeight = 30.0;
    const double horizontalPadding = 12.0;
    const double borderRadius = 15.0;
    const double fontSize = 12.0;
    const double itemSpacing = 6.0;

    const double checkboxTopSpacing = 10.0;
    const double checkboxIconSize = 16.0;
    const double checkboxTextSize = 12.0;
    const double checkboxSpacing = 12.0;

    const double headerTopHeight = chipHeight + topSpacing + 4; 
    const double headerBottomHeight = checkboxTopSpacing + 24 + 12; 

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: _handleRefresh,
          refreshTriggerPullDistance: 100.0,
          refreshIndicatorExtent: 60.0,
        ),

        // 📌 슬리버 1: 필터 칩 + 플로팅 체크박스 통합 헤더
        SliverPersistentHeader(
          pinned: true, 
          floating: true, 
          delegate: AdvancedFilterHeaderDelegate( // 💡 분리한 클래스 연결
            minHeight: headerTopHeight, 
            maxHeight: headerTopHeight + headerBottomHeight, 
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // 1) 필터 칩 영역
                  Padding(
                    padding: const EdgeInsets.only(top: topSpacing, bottom: 4),
                    child: SizedBox(
                      height: chipHeight,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: widget.filters.length,
                        separatorBuilder: (context, index) => const SizedBox(width: itemSpacing),
                        itemBuilder: (context, filterIndex) {
                          final label = widget.filters[filterIndex];
                          final isSelected = filterIndex == widget.selectedIndex;

                          return GestureDetector(
                            onTap: () => widget.onSelected(filterIndex),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.black : const Color(0xFFF4F6F8),
                                borderRadius: BorderRadius.circular(borderRadius),
                              ),
                              child: Text(
                                label,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  // 2) 체크박스 및 정렬 영역
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, checkboxTopSpacing, 16, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start, 
                      children: [
                        _buildCircleCheckbox(
                          label: '정가 이하',
                          value: _isBelowRetailPrice,
                          iconSize: checkboxIconSize,
                          textSize: checkboxTextSize,
                          onChanged: (val) {
                            setState(() {
                              _isBelowRetailPrice = val;
                            });
                          },
                        ),
                        const SizedBox(width: checkboxSpacing),
                        _buildCircleCheckbox(
                          label: '품절 제외',
                          value: _excludeOutOfStock,
                          iconSize: checkboxIconSize,
                          textSize: checkboxTextSize,
                          onChanged: (val) {
                            setState(() {
                              _excludeOutOfStock = val;
                            });
                          },
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => _showSortBottomSheet(context, checkboxTextSize),
                          behavior: HitTestBehavior.opaque,
                          child: Row(
                            children: [
                              Text(
                                _selectedSortOrder, 
                                style: TextStyle(
                                  fontSize: checkboxTextSize, 
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down, size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 📌 슬리버 2: 실제 상품 타일 리스트 40개
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProductTile(index: index), // 💡 분리한 위젯 호출
                  if (index < 39)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(height: 1, thickness: 1, color: Color(0xFFF4F6F8)),
                    ),
                ],
              );
            },
            childCount: 40,
          ),
        ),
        
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _buildCircleCheckbox({
    required String label,
    required bool value,
    required double iconSize,
    required double textSize,
    required void Function(bool) onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: value ? Colors.black : const Color(0xFFD1D1D6),
                width: 1.5,
              ),
              color: value ? Colors.black : Colors.transparent,
            ),
            child: value
                ? Icon(
                    Icons.check,
                    size: iconSize * 0.7,
                    color: Colors.white,
                  )
                : null,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: textSize,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}