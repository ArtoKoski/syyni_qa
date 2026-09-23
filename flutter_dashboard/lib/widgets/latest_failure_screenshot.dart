import 'package:flutter/material.dart';

class LatestFailureScreenshot extends StatelessWidget {
  const LatestFailureScreenshot({super.key});

  @override
  Widget build(BuildContext context) {
    const screenshotUrl = 'http://localhost:3000/api/latest-failure-screenshot';

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Latest Failed Screenshot',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Click image to enlarge',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),

          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4,
                      child: Image.network(screenshotUrl, fit: BoxFit.contain),
                    ),
                  );
                },
              );
            },

            child: SizedBox(
              height: 480,
              width: double.infinity,

              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),

                child: Image.network(
                  screenshotUrl,

                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text('No failed screenshot available'),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
