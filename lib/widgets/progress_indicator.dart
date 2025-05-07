import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double progress;
  final String? message;
  final bool isIndeterminate;

  const CustomProgressIndicator({
    Key? key,
    this.progress = 0.0,
    this.message,
    this.isIndeterminate = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use more subtle gradient colors
    final gradientColors = [
      const Color(0xFF6E6AE8),
      const Color(0xFF94A3B8),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isIndeterminate)
          SpinKitDoubleBounce(
            color: gradientColors[0],
            size: 50.0,
          )
        else
          Container(
            width: 200,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (message != null) ...[
          const SizedBox(height: 10),
          Text(
            message!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (!isIndeterminate) ...[
          const SizedBox(height: 5),
          Text(
            '${(progress * 100).toInt()}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}
