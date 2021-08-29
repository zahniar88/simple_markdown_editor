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
                icon: FontAwesomeIcons.bold,
                onPressed: () {
                  toolbar.action("**", "**");
                },
              ),
              // italic
              ToolbarItem(
                icon: FontAwesomeIcons.italic,
                onPressed: () {
                  toolbar.action("*", "*");
                },
              ),
              // strikethrough
              ToolbarItem(
                icon: FontAwesomeIcons.strikethrough,
                onPressed: () {
                  toolbar.action("~~", "~~");
                },
              ),
              // heading
              ToolbarItem(
                icon: FontAwesomeIcons.heading,
                onPressed: () {
                  toolbar.action("## ", "");
                },
              ),
              // unorder list
              ToolbarItem(
                icon: FontAwesomeIcons.listUl,
                onPressed: () {
                  toolbar.action("* ", "");
                },
              ),
              // link
              ToolbarItem(
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
                icon: FontAwesomeIcons.solidSmile,
                onPressed: () {
                  TextSelection selection = controller.selection;
                  _showModalSelectEmoji(context, selection);
                },
              ),
              // blockquote
              ToolbarItem(
                icon: FontAwesomeIcons.quoteLeft,
                onPressed: () {
                  toolbar.action("> ", "");
                },
              ),
              // code
              ToolbarItem(
                icon: FontAwesomeIcons.code,
                onPressed: () {
                  toolbar.action("`", "`");
                },
              ),
              // line
              ToolbarItem(
                icon: FontAwesomeIcons.rulerHorizontal,
                onPressed: () {
                  toolbar.action("___\n", "");
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

            toolbar.action(emot, "", textSelection: selection);

            // change selection baseoffset if not auto close emoji
            if (!autoCloseAfterSelectEmoji) {
              selection = TextSelection.collapsed(
                offset: selection.baseOffset + emot.length,
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
