import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest/models/post_model.dart';
import 'package:pinterest/services/grid_View_service.dart';
import 'package:pinterest/services/http_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  static const String id = "/search";

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Post> posts = [];
  int pageNumber = 0;
  bool isLoading = false;
  bool isTyping = false;
  String search = "";

  void searchPost() async {
    if (search.isEmpty) {
      search = "All";
      _controller.text=" ";
    }
    pageNumber += 1;
    String? response = await Network.GET(
        Network.API_SEARCH, Network.paramsSearch(search, pageNumber));
    List<Post> newPosts = Network.parseSearchParse(response!);
    setState(() {
      if (pageNumber == 1) {
        posts = newPosts;
      } else {
        posts.addAll(newPosts);
      }
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });
        searchPost();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          margin:
              const EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 10),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  onTap: () {
                    setState(() {
                      isTyping = true;
                    });
                  },
                  onSubmitted: (String str) {
                    setState(() {
                      isLoading = true;
                      if (search != _controller.text.trim()) pageNumber = 0;
                      search = _controller.text.trim();
                    });
                    searchPost();
                  },
                  style: const TextStyle(fontSize: 18),
                  controller: _controller,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.only(left: 10),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    hintText: "Search for ideas",
                    hintStyle:
                        TextStyle(color: Colors.grey.shade700, fontSize: 18),
                    prefixIcon: const Icon(
                      CupertinoIcons.search,
                      size: 30,
                      color: Colors.black,
                    ),
                    suffixIcon: const Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                ),
              ),
              isTyping
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          isTyping = false;
                          posts.clear();
                          _controller.clear();
                          pageNumber = 0;
                        });
                      },
                      child: const Text(
                        " Cancel",
                        style: TextStyle(fontSize: 17),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          isLoading
              ? const LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(Colors.red),
                )
              : const SizedBox.shrink(),
          Expanded(
            child: MasonryGridView.count(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return GridWidget(
                  post: posts[index],
                  search: search,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
