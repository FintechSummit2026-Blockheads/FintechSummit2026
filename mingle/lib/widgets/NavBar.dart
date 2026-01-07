import 'dart:convert' show jsonDecode;

import 'package:flutter/material.dart';
// import 'package:mingle/backend-client.dart' show BackendClient;
import 'package:mingle/styles/colors.dart';
import 'package:mingle/screens/explore/explore-page.dart';
import 'package:mingle/NavController.dart';
import 'package:get/get.dart';

class NavBar extends StatefulWidget {
  NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final NavController navController = Get.find();
  Map<String, dynamic> profile = Map();

  List<Widget> _pages = [
    ExplorePage(),
  ];

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();

  //   BackendClient cilent = BackendClient();
  //   final supabase = Supabase.instance.client;
  //   User? user = null;
  //   user = supabase.auth.currentUser;
  //   cilent.getRequest("/user/seller/${user?.id}").then((res) {
  //     setState(() {
  //       profile = jsonDecode(res.body);
  //       print(profile);
  //       _pages = [
  //         ExplorePage(),
  //       ];
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _pages[navController.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navController.selectedIndex.value,
          backgroundColor: primary,
          selectedItemColor: secondary,
          unselectedItemColor: Colors.black,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          onTap: navController.changeTabIndex,
          items: const [
            // BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.search), 
              label: 'Search'),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              key: Key("create-item"),
              icon: Icon(Icons.sell),
              label: 'Sell',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person), 
              label: 'Profile'),
          ],
        ),
      ),
    );
  }
}