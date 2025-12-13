import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class UserRankingListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> users;
  final int startRank;

  const UserRankingListWidget({
    super.key,
    required this.users,
    this.startRank = 4,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (users.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'emoji_events_outlined',
                color:
                    isDark ? const Color(0xFF3D3D3D) : const Color(0xFFE0E0E0),
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'No rankings yet',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isDark
                      ? const Color(0xFFB0B0B0)
                      : const Color(0xFF9E9E9E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start your japa practice to appear on the leaderboard',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? const Color(0xFF808080)
                      : const Color(0xFFBDBDBD),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: users.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final user = users[index];
        final rank = startRank + index;
        return _buildUserCard(context, user, rank);
      },
    );
  }

  Widget _buildUserCard(
      BuildContext context, Map<String, dynamic> user, int rank) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3D3D3D) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF7A00),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    isDark ? const Color(0xFF3D3D3D) : const Color(0xFFE0E0E0),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: CustomImageWidget(
                imageUrl: user['avatar'] as String,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                semanticLabel: user['semanticLabel'] as String,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'] as String,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${user['japaCount']} japas',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? const Color(0xFFB0B0B0)
                        : const Color(0xFF9E9E9E),
                  ),
                ),
              ],
            ),
          ),
          CustomIconWidget(
            iconName: 'chevron_right',
            color: isDark ? const Color(0xFF808080) : const Color(0xFFBDBDBD),
            size: 20,
          ),
        ],
      ),
    );
  }
}
