import 'package:flutter/material.dart';
import 'package:mingle/components/mingle-title.dart';
import 'package:mingle/screens/dates/restaurant-dates-card.dart';

class RestaurantDatePage extends StatelessWidget {
  RestaurantDatePage({super.key});

  // To replace with getDatesArray or sth
  // May need to get name & photo from user's ID separately
  final List<Map<String, dynamic>> matches = [
    {
      "a": {
        "id": "user_001",
        "name": "Ryan",
        "photo": "https://i.pravatar.cc/150?img=12",
      },
      "b": {
        "id": "user_002",
        "name": "Jamie",
        "photo": "https://randomuser.me/api/portraits/women/44.jpg",
      },
      "dateTime": "2026-01-07T18:30:00",
      "dateId": "match_001",
    },
    {
      "a": {
        "id": "user_003",
        "name": "Ethan",
        "photo": "https://i.pravatar.cc/150?img=3",
      },
      "b": {
        "id": "user_004",
        "name": "Jamie",
        "photo": "https://randomuser.me/api/portraits/women/44.jpg",
      },
      "dateTime": "2026-01-07T18:30:00",
      "dateId": "match_001",
    },
    {
      "a": {
        "id": "user_005",
        "name": "Daniel",
        "photo": "https://i.pravatar.cc/150?img=8",
      },
      "b": {
        "id": "user_006",
        "name": "Jamie",
        "photo": "https://randomuser.me/api/portraits/women/44.jpg",
      },
      "dateTime": "2026-01-07T18:30:00",
      "dateId": "match_001",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar at the top
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: mingleTitle(size: 30),
      ),

      // Body of the page
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: matches.length,
          itemBuilder: (context, index) {
            return RestaurantDateCard(match: matches[index]);
          },
        ),
      ),
    );
  }

}
