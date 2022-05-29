import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:pinterest/models/post_model.dart';
import 'package:pinterest/models/user_model.dart';


class HiveDB{
  static String DB_NAME = "pinterest";
  static Box box = Hive.box(DB_NAME);

  ///store user
  static Future<void>storeUser(UserProfile userProfile)async{
    ///object =>map=>String
    String user = jsonEncode(userProfile.toJson);
    await box.put("notes", user);
  }

  ///load_user
  static UserProfile loadUser(){
    ///String =>map=>Object
    String? user = box.get("notes");
    if(user!=null){
      UserProfile userProfile = UserProfile.fromJson(jsonDecode(user));
      return userProfile;
    }
    return UserProfile(
        firtsName: "Xavi", lastName: "Martines", userName: "@martines", email: "martinesxavi@gamil.com",
        gender: "male", age: 25, country: "United Kingdom");
  }

  ///store_saved_posts
  static Future<void> storeSavedImage(List<Post> posts) async {
    List<String> list =
    List<String>.from(posts.map((post) => jsonEncode(post.toJson())));
    await box.put("saved", list);
  }


  ///load_saved_posts
  static List<Post> loadSavedImage(){
    List<String>response = box.get("saved",defaultValue: <String>[]);
    List<Post>list= List<Post>.from(response.map((x) => Post.fromJson(jsonDecode(x))));
    return list;
  }
}