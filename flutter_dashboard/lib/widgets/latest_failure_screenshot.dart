import 'package:flutter/material.dart';

import '../services/report_service.dart';

class LatestFailureScreenshot extends StatelessWidget {
  const LatestFailureScreenshot({super.key});

  @override
  Widget build(BuildContext context) {
    final screenshotUrl =
        '${ReportService.baseUrl}/api/latest-failure-screenshot'
        '?t=${DateTime.now().millisecondsSinceEpoch}';

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(Icons.photo_camera, size: 28, color: Colors.orange),
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
                      child: Image.network(
                        screenshotUrl,
                        key: ValueKey(screenshotUrl),
                        fit: BoxFit.cover,
                      ),
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
                  key: ValueKey(screenshotUrl),
                  fit: BoxFit.contain,

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
