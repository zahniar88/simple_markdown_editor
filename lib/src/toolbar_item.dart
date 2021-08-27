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
    return Material(
      type: MaterialType.transparency,
      borderRadius: BorderRadius.circular(50),
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        onPressed: onPressed,
        splashColor: Colors.teal.withOpacity(0.4),
        highlightColor: Colors.teal.withOpacity(0.4),
        icon: Icon(
          icon,
          size: 16,
        ),
        tooltip: tooltip,
      ),
    );
  }
}
