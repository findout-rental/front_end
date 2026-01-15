import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class RoleToggle extends StatelessWidget {
  final String optionOneText;
  final String optionTwoText;

  final bool value;
  final ValueChanged<bool> onChanged;

  const RoleToggle({
    super.key,
    required this.optionOneText,
    required this.optionTwoText,
    required this.value,
    required this.onChanged,
  });

  /// Factory constructor مريح لحالة Tenant / Owner
  factory RoleToggle.tenantOwner({
    Key? key,
    required bool isTenant,
    required ValueChanged<bool> onChanged,
  }) {
    return RoleToggle(
      key: key,
      optionOneText: 'tenant'.tr,
      optionTwoText: 'owner'.tr,
      value: isTenant,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.dividerColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildItem(context, optionOneText, true),
          _buildItem(context, optionTwoText, false),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, String text, bool itemValue) {
    final theme = Theme.of(context);
    final bool isActive = value == itemValue;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(itemValue),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? theme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge?.copyWith(
              fontSize: 14,
              color: isActive
                  ? theme.colorScheme.onPrimary
                  : theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ),
    );
  }
}
