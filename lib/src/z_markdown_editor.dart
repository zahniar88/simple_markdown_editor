import 'package:flutter/material.dart';
import 'package:simple_markdown_editor/simple_markdown_editor.dart';
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
  })  : this._enableToolbar = enableToolbar,
        this._controller = controller,
        this._scrollController = scrollController,
        this._onChanged = onChanged,
        this._style = style,
        this._emojiConvert = emojiConvert,
        super(key: key);

  /// external parameter
  final bool _enableToolbar;
  final TextEditingController? _controller;
  final ScrollController? _scrollController;
  final ValueChanged<String>? _onChanged;
  final TextStyle? _style;
  final bool _emojiConvert;

  @override
  _ZMarkdownEditorState createState() => _ZMarkdownEditorState();
}

class _ZMarkdownEditorState extends State<ZMarkdownEditor> {
  // internal parameter
  late bool _isPreview;
  late TextEditingController _internalController;
  late FocusNode _internalFocus;

  @override
  void initState() {
    _internalController = widget._controller != null
        ? widget._controller!
        : TextEditingController();
    _internalFocus = FocusNode();
    _isPreview = false;
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
    widget._onChanged?.call(value);
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
