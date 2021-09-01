import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ToolbarItem extends StatelessWidget {
  const ToolbarItem({
    Key? key,
    required this.icon,
    this.onPressedButton,
    this.tooltip,
    this.isExpandable = false,
    this.items,
  }) : super(key: key);

  final dynamic icon;
  final VoidCallback? onPressedButton;
  final String? tooltip;
  final bool isExpandable;
  final List? items;

  @override
  Widget build(BuildContext context) {
    return !isExpandable
        ? IconButton(
            onPressed: onPressedButton,
            splashColor: Colors.teal.withOpacity(0.4),
            highlightColor: Colors.teal.withOpacity(0.4),
            icon: icon is String
                ? Text(
                    icon,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  )
                : Icon(
                    icon,
                    size: 16,
                  ),
            tooltip: tooltip,
          )
        : ExpandableNotifier(
            child: Expandable(
              key: Key("list_button"),
              collapsed: ExpandableButton(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: icon is String
                      ? Text(
                          icon,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        )
                      : Icon(
                          icon,
                          size: 16,
                        ),
                ),
              ),
              expanded: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  child: Row(
                    children: [
                      for (var item in items!) item,
                      ExpandableButton(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            FontAwesomeIcons.solidTimesCircle,
                            size: 16,
                            color: Colors.red,
                          ),
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
