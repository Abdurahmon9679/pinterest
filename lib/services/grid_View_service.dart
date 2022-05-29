import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinterest/models/post_model.dart';
import 'package:pinterest/pages/detail_page.dart';

import 'utilits.dart';

class GridWidget extends StatelessWidget {
  Post post;
  String? search;

  GridWidget({Key? key, required this.post, this.search}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(post: post, search: search)));
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: post.urls.regular,
              placeholder: (context, url) => AspectRatio(
                  aspectRatio: post.width! / post.height!,
                  child: Container(
                    color: Utils.getColorFromHex(post.color!),
                  )),
              errorWidget: (context, url, error) => AspectRatio(
                  aspectRatio: post.width! / post.height!,
                   child: Container(
                    color: Utils.getColorFromHex(post.color!),
                  )),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            horizontalTitleGap: 0,
            minVerticalPadding: 0,
            leading: SizedBox(
              height: 30,
              width: 30,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: post.user!.profileImage!.large!,
                  placeholder: (context, url) =>
                      Image.asset("assets/images/img.png"),
                  errorWidget: (context, url, error) =>
                      Image.asset("assets/images/img_1.png"),
                ),
              ),
            ),
            title: Text(post.user!.name!),
            trailing: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                // more(context);
              },
              child: const Icon(
                Icons.more_horiz,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
