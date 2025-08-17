import 'package:flutter/material.dart';

class HourlyForcastItem extends StatelessWidget {
  const HourlyForcastItem({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 6,
        child: Container(
          width: 100,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),

            child: Column(
              children: [
                Text(
                  '03:00',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Icon(Icons.cloud, size: 32),
                const SizedBox(height: 8),
                Text('320.12'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
