import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../src/toolbar.dart';
import 'modal_select_emoji.dart';
import 'modal_input_url.dart';
import 'toolbar_item.dart';

class MarkdownToolbar extends StatelessWidget {
  MarkdownToolbar({
    Key? key,
    required this.onPreviewChanged,
    required this.controller,
    this.emojiConvert = true,
    required this.focusNode,
    required this.isEditorFocused,
    this.autoCloseAfterSelectEmoji = true,
  })  : toolbar = Toolbar(
          controller: controller,
          focusNode: focusNode,
          isEditorFocused: isEditorFocused,
        ),
        super(key: key);

  final VoidCallback onPreviewChanged;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool emojiConvert;
  final bool autoCloseAfterSelectEmoji;
  final Toolbar toolbar;
  final ValueChanged<bool> isEditorFocused;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      width: double.infinity,
      height: 45,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // preview
            ToolbarItem(
              key: const ValueKey<String>("toolbar_view_item"),
              icon: FontAwesomeIcons.eye,
              onPressedButton: () {
                onPreviewChanged.call();
              },
            ),
            // select single line
            ToolbarItem(
              key: const ValueKey<String>("toolbar_selection_action"),
              icon: FontAwesomeIcons.textWidth,
              onPressedButton: () {
                toolbar.selectSingleLine();
              },
            ),
            // bold
            ToolbarItem(
              key: const ValueKey<String>("toolbar_bold_action"),
              icon: FontAwesomeIcons.bold,
              onPressedButton: () {
                toolbar.action("**", "**");
              },
            ),
            // italic
            ToolbarItem(
              key: const ValueKey<String>("toolbar_italic_action"),
              icon: FontAwesomeIcons.italic,
              onPressedButton: () {
                toolbar.action("_", "_");
              },
            ),
            // strikethrough
            ToolbarItem(
              key: const ValueKey<String>("toolbar_strikethrough_action"),
              icon: FontAwesomeIcons.strikethrough,
              onPressedButton: () {
                toolbar.action("~~", "~~");
              },
            ),
            // heading
            ToolbarItem(
              key: const ValueKey<String>("toolbar_heading_action"),
              icon: FontAwesomeIcons.heading,
              isExpandable: true,
              items: [
                ToolbarItem(
                  key: const ValueKey<String>("h1"),
                  icon: "H1",
                  onPressedButton: () => toolbar.action("# ", ""),
                ),
                ToolbarItem(
                  key: const ValueKey<String>("h2"),
                  icon: "H2",
                  onPressedButton: () => toolbar.action("## ", ""),
                ),
                ToolbarItem(
                  key: const ValueKey<String>("h3"),
                  icon: "H3",
                  onPressedButton: () => toolbar.action("### ", ""),
                ),
              ],
            ),
            // unorder list
            ToolbarItem(
              key: const ValueKey<String>("toolbar_unorder_list_action"),
              icon: FontAwesomeIcons.listUl,
              onPressedButton: () {
                toolbar.action("* ", "");
              },
            ),
            // checkbox list
            ToolbarItem(
              key: const ValueKey<String>("toolbar_checkbox_list_action"),
              icon: FontAwesomeIcons.tasks,
              isExpandable: true,
              items: [
                ToolbarItem(
                  key: const ValueKey<String>("checkbox"),
                  icon: FontAwesomeIcons.solidCheckSquare,
                  onPressedButton: () {
                    toolbar.action("- [x] ", "");
                  },
                ),
                ToolbarItem(
                  key: const ValueKey<String>("uncheckbox"),
                  icon: FontAwesomeIcons.square,
                  onPressedButton: () {
                    toolbar.action("- [ ] ", "");
                  },
                )
              ],
            ),
            // emoji
            ToolbarItem(
              key: const ValueKey<String>("toolbar_emoji_action"),
              icon: FontAwesomeIcons.solidSmile,
              onPressedButton: () {
                _showModalSelectEmoji(context, controller.selection);
              },
            ),
            // link
            ToolbarItem(
              key: const ValueKey<String>("toolbar_link_action"),
              icon: FontAwesomeIcons.link,
              onPressedButton: () {
                if (toolbar.checkHasSelection()) {
                  toolbar.action("[enter link description here](", ")");
                } else {
                  _showModalInputUrl(context, "[enter link description here](",
                      controller.selection);
                }
              },
            ),
            // image
            ToolbarItem(
              key: const ValueKey<String>("toolbar_image_action"),
              icon: FontAwesomeIcons.image,
              onPressedButton: () {
                if (toolbar.checkHasSelection()) {
                  toolbar.action("![enter image description here](", ")");
                } else {
                  _showModalInputUrl(
                    context,
                    "![enter image description here](",
                    controller.selection,
                  );
                }
              },
            ),
            // blockquote
            ToolbarItem(
              key: const ValueKey<String>("toolbar_blockquote_action"),
              icon: FontAwesomeIcons.quoteLeft,
              onPressedButton: () {
                toolbar.action("> ", "");
              },
            ),
            // code
            ToolbarItem(
              key: const ValueKey<String>("toolbar_code_action"),
              icon: FontAwesomeIcons.code,
              onPressedButton: () {
                toolbar.action("`", "`");
              },
            ),
            // line
            ToolbarItem(
              key: const ValueKey<String>("toolbar_line_action"),
              icon: FontAwesomeIcons.rulerHorizontal,
              onPressedButton: () {
                toolbar.action("\n___\n", "");
              },
            ),
          ],
        ),
      ),
    );
  }

  // show modal select emoji
  Future<dynamic> _showModalSelectEmoji(
      BuildContext context, TextSelection selection) {
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (context) {
        return ModalSelectEmoji(
          emojiConvert: emojiConvert,
          onChanged: (String emot) {
            if (autoCloseAfterSelectEmoji) Navigator.pop(context);
            final newSelection = toolbar.getSelection(selection);

            toolbar.action(emot, "", textSelection: newSelection);
            // change selection baseoffset if not auto close emoji
            if (!autoCloseAfterSelectEmoji) {
              selection = TextSelection.collapsed(
                offset: newSelection.baseOffset + emot.length,
              );
              focusNode.unfocus();
            }
          },
        );
      },
    );
  }

  // show modal input
  Future<dynamic> _showModalInputUrl(
    BuildContext context,
    String leftText,
    TextSelection selection,
  ) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return ModalInputUrl(
          toolbar: toolbar,
          leftText: leftText,
          selection: selection,
        );
      },
    );
  }
}
