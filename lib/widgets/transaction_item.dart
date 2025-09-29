import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';

class TransactionItem extends StatelessWidget {
  final String type;
  final double amount;
  final String description;
  final DateTime timestamp;
  final String status;

  const TransactionItem({
    super.key,
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
    required this.status,
  });

  IconData get _getIcon {
    switch (type) {
      case 'transfer':
        return Icons.send;
      case 'deposit':
        return Icons.add_circle;
      case 'withdrawal':
        return Icons.remove_circle;
      case 'payment':
        return Icons.payment;
      default:
        return Icons.receipt;
    }
  }

  Color get _getIconColor {
    switch (type) {
      case 'transfer':
        return AppColors.info;
      case 'deposit':
        return AppColors.success;
      case 'withdrawal':
        return AppColors.error;
      case 'payment':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  Color get _getAmountColor {
    return amount > 0 ? AppColors.success : AppColors.error;
  }

  String get _getFormattedAmount {
    final formattedAmount = NumberFormat.currency(
      symbol: amount > 0 ? '+' : '',
      decimalDigits: 2,
    ).format(amount.abs());
    return formattedAmount;
  }

  String get _getFormattedTime {
    return DateFormat('MMM dd, HH:mm').format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getIconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getIcon,
              color: _getIconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getFormattedTime,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _getFormattedAmount,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getAmountColor,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: status == 'completed' 
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: status == 'completed' ? AppColors.success : AppColors.warning,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
