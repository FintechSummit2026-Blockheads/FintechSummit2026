import 'package:flutter/material.dart';
import 'package:mingle/screens/profile/mini-profile.dart';

class RestaurantDateCard extends StatelessWidget {
  final Map<String, dynamic> match;

  const RestaurantDateCard({super.key, required this.match});

  void _showRevealDialog(BuildContext context, String name, String dateId) {
    // code will be generated using the logic in backend
    String code = "GDJ#&@";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Reveal Key for $name"),
        content: Text(
          code,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final DateTime date =
        DateTime.parse(match["dateTime"]);

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
            ///Date ID
            
            Text(
              "Date ID: ${match["dateId"]}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            /// A & B profiles
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MiniProfile(profile: match["a"]),
                const SizedBox(width: 32),
                MiniProfile(profile: match["b"]),
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
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Reveal Key Buttons for A & B
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showRevealDialog(context, match["a"]["name"], match["dateId"]);
                    },
                    child: Text("Reveal for ${match["a"]["name"]}"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showRevealDialog(context, match["b"]["name"], match["dateId"]);
                    },
                    child: Text("Reveal for ${match["b"]["name"]}"),
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
