import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/screens/category_screen.dart';
import 'package:loginapp/screens/search_screen.dart';
import 'package:loginapp/widgets/item_trangchu.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class ItemCarousel {
  final String id;
  final String image;

  ItemCarousel({
    required this.id,
    required this.image,
  });
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool _isLoading = true;

  final List<ItemCarousel> itemList = [
    ItemCarousel(
        id: '',
        image:
            'https://cdn.popsww.com/blog/sites/2/2021/03/nhung-bo-truyen-tranh-trung-quoc-hay-nhat-2021_Website.jpg'),
    ItemCarousel(
        id: '',
        image:
            'https://cdn.popsww.com/blog/sites/2/2022/03/truyen-tranh-ve-dep_Website.jpg'),
  ];

  Widget Search() {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.0, 70.0, 8.0, 0),
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ColorConst.colorPrimary),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Tìm kiếm truyện'),
                      Spacer(),
                      Icon(
                        Icons.search,
                        color: ColorConst.colorPrimary50,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CategoriesScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.density_medium_rounded)),
          )
        ],
      ),
    );
  }

  final PageController _pageController = PageController();
  int _currentPage = 0;
@override
void initState() {
  super.initState();
  _loadData();
}

Future<void> _loadData() async {
  setState(() => _isLoading = true);

  await Future.delayed(Duration(seconds: 2));

  setState(() => _isLoading = false);
}
  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('abc');
    return RefreshIndicator(
      color: ColorConst.colorPrimary120,
      onRefresh: _loadData,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFD1D3), Colors.white],
              stops: [0.0, 0.4],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.all(0),
            children: [
              Search(),
              SizedBox(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: itemList.length,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: CachedNetworkImage(
                            // Thay đổi từ Image.network thành CachedNetworkImage
                            imageUrl: itemList[index].image,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: ColorConst.colorPrimary80),
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: ColorConst.colorPrimary50,
                              )),
                            ), // Placeholder khi đang load
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error), // Widget hiển thị khi có lỗi
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(itemList.length, (index) {
                  return Container(
                    width: 10,
                    height: 10,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: ColorConst.colorPrimary80, width: 0.5),
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? ColorConst.colorPrimary30
                          : Colors.transparent,
                    ),
                  );
                }),
              ),
              ItemTrangChu()
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
