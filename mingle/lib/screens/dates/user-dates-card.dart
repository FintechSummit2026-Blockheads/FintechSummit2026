import 'package:flutter/material.dart';
import 'package:mingle/screens/profile/mini-profile.dart';

class UserDatesCard extends StatefulWidget {
  final Map<String, dynamic> match;

  const UserDatesCard({super.key, required this.match});

  @override
  State<UserDatesCard> createState() => _UserDatesCardState();
}

class _UserDatesCardState extends State<UserDatesCard> {
  bool accepted = false;
  bool declined = false;

  final TextEditingController keyController = TextEditingController();

  @override
  void dispose() {
    keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If declined, remove card completely
    if (declined) {
      return const SizedBox.shrink();
    }

    final DateTime date =
        DateTime.parse(widget.match["dateTime"]);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// A & B profiles
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MiniProfile(profile: widget.match["a"]),
                const SizedBox(width: 32),
                MiniProfile(profile: widget.match["b"]),
              ],
            ),

            const SizedBox(height: 16),

            /// Date & Time
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(
                  "${date.day}/${date.month}/${date.year} • "
                  "${date.hour}:${date.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Restaurant
            Text(
              "At: ${widget.match["restaurant"] ?? "Unknown"}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),

            /// Accept / Decline Buttons
            if (!accepted)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        accepted = true;
                      });
                    },
                    child: const Text("Accept"),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        declined = true;
                      });
                    },
                    child: const Text("Decline"),
                  ),
                ],
              ),

            /// Key Input Field (Only if accepted)
            if (accepted)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  controller: keyController,
                  decoration: InputDecoration(
                    labelText: "Enter the Key here",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        print(
                          "Entered key for ${widget.match["matchId"]}: ${keyController.text}",
                        );
                        print("Match object: ${widget.match}");
                        print("Restaurant key: ${widget.match["restaurant"]}");
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
