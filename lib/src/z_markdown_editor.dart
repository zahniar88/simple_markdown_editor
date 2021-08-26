import 'package:flutter/material.dart';
import 'package:simple_markdown_editor/simple_markdown_editor.dart';
import 'package:simple_markdown_editor/src/emoji_parser.dart';
import 'package:simple_markdown_editor/src/z_markdown_toolbar.dart';

class ZMarkdownEditor extends StatefulWidget {
  const ZMarkdownEditor({
    Key? key,
    bool enableToolbar = true,
    TextEditingController? controller,
    ScrollController? scrollController,
    ValueChanged<String>? onChanged,
    TextStyle? style,
    bool emojiConvert = false,
    VoidCallback? onTap,
    FormFieldValidator<String?>? validator,
  })  : this._enableToolbar = enableToolbar,
        this._controller = controller,
        this._scrollController = scrollController,
        this._onChanged = onChanged,
        this._style = style,
        this._emojiConvert = emojiConvert,
        this._onTap = onTap,
        this._validator = validator,
        super(key: key);

  /// external parameter
  final bool _enableToolbar;
  final TextEditingController? _controller;
  final ScrollController? _scrollController;
  final ValueChanged<String>? _onChanged;
  final TextStyle? _style;
  final bool _emojiConvert;
  final VoidCallback? _onTap;
  final FormFieldValidator<String?>? _validator;

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
    _internalController = widget._controller != null
        ? widget._controller!
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
                    scrollController: widget._scrollController,
                    onChanged: _onEditorChange,
                    onTap: widget._onTap,
                    validator: widget._validator,
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
                    style: widget._style,
                  ),
                ),
              )
            : Expanded(
                child: ZMarkdownParse(
                  data: _internalController.text,
                ),
              ),

        // show toolbar
        if (widget._enableToolbar)
          ZMarkdownToolbar(
            controller: _internalController,
            isPreview: _isPreview,
            onPreviewChanged: () {
              _isPreview = _isPreview ? false : true;
              setState(() {});
            },
            focusNode: _internalFocus,
            emojiConvert: widget._emojiConvert,
          ),
      ],
    );
  }

  void _onEditorChange(String value) {
    String newValue = value;

    if (widget._emojiConvert) {
      newValue = value.replaceAllMapped(
        RegExp(r'\:[^\s]+\:'),
        (match) => _emojiParser.emojify(match[0]!),
      );

      _internalController.value = _internalController.value.copyWith(
        text: newValue,
        selection: TextSelection.collapsed(
          offset: newValue.length,
        ),
      );
    }

    widget._onChanged?.call(newValue);
  }

  @override
  void dispose() {
    widget._scrollController?.dispose();
    widget._controller?.dispose();
    _internalController.dispose();
    _internalFocus.dispose();
    super.dispose();
  }
}
