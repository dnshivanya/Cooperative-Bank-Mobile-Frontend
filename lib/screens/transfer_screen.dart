import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/ui_components.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  String? _selectedRecipient;
  
  final List<SavedRecipient> _savedRecipients = [
    SavedRecipient(
      id: '1',
      name: 'John Doe',
      accountNumber: '1234567890',
      bankName: 'Cooperative Bank',
    ),
    SavedRecipient(
      id: '2',
      name: 'Jane Smith',
      accountNumber: '0987654321',
      bankName: 'Cooperative Bank',
    ),
    SavedRecipient(
      id: '3',
      name: 'Mike Johnson',
      accountNumber: '5555666677',
      bankName: 'Other Bank',
    ),
  ];
  
  final List<double> _quickAmounts = [50, 100, 250, 500, 1000];

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _processTransfer() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transfer completed successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.go('/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Money'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Transfer Icon
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.send,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Saved Recipients
                if (_savedRecipients.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Saved Recipients',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Show all recipients
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _savedRecipients.length,
                      itemBuilder: (context, index) {
                        final recipient = _savedRecipients[index];
                        final isSelected = _selectedRecipient == recipient.id;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRecipient = recipient.id;
                              _recipientController.text = recipient.accountNumber;
                            });
                          },
                          child: Container(
                            width: 120,
                            margin: EdgeInsets.only(
                              right: index < _savedRecipients.length - 1 ? 12 : 0,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withOpacity(0.1)
                                  : AppColors.card,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.user,
                                  size: 24,
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.mutedForeground,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  recipient.name,
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Recipient Account
                CustomTextField(
                  controller: _recipientController,
                  label: 'Recipient Account Number',
                  hintText: 'Enter account number',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.account_balance_wallet,
                  suffixIcon: IconButton(
                    icon: Icon(LucideIcons.qrCode),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('QR Scanner coming soon!')),
                      );
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter recipient account number';
                    }
                    if (value.length < 10) {
                      return 'Please enter a valid account number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Amount with Quick Buttons
                CustomTextField(
                  controller: _amountController,
                  label: 'Amount',
                  hintText: 'Enter amount',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  prefixIcon: Icons.attach_money,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Please enter a valid amount';
                    }
                    if (amount > 100000) {
                      return 'Amount cannot exceed \$100,000';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _quickAmounts.map((amount) {
                    return ActionChip(
                      label: Text('\$${amount.toStringAsFixed(0)}'),
                      onPressed: () {
                        setState(() {
                          _amountController.text = amount.toStringAsFixed(2);
                        });
                      },
                      backgroundColor: AppColors.card,
                      side: BorderSide(color: AppColors.border),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Description
                CustomTextField(
                  controller: _descriptionController,
                  label: 'Description (Optional)',
                  hintText: 'Enter description',
                  maxLines: 3,
                  validator: (value) {
                    return null; // Optional field
                  },
                ),
                const SizedBox(height: 30),

                // Transfer Button
                CustomButton(
                  text: 'Transfer Money',
                  onPressed: _isLoading ? null : _processTransfer,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 20),

                // Transfer Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.info.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transfer Information:',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.info,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Transfers are processed instantly',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '• Transfer fee: \$2.50 per transaction',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '• Daily limit: \$10,000',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SavedRecipient {
  final String id;
  final String name;
  final String accountNumber;
  final String bankName;

  SavedRecipient({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.bankName,
  });
}
