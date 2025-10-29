import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../providers/banking_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/ui_components.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          Consumer<BankingProvider>(
            builder: (context, bankingProvider, child) {
              if (bankingProvider.unreadNotificationsCount == 0) {
                return const SizedBox.shrink();
              }
              return TextButton(
                onPressed: () async {
                  await bankingProvider.markAllNotificationsAsRead();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All notifications marked as read'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                },
                child: const Text('Mark all read'),
              );
            },
          ),
        ],
      ),
      body: Consumer<BankingProvider>(
        builder: (context, bankingProvider, child) {
          final notifications = bankingProvider.notifications;
          
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.bellOff,
                    size: 64,
                    color: AppColors.mutedForeground,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You\'re all caught up!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _buildNotificationCard(context, notification, bankingProvider);
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    dynamic notification,
    BankingProvider provider,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUnread = notification.isUnread;
    
    Color getNotificationColor() {
      switch (notification.type) {
        case 'success':
          return AppColors.success;
        case 'warning':
          return AppColors.warning;
        case 'error':
          return AppColors.destructive;
        case 'info':
        default:
          return AppColors.info;
      }
    }

    IconData getNotificationIcon() {
      switch (notification.type) {
        case 'success':
          return LucideIcons.checkCircle;
        case 'warning':
          return LucideIcons.alertTriangle;
        case 'error':
          return LucideIcons.xCircle;
        case 'info':
        default:
          return LucideIcons.info;
      }
    }

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.destructive,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          LucideIcons.trash2,
          color: AppColors.destructiveForeground,
        ),
      ),
      onDismissed: (direction) {
        // Notification deletion would go here
      },
      child: AppCard(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        onTap: () async {
          if (isUnread) {
            await provider.markNotificationAsRead(notification.id);
          }
          // Navigate to action if available
          if (notification.actionUrl != null) {
            // Handle navigation based on actionUrl
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: getNotificationColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                getNotificationIcon(),
                size: 20,
                color: getNotificationColor(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                            color: isUnread 
                                ? (isDark ? AppColors.darkForeground : AppColors.foreground)
                                : AppColors.mutedForeground,
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTimestamp(notification.timestamp),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.mutedForeground.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              LucideIcons.chevronRight,
              size: 16,
              color: AppColors.mutedForeground,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }
}

