import 'package:flutter/material.dart';
import '../widgets/cart_button.dart';
import '../widgets/menu_button.dart';
import '../widgets/product_page.dart';
import '../widgets/blank_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  static const List<String> _menus = [
    '상품',
    '발매정보',
    '스타일',
    '브랜드',
    '최근 본 상품',
  ];


  late final TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _menus.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging &&
          _selectedIndex != _tabController.index) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _selectMenu(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _tabController.animateTo(index);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Saved',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CartButton(),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE6E6E6),
                    width: 1,
                  ),
                ),
              ),
              child: SizedBox(
                height: 34,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _menus.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 24),
                  itemBuilder: (context, index) {
                    return MenuButton(
                      label: _menus[index],
                      isSelected: _selectedIndex == index,
                      onTap: () => _selectMenu(index),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // 💡 여기에 필요한 값들을 넣어주어야 합니다.
                  ProductPage(
                    filters: const ['전체', '신발', '아우터', '상의', '하의', '가방', '시계', '패션잡화', '컬렉터블', '가구/리빙'],
                    selectedIndex: 0, // 초기 선택값
                    onSelected: (int index) {
                      // 필터가 눌렸을 때 수행할 동작 (필요 시 로직 추가)
                    },
                  ),
                  const BlankPage(),
                  const BlankPage(),
                  const BlankPage(),
                  const BlankPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
