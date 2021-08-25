import 'package:flutter/material.dart';

class ToolbarItem extends StatelessWidget {
  const ToolbarItem({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 16,
      ),
      tooltip: tooltip,
    );
  }
}
