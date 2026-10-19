import 'package:flutter/material.dart';

import '../models/build_info.dart';
import '../services/report_service.dart';
import '../theme/app_colors.dart';

class BuildInfoSection extends StatelessWidget {
  const BuildInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BuildInfo>(
      future: ReportService().loadBuildInfo(),

      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final build = snapshot.data!;

        return Container(
          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: AppColors.card(context),
            borderRadius: BorderRadius.circular(16),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'Build Information',
                style: TextStyle(
                  color: AppColors.text(context),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Text('Branch: ${build.branch}'),
              Text('Commit: ${build.commit}'),
              Text('Author: ${build.author}'),
              Text('Message: ${build.message}'),
            ],
          ),
        );
      },
    );
  }
}
