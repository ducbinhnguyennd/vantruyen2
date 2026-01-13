import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/trangchu_model.dart';
import 'package:loginapp/widgets/item_search.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Manga> _items = [];
  List<Manga> _foundUsers = [];
  String? currentImage = '';
  MangaService mangaService = MangaService();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<Manga> listT = await MangaService.fetchMangaList();

      setState(() {
        _items = listT;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  String removeAccents(String input) {
    var str = input.toLowerCase();
    str = str.replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a');
    str = str.replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e');
    str = str.replaceAll(RegExp(r'[ìíịỉĩ]'), 'i');
    str = str.replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o');
    str = str.replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u');
    str = str.replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y');
    str = str.replaceAll(RegExp(r'[đ]'), 'd');
    return str;
  }

  void _runFilter(String query) {
    List<Manga> results = [];
    if (query.isEmpty) {
      //results = _items.cast<ItemModel>();
    } else {
      results = _items.where((book) {
        String nameLower = removeAccents(book.mangaName!);
        // String authorLower = removeAccents(book.);
        String category = removeAccents(book.category!);
        String queryLower = removeAccents(query.toLowerCase());

        return nameLower.contains(queryLower) ||
            // authorLower.contains(queryLower) ||
            category.contains(queryLower);
      }).toList();
    }

    setState(() {
      _foundUsers = results.cast<Manga>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Tìm kiếm kho truyện'),
        centerTitle: true,
        backgroundColor: ColorConst.colorPrimary50,
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) => _runFilter(value),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
              hintText: "Tìm theo tên hoặc tác giả...",
              suffixIcon: const Icon(Icons.search),
              // prefix: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(),
              ),
            ),
          ),
        ),
        Expanded(
            child: _foundUsers.isNotEmpty
                ? ListView.builder(
                    itemCount: _foundUsers.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: Card(
                          elevation: 1,
                          child: ItemSearch(
                            imagePath: _foundUsers[index].image!,
                            title: _foundUsers[index].mangaName!,
                            id: _foundUsers[index].id!,
                            theloai: _foundUsers[index].category!,
                            author: _foundUsers[index].author!,
                          ),
                        ),
                      );
                    },
                  )
                //: _searchController.text.isNotEmpty
                : const Text(
                    'Không thấy kết quả',
                    style: TextStyle(fontSize: 20),
                  )
            //: const Placeholder()

            ),
      ]),
    );
  }
}
