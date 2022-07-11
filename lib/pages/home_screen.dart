import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest/models/post_model.dart';
import 'package:pinterest/pages/profile_page.dart';
import 'package:pinterest/pages/search_page.dart';
import 'package:pinterest/services/grid_View_service.dart';
import 'package:pinterest/services/http_service.dart';
import 'chat_pages/chat_page.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String id = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final PageController _pageController = PageController();
  bool isLoading = true;
  bool isLoadPage = false;
  List<Post> posts = [];
  int postsLength = 0;
  final ScrollController _scrollController = ScrollController();

  void _apiLoadList() async {
    await Network.GET(Network.API_DELETE, Network.paramsEmpty())
        .then((response) => {showResponse(response!)});
  }

  void showResponse(String response) {
    setState(() {
      isLoading = false;
      posts = Network.parseResponse(response);
      posts.shuffle();
      postsLength = posts.length;
    });
  }

  void fetchPosts() async {
    int pageNumber = (posts.length ~/ postsLength + 1);
    String? response =
    await Network.GET(Network.API_LIST, Network.paramsPage(pageNumber));
    List<Post> newPosts = Network.parseResponse(response!);
    posts.addAll(newPosts);
    setState(() {
      isLoadPage = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _apiLoadList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          isLoadPage = true;
        });
        fetchPosts();
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 40, bottom: 10),
                height: 90,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.18,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "All",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              isLoadPage ? const LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                minHeight: 5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ):const SizedBox.shrink(),
              Expanded(
                child: RefreshIndicator(
                  color: Colors.red,
                  onRefresh: ()async{
                    _apiLoadList();
                  },
                child: MasonryGridView.count(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  crossAxisCount: 2,
                  itemCount: posts.length,
                  shrinkWrap: true,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  itemBuilder: (context, index) {
                    return GridWidget(post: posts[index]);
                  },
                ),
                ),
              ),
            ],
          ),
          const SearchPage(key: PageStorageKey("Search Page"),),
          const ChatPage(key: PageStorageKey("ChatPage"),),
          const ProfilePage(key: PageStorageKey("Profile page"),),
        ],
      ),
      bottomNavigationBar: Container(
        height: 55,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.04,
            left: MediaQuery.of(context).size.width * 0.2,
            right: MediaQuery.of(context).size.width * 0.2),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
              FirebaseCrashlytics.instance.crash();
            });
            _pageController.jumpToPage(selectedIndex);
          },
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled,),
                activeIcon: Icon(Icons.home_filled,
                    color: Colors.black),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.search),
                activeIcon: Icon(CupertinoIcons.search,
                  color: Colors.black,

                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chat_bubble_text_fill),
                activeIcon: Icon(CupertinoIcons.chat_bubble_text_fill,
                  color: Colors.black,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.profile_circled),
                activeIcon: Icon(CupertinoIcons.profile_circled,
                  color: Colors.black,
                ),
                label: ""),
          ],
        ),
      ),
    );
  }

//
//
//
// Widget tile(index, {int? extent}){
//   return Column(
//     children: [
//       Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(25),
//           image: DecorationImage(
//             image: NetworkImage(post!.urls.regular,
//           ),
//         ),
//         ),
//         child: Image(
//           image: NetworkImage(post!.urls.regular,)
//         ),
//       ),
//       const SizedBox(height: 5,),
//       Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: const [
//           Text("ASA"),
//           Icon(Icons.more_horiz),
//         ],
//       ),
//     ],
//   );
// }
}
