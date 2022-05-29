import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinterest/pages/account_setting_page.dart';
import 'package:pinterest/pages/profile_page.dart';
import 'package:pinterest/pages/public_profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);



  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.95,
      padding: EdgeInsets.only(left: 15,right: 10,top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Settings",
              style: TextStyle(color: Colors.black,fontSize: 17),
            ),
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              alignment: const Alignment(-0.5,0.0),
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 5,top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:   [
              const Text(
                "Personal information",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5,),
              buildListTileSettings("Public profile",icon:Icons.arrow_forward_ios, context: context,widget:  PublicProfilPage()),
              buildListTileSettings("Account settings",icon:Icons.arrow_forward_ios, context: context,widget: const AccountSettings(),),
              buildListTileSettings("Permissions",icon:Icons.arrow_forward_ios, context: context,),
              buildListTileSettings("Notifications",icon:Icons.arrow_forward_ios, context: context,),
              buildListTileSettings("Privacy & data",icon:Icons.arrow_forward_ios, context: context,),
              buildListTileSettings("Home feed tuner",icon:Icons.arrow_forward_ios, context: context,),
              const SizedBox(height: 20,),
              const Text("Actions",style: TextStyle(fontSize: 16),),
              const SizedBox(height: 5,),
              buildListTileSettings("Add account", context: context),
              buildListTileSettings("Log out", context: context),
              const SizedBox(height: 20,),
              const Text("Support",style: TextStyle(fontSize: 16),),
              const SizedBox(height: 5,),
              buildListTileSettings("Get help",icon: CupertinoIcons.arrow_up_right, context: context),
              buildListTileSettings("Terms & Privacy",icon: CupertinoIcons.arrow_up_right, context: context),
              buildListTileSettings("About",icon: Icons.arrow_forward_ios, context: context),
            ],
          ),
              ),
          ),
        ],
      ),
    );
  }

 Widget buildListTileSettings(String title,{IconData? icon,Widget? widget,required BuildContext context}) {
    return InkWell(
      onTap: (){
        if(widget !=null){
          showModalBottomSheet(
            enableDrag: false,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50)
                ),
              ),
              context: context,
              builder: (context){
                return widget;
              });
        }
      },
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 22),
        ),
        trailing: Icon(
          icon,
          color: Colors.black,
        ),
      ),
    );
  }
}
