import 'package:flutter/material.dart';

/// Widget for the Wallet Info (المحفظة) section
class WalletInfoSection extends StatelessWidget {
  final num currentBalance;
  final num frozenBalance;
  final num withdrawnBalance;

  const WalletInfoSection({
    super.key,
    required this.currentBalance,
    required this.frozenBalance,
    required this.withdrawnBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'المحفظة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildBalanceItem('الرصيد الحالي', '$currentBalance جنيه'),
            const SizedBox(height: 16),
            _buildBalanceItem('الرصيد المجمد', '$frozenBalance جنيه'),
            const SizedBox(height: 16),
            _buildBalanceItem('الرصيد المسحوب', '$withdrawnBalance جنيه'),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
      ],
    );
  }
}
