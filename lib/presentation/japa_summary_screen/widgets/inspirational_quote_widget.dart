import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Widget displaying an inspirational quote with author attribution
class InspirationalQuoteWidget extends StatelessWidget {
  final String quote;
  final String author;

  const InspirationalQuoteWidget({
    super.key,
    required this.quote,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E7), // Cream background matching screenshot
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quote text
          Text(
            quote,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.black87,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
          SizedBox(height: 2.h),
          // Author attribution
          Text(
            '— $author',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
