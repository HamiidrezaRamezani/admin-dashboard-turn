import 'package:flutter/material.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              children: [
                Text(
                  'گزارشات',
                  style: TextStyle(
                      color: Colors.black, fontFamily: "bold", fontSize: 30.0),
                ),
              ],
            ),
            const SizedBox(
              height: 24.0,
            ),
            // Expanded(
            //     child: ),
            const SizedBox(
              height: 36.0,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
        },
        label: const Text(
          'دریافت فایل Excel',
          style: TextStyle(
              color: Color(0xFFFFFFFF), fontFamily: "bold", fontSize: 20.0),
        ),
        backgroundColor: const Color(0xFF628DFF),
      ),
    );
  }
}
