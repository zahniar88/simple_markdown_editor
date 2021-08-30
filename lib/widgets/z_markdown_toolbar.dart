import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_markdown_editor/src/toolbar.dart';
import 'package:simple_markdown_editor/widgets/emoji_list.dart';
import 'package:simple_markdown_editor/widgets/modal_input_url.dart';
import 'package:simple_markdown_editor/widgets/toolbar_item.dart';

class ZMarkdownToolbar extends StatelessWidget {
  ZMarkdownToolbar({
    Key? key,
    required this.onPreviewChanged,
    required this.controller,
    required this.isPreview,
    this.emojiConvert = true,
    required this.focusNode,
    this.autoCloseAfterSelectEmoji = true,
  })  : this.toolbar = Toolbar(controller: controller, focusNode: focusNode),
        super(key: key);

  final VoidCallback onPreviewChanged;
  final TextEditingController controller;
  final bool isPreview;
  final FocusNode focusNode;
  final bool emojiConvert;
  final bool autoCloseAfterSelectEmoji;
  final Toolbar toolbar;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      width: double.infinity,
      height: 60,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // preview
            ToolbarItem(
              key: ValueKey<String>("toolbar_view_item"),
              icon:
                  isPreview ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
              onPressed: () {
                onPreviewChanged.call();
              },
            ),

            // show only if _isPreview is false
            if (!isPreview) ...[
              // bold
              ToolbarItem(
                key: ValueKey<String>("toolbar_bold_action"),
                icon: FontAwesomeIcons.bold,
                onPressed: () {
                  toolbar.action("**", "**");
                },
              ),
              // italic
              ToolbarItem(
                key: ValueKey<String>("toolbar_italic_action"),
                icon: FontAwesomeIcons.italic,
                onPressed: () {
                  toolbar.action("*", "*");
                },
              ),
              // strikethrough
              ToolbarItem(
                key: ValueKey<String>("toolbar_strikethrough_action"),
                icon: FontAwesomeIcons.strikethrough,
                onPressed: () {
                  toolbar.action("~~", "~~");
                },
              ),
              // heading
              ToolbarItem(
                key: ValueKey<String>("toolbar_heading_action"),
                icon: FontAwesomeIcons.heading,
                onPressed: () {
                  toolbar.action("## ", "");
                },
              ),
              // unorder list
              ToolbarItem(
                key: ValueKey<String>("toolbar_unorderlist_action"),
                icon: FontAwesomeIcons.listUl,
                onPressed: () {
                  toolbar.action("* ", "");
                },
              ),
              // link
              ToolbarItem(
                key: ValueKey<String>("toolbar_link_action"),
                icon: FontAwesomeIcons.link,
                onPressed: () {
                  if (toolbar.checkHasSelection())
                    toolbar.action("[enter link description here](", ")");
                  else
                    _showModalInputUrl(context,
                        "[enter link description here](", controller.selection);
                },
              ),
              // image
              ToolbarItem(
                key: ValueKey<String>("toolbar_image_action"),
                icon: FontAwesomeIcons.image,
                onPressed: () {
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
              // emoji
              ToolbarItem(
                key: ValueKey<String>("toolbar_emoji_action"),
                icon: FontAwesomeIcons.solidSmile,
                onPressed: () {
                  _showModalSelectEmoji(context, controller.selection);
                },
              ),
              // blockquote
              ToolbarItem(
                key: ValueKey<String>("toolbar_blockquote_action"),
                icon: FontAwesomeIcons.quoteLeft,
                onPressed: () {
                  toolbar.action("> ", "");
                },
              ),
              // code
              ToolbarItem(
                key: ValueKey<String>("toolbar_code_action"),
                icon: FontAwesomeIcons.code,
                onPressed: () {
                  toolbar.action("`", "`");
                },
              ),
              // line
              ToolbarItem(
                key: ValueKey<String>("toolbar_line_action"),
                icon: FontAwesomeIcons.rulerHorizontal,
                onPressed: () {
                  toolbar.action("\n___\n", "");
                },
              ),
            ],
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (context) {
        return EmojiList(
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
      shape: RoundedRectangleBorder(
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
