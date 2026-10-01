import 'package:flutter/material.dart';

import '../models/build_info.dart';

class BuildInfoCard extends StatelessWidget {
  final BuildInfo buildInfo;

  const BuildInfoCard({super.key, required this.buildInfo});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'LATEST BUILD',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 12),

            Text('Branch: ${buildInfo.branch}'),

            Text('Commit: ${buildInfo.commit}'),

            Text('Author: ${buildInfo.author}'),

            Text('Message: ${buildInfo.message}'),
          ],
        ),
      ),
    );
  }
}
