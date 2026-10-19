import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'latest_failure_screenshot.dart';

class LatestFailureSection extends StatelessWidget {
  const LatestFailureSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Latest Failure Screenshot',
            style: TextStyle(
              color: AppColors.text(context),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          const LatestFailureScreenshot(),
        ],
      ),
    );
  }
}
