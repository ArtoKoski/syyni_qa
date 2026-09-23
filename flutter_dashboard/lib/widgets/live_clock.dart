import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LiveClock extends StatefulWidget {
  const LiveClock({super.key});

  @override
  State<LiveClock> createState() => _LiveClockState();
}

class _LiveClockState extends State<LiveClock> {
  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Current Time: ${DateFormat('dd.MM.yyyy HH:mm:ss').format(DateTime.now())}',
      style: const TextStyle(
        color: Colors.greenAccent,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
