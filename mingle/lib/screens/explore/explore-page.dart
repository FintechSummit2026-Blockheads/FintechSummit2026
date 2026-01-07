import 'package:flutter/material.dart';
import 'package:mingle/styles/login-register-bg.dart';
import 'package:mingle/components/mingle-button.dart';
import 'package:mingle/styles/colors.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int currentIndex = 0;

  //to be updated with getRandomProfile or sth
  final List<Map<String, String>> profiles = [
    {
      "name": "Alex Tan",
      "description": "Fashion enthusiast who loves sustainable style.",
      "image": "https://via.placeholder.com/150",
    },
    {
      "name": "Jamie Lim",
      "description": "Minimalist. Coffee addict. Thrift lover.",
      "image": "https://via.placeholder.com/150",
    },
    {
      "name": "Chris Wong",
      "description": "Streetwear collector & reseller.",
      "image": "https://via.placeholder.com/150",
    },
  ];


  void nextProfile() {
    setState(() {
      currentIndex = (currentIndex + 1) % profiles.length;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: LoginRegisterBg(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Profile Picture
            CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage(
                profiles[currentIndex]["image"]!,
              ),
            ),

            const SizedBox(height: 32),

            /// Name
            Text(
              profiles[currentIndex]["name"]!,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            /// Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                profiles[currentIndex]["description"]!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: grey,
                ),
              ),
            ),

            const SizedBox(height: 64),

            /// Buttons
            Row(
              children: [
                Expanded(
                  child: mingleButton(
                    text: "Decline",
                    onPressed: nextProfile,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: mingleButton(
                    text: "Accept",
                    onPressed: nextProfile,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
