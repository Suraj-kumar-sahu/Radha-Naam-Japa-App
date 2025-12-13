import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class PodiumDisplayWidget extends StatelessWidget {
  final List<Map<String, dynamic>> topThreeUsers;

  const PodiumDisplayWidget({
    super.key,
    required this.topThreeUsers,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (topThreeUsers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (topThreeUsers.length > 1)
            _buildPodiumItem(context, topThreeUsers[1], 2, 140),
          const SizedBox(width: 12),
          if (topThreeUsers.isNotEmpty)
            _buildPodiumItem(context, topThreeUsers[0], 1, 180),
          const SizedBox(width: 12),
          if (topThreeUsers.length > 2)
            _buildPodiumItem(context, topThreeUsers[2], 3, 120),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(BuildContext context, Map<String, dynamic> user,
      int rank, double height) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isFirst = rank == 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isFirst
                      ? const Color(0xFFFF7A00)
                      : (isDark
                          ? const Color(0xFF3D3D3D)
                          : const Color(0xFFE0E0E0)),
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: CustomImageWidget(
                  imageUrl: user['avatar'] as String,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  semanticLabel: user['semanticLabel'] as String,
                ),
              ),
            ),
            if (isFirst)
              Positioned(
                top: -8,
                left: 0,
                right: 0,
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'emoji_events',
                    color: const Color(0xFFFFD700),
                    size: 28,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          user['name'] as String,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '${user['japaCount']} japas',
          style: theme.textTheme.bodySmall?.copyWith(
            color: const Color(0xFFFF7A00),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isFirst
                  ? [const Color(0xFFFF7A00), const Color(0xFFE65100)]
                  : [
                      isDark
                          ? const Color(0xFF3D3D3D)
                          : const Color(0xFFE0E0E0),
                      isDark
                          ? const Color(0xFF2D2D2D)
                          : const Color(0xFFD0D0D0),
                    ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: isFirst
                    ? Colors.white
                    : (isDark
                        ? const Color(0xFFE0E0E0)
                        : const Color(0xFF424242)),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
