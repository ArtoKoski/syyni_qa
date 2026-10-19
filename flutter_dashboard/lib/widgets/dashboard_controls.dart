import 'package:flutter/material.dart';

import '../services/report_service.dart';

class DashboardControls extends StatelessWidget {
  final String selectedSource;
  final bool isMockMode;

  final VoidCallback onSelectLocal;
  final VoidCallback onSelectGitHub;
  final VoidCallback onRunLocalTests;
  final VoidCallback onRunGitHubTests;
  final VoidCallback onOpenPlaywrightReport;

  final ValueChanged<String> onSourceChanged;

  const DashboardControls({
    super.key,
    required this.selectedSource,
    required this.isMockMode,
    required this.onSelectLocal,
    required this.onSelectGitHub,
    required this.onRunLocalTests,
    required this.onRunGitHubTests,
    required this.onSourceChanged,
    required this.onOpenPlaywrightReport,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Environment selection & filtering
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: onSelectLocal,
              icon: const Icon(Icons.computer),
              label: const Text('Local'),
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedSource == 'local'
                    ? Colors.green
                    : null,
                foregroundColor: selectedSource == 'local'
                    ? Colors.white
                    : null,
              ),
            ),

            const SizedBox(width: 12),

            ElevatedButton.icon(
              onPressed: onSelectGitHub,
              icon: const Icon(Icons.cloud),
              label: const Text('GitHub'),
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedSource == 'github'
                    ? Colors.blue
                    : null,
                foregroundColor: selectedSource == 'github'
                    ? Colors.white
                    : null,
              ),
            ),

            const SizedBox(width: 12),

            ElevatedButton.icon(
              onPressed: () => onSourceChanged('all'),
              icon: const Icon(Icons.dashboard),
              label: const Text('All'),
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedSource == 'all' ? Colors.orange : null,
                foregroundColor: selectedSource == 'all' ? Colors.white : null,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Backend status
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.cloud_done, color: Colors.blue),

              const SizedBox(width: 12),

              Expanded(child: Text('Backend: ${ReportService.baseUrl}')),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Test execution controls
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: onRunLocalTests,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Run Local Tests'),
            ),

            const SizedBox(width: 12),

            ElevatedButton.icon(
              onPressed: onRunGitHubTests,
              icon: const Icon(Icons.cloud),
              label: const Text('Run GitHub Tests'),
            ),

            const SizedBox(width: 20),

            ElevatedButton.icon(
              onPressed: onOpenPlaywrightReport,
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Open Playwright Report'),
            ),
          ],
        ),

        if (isMockMode) ...[
          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'MOCK MODE ENABLED',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
