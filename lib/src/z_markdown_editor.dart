import 'package:flutter/material.dart';
import 'package:simple_markdown_editor/simple_markdown_editor.dart';
import 'package:simple_markdown_editor/src/emoji_parser.dart';
import 'package:simple_markdown_editor/src/z_markdown_toolbar.dart';

class ZMarkdownEditor extends StatefulWidget {
  /// create a widget to edit markdown
  ///
  /// ZMarkdownEditor is built on the basis of TextFormField
  ZMarkdownEditor({
    Key? key,
    this.controller,
    this.scrollController,
    this.onChanged,
    this.style,
    this.emojiConvert = false,
    this.onTap,
    this.validator,
    this.enableToolBar = false,
    this.autoCloseAfterSelectEmoji = true,
  }) : super(key: key);

  /// For enable toolbar options
  ///
  /// if false, toolbar widget will not display
  final bool enableToolBar;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  /// Creates a [FormField] that contains a [TextField].
  ///
  /// When a [controller] is specified, [initialValue] must be null (the default). If [controller] is
  /// null, then a [TextEditingController] will be constructed automatically and its text will be
  /// initialized to [initialValue] or the empty string.
  ///
  /// For documentation about the various parameters, see the [TextField] class and [new TextField],
  /// the constructor.
  final ScrollController? scrollController;

  /// Creates a [FormField] that contains a [TextField].
  ///
  /// When a [controller] is specified, [initialValue] must be null (the default). If [controller] is
  /// null, then a [TextEditingController] will be constructed automatically and its text will be
  /// initialized to [initialValue] or the empty string.
  ///
  /// For documentation about the various parameters, see the [TextField] class and [new TextField],
  ///  the constructor.
  final ValueChanged<String>? onChanged;

  /// Creates a [FormField] that contains a [TextField].
  ///
  /// When a [controller] is specified, [initialValue] must be null (the default). If [controller] is
  /// null, then a [TextEditingController] will be constructed automatically and its text will be
  ///
  /// initialized to [initialValue] or the empty string.
  /// For documentation about the various parameters, see the [TextField] class and [new TextField],
  /// the constructor.
  final TextStyle? style;

  /// to enable auto convert emoji
  ///
  /// if true, the string will be automatically converted to emoji
  ///
  /// example: :smiley: => 😃
  final bool emojiConvert;

  /// Creates a [FormField] that contains a [TextField].
  ///
  /// When a [controller] is specified, [initialValue] must be null (the default). If [controller] is
  /// null, then a [TextEditingController] will be constructed automatically and its text will be
  ///
  /// initialized to [initialValue] or the empty string.
  /// For documentation about the various parameters, see the [TextField] class and [new TextField],
  /// the constructor.
  final VoidCallback? onTap;

  /// Creates a [FormField] that contains a [TextField].
  ///
  /// When a [controller] is specified, [initialValue] must be null (the default). If [controller] is
  /// null, then a [TextEditingController] will be constructed automatically and its text will be
  /// initialized to [initialValue] or the empty string.
  ///
  /// For documentation about the various parameters, see the [TextField] class and [new TextField],
  /// the constructor.
  final FormFieldValidator<String?>? validator;

  /// if you set it to false,
  /// the modal will not disappear after you select the emoji
  final bool autoCloseAfterSelectEmoji;

  @override
  _ZMarkdownEditorState createState() => _ZMarkdownEditorState();
}

class _ZMarkdownEditorState extends State<ZMarkdownEditor> {
  // internal parameter
  late bool _isPreview;
  late TextEditingController _internalController;
  late FocusNode _internalFocus;
  late EmojiParser _emojiParser;

  @override
  void initState() {
    _internalController = widget.controller != null
        ? widget.controller!
        : TextEditingController();
    _internalFocus = FocusNode();
    _isPreview = false;
    _emojiParser = EmojiParser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        !_isPreview
            ? Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    maxLines: null,
                    focusNode: _internalFocus,
                    controller: _internalController,
                    scrollController: widget.scrollController,
                    onChanged: _onEditorChange,
                    onTap: widget.onTap,
                    validator: widget.validator,
                    autocorrect: false,
                    keyboardType: TextInputType.multiline,
                    toolbarOptions: ToolbarOptions(
                      copy: true,
                      paste: true,
                      cut: true,
                      selectAll: true,
                    ),
                    decoration: InputDecoration.collapsed(
                      hintText: "Type here. . .",
                    ),
                    style: widget.style,
                  ),
                ),
              )
            : Expanded(
                child: ZMarkdownParse(
                  data: _internalController.text,
                ),
              ),

        // show toolbar
        if (widget.enableToolBar)
          ZMarkdownToolbar(
            controller: _internalController,
            isPreview: _isPreview,
            autoCloseAfterSelectEmoji: widget.autoCloseAfterSelectEmoji,
            onPreviewChanged: () {
              _isPreview = _isPreview ? false : true;
              setState(() {});
            },
            focusNode: _internalFocus,
            emojiConvert: widget.emojiConvert,
          ),
      ],
    );
  }

  void _onEditorChange(String value) {
    String newValue = value;

    if (widget.emojiConvert) {
      newValue = value.replaceAllMapped(
        RegExp(r'\:[^\s]+\:'),
        (match) => _emojiParser.emojify(match[0]!),
      );
      var currentPosition = _internalController.selection;

      if (value.length > newValue.length) {
        currentPosition = TextSelection.collapsed(
          offset: newValue.length,
        );
      }

      _internalController.value = _internalController.value.copyWith(
        text: newValue,
        selection: currentPosition,
      );
    }

    widget.onChanged?.call(newValue);
  }

  @override
  void dispose() {
    widget.scrollController?.dispose();
    widget.controller?.dispose();
    _internalController.dispose();
    _internalFocus.dispose();
    super.dispose();
  }
}
