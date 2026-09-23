import 'package:flutter/material.dart';

class ChartPlaceholder extends StatelessWidget {
  const ChartPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Text(
          "Playwright Test History Chart",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
    );
  }
}
