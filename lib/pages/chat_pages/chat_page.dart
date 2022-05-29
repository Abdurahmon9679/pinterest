import 'package:flutter/material.dart';
import 'package:pinterest/models/collection_model.dart';
import 'package:pinterest/pages/chat_pages/message_page.dart';
import 'package:pinterest/pages/chat_pages/update_page.dart';
import 'package:pinterest/services/dio_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  static const String id = "chat_page";

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int selectedIndex = 0;
  List<Collections> collections = [];
  final PageController _pageController = PageController();

  void _apiLoadList() {
    NetworkDio.GET(NetworkDio.API_COLLECTIONS, NetworkDio.paramsEmpty())
        .then((response) => {_showResponse(response!)});
  }

  void _showResponse(String response) {
    setState(() {
      collections = NetworkDio.parseCollectionResponse(response);
    });
  }

  @override
  void initState() {
    _apiLoadList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DefaultTabController(
              length: 2,
              child: TabBar(
                onTap: (index) {
                  setState(
                    () {
                      selectedIndex = index;
                    },
                  );
                  _pageController.animateToPage(selectedIndex,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.linear);
                },
                labelPadding: EdgeInsets.zero,
                indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(color: Colors.transparent)),
                padding: EdgeInsets.only(
                  top: 30,
                  left: MediaQuery.of(context).size.width * 0.23,
                  right: MediaQuery.of(context).size.width * 0.23,
                ),
                tabs: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: selectedIndex == 0
                            ? Colors.black
                            : Colors.transparent),
                    alignment: Alignment.center,
                    height: 50,
                    width: 80,
                    child: Text(
                      "Updates",
                      style: TextStyle(
                        color: selectedIndex != 0 ? Colors.black : Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: selectedIndex == 1
                            ? Colors.black
                            : Colors.transparent),
                    height: 50,
                    width: 80,
                    alignment: Alignment.center,
                    child: Text(
                      "Message",
                      style: TextStyle(
                        color: selectedIndex != 0 ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                children: [
                  ///UpdatePage
                  RefreshIndicator(
                    onRefresh: () async {
                      collections.shuffle();
                    },
                    color: Colors.red,
                    child: ListView.builder(
                      itemBuilder: (context,index){
                        return UpdatePage(collections : collections[index]);
                      },
                      itemCount: collections.length,
                      padding: const EdgeInsets.only(top: 10),
                    ),
                  ),
                  const MessagePage(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
