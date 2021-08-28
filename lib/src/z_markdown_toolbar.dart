import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_markdown_editor/src/emoji_list.dart';
import 'package:simple_markdown_editor/src/toolbar_item.dart';

class ZMarkdownToolbar extends StatelessWidget {
  ZMarkdownToolbar({
    Key? key,
    required this.onPreviewChanged,
    required this.controller,
    required this.isPreview,
    this.emojiConvert = true,
    required this.focusNode,
    this.autoCloseAfterSelectEmoji = true,
  }) : super(key: key);

  final VoidCallback onPreviewChanged;
  final TextEditingController controller;
  final bool isPreview;
  final FocusNode focusNode;
  final bool emojiConvert;
  final bool autoCloseAfterSelectEmoji;

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
                  _toolbarAction("**", "**");
                },
              ),
              // italic
              ToolbarItem(
                icon: FontAwesomeIcons.italic,
                onPressed: () {
                  _toolbarAction("*", "*");
                },
              ),
              // strikethrough
              ToolbarItem(
                icon: FontAwesomeIcons.strikethrough,
                onPressed: () {
                  _toolbarAction("~~", "~~");
                },
              ),
              // heading
              ToolbarItem(
                icon: FontAwesomeIcons.heading,
                onPressed: () {
                  _toolbarAction("## ", "");
                },
              ),
              // unorder list
              ToolbarItem(
                icon: FontAwesomeIcons.listUl,
                onPressed: () {
                  _toolbarAction("- ", "");
                },
              ),
              // link
              ToolbarItem(
                icon: FontAwesomeIcons.link,
                onPressed: () {
                  if (_checkHasSelection())
                    _toolbarAction("[enter link description here](", ")");
                  else
                    _showModalInput(context, "[enter link description here");
                },
              ),
              // image
              ToolbarItem(
                icon: FontAwesomeIcons.image,
                onPressed: () {
                  if (_checkHasSelection())
                    _toolbarAction("![enter image description here](", ")");
                  else
                    _showModalInput(context, "![enter image description here");
                },
              ),
              // emoji
              ToolbarItem(
                icon: FontAwesomeIcons.solidSmile,
                onPressed: () {
                  showModalBottomSheet(
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
                          _toolbarAction("$emot", "");
                        },
                      );
                    },
                  );
                },
              ),
              // blockquote
              ToolbarItem(
                icon: FontAwesomeIcons.quoteLeft,
                onPressed: () {
                  _toolbarAction("> ", "");
                },
              ),
              // code
              ToolbarItem(
                icon: FontAwesomeIcons.code,
                onPressed: () {
                  _toolbarAction("`", "`");
                },
              ),
              // line
              ToolbarItem(
                icon: FontAwesomeIcons.rulerHorizontal,
                onPressed: () {
                  _toolbarAction("___\n", "");
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  // show modal input
  Future<dynamic> _showModalInput(BuildContext context, String leftText) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: EdgeInsets.symmetric(horizontal: 30).copyWith(
            top: 30,
            bottom: 60,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Please provide a URL here.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 5),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  autocorrect: false,
                  decoration: InputDecoration.collapsed(
                    hintText: "Type link here",
                  ),
                  enableInteractiveSelection: true,
                  onFieldSubmitted: (String value) {
                    Navigator.pop(context);

                    /// check if the user entered an empty input
                    if (value.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Please input url",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.red.withOpacity(0.8),
                          duration: Duration(milliseconds: 700),
                        ),
                      );
                    } else {
                      if (!value
                          .contains(RegExp(r'https?:\/\/(www.)?([^\s]+)'))) {
                        value = "http://" + value;
                      }

                      _toolbarAction(leftText, "]($value)");
                    }
                  },
                ),
              ),
              Text(
                "example: https://example.com",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // check if have selection text
  bool _checkHasSelection() {
    return (controller.selection.baseOffset -
            controller.selection.extentOffset) !=
        0;
  }

  // toolbar action
  void _toolbarAction(String left, String right) async {
    focusNode.requestFocus();
    await Future.delayed(Duration(milliseconds: 1));
    final currentTextValue = controller.value.text;
    final selection = controller.selection;
    final middle = selection.textInside(currentTextValue);
    var selectionText = '$left$middle$right';
    var contentOffset = left.length + middle.length;

    // check if middle text have char \n
    if (middle.split("\n").length > 1) {
      final splitData = middle.split("\n");
      var index = 0;
      var resetLength = 0;
      var addLength = 0;

      selectionText = splitData.map((text) {
        index++;
        addLength += left.length + right.length;

        if (text.trim().isEmpty) {
          addLength -= left.length + right.length;
        }

        if (text.contains(left) && text.contains(right)) {
          resetLength += left.length + right.length;
          return index == splitData.length
              ? text.replaceFirst(left, "").replaceFirst(right, "")
              : text.replaceFirst(left, "").replaceFirst(right, "") + "\n";
        }

        final newText = text.trim().isEmpty ? text : "$left$text$right";
        return index == splitData.length ? newText : "$newText\n";
      }).join();

      contentOffset = addLength + (middle.length - (resetLength * 2));
    }

    final newTextValue = selection.textBefore(currentTextValue) +
        selectionText +
        selection.textAfter(currentTextValue);

    controller.value = controller.value.copyWith(
      text: newTextValue,
      selection: TextSelection.collapsed(
        offset: selection.baseOffset + contentOffset,
      ),
    );
  }
}
