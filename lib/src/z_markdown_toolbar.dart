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
  }) : super(key: key);

  final VoidCallback onPreviewChanged;
  final TextEditingController controller;
  final bool isPreview;
  final FocusNode focusNode;
  final bool emojiConvert;

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
              // link
              ToolbarItem(
                icon: FontAwesomeIcons.link,
                onPressed: () {
                  _showModalInputLink(context);
                },
              ),
              // image
              ToolbarItem(
                icon: FontAwesomeIcons.image,
                onPressed: () {
                  _showModalInputImage(context);
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
                          Navigator.pop(context);
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

  // show modal input link
  Future<dynamic> _showModalInputLink(BuildContext context) {
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
          padding: EdgeInsets.symmetric(horizontal: 30)
              .copyWith(top: 30, bottom: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Please provide a URL for your link.",
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

                    if (value.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please input url")),
                      );
                    } else {
                      _toolbarAction(
                          "[enter link description here]($value)", "");
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

  // show modal input link
  Future<dynamic> _showModalInputImage(BuildContext context) {
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
          padding: EdgeInsets.symmetric(horizontal: 30)
              .copyWith(top: 30, bottom: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Please provide a URL for your image.",
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

                    if (value.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please input image url")),
                      );
                    } else {
                      _toolbarAction(
                          "![enter image description here]($value)", "");
                    }
                  },
                ),
              ),
              Text(
                "example: https://example.com/image.jpeg",
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

  // toolbar action
  void _toolbarAction(String left, String right) async {
    focusNode.requestFocus();
    await Future.delayed(Duration(milliseconds: 1));
    final currentTextValue = controller.value.text;
    final selection = controller.selection;
    final middle = selection.textInside(currentTextValue);
    final newTextValue = selection.textBefore(currentTextValue) +
        '$left$middle$right' +
        selection.textAfter(currentTextValue);

    controller.value = controller.value.copyWith(
      text: newTextValue,
      selection: TextSelection.collapsed(
        offset: selection.baseOffset + left.length + middle.length,
      ),
    );
  }
}
