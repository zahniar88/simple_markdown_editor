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
  })  : this._enableToolbar = enableToolbar,
        this._controller = controller,
        this._scrollController = scrollController,
        this._onChanged = onChanged,
        this._style = style,
        super(key: key);

  /// external parameter
  final bool _enableToolbar;
  final TextEditingController? _controller;
  final ScrollController? _scrollController;
  final ValueChanged<String>? _onChanged;
  final TextStyle? _style;

  @override
  _ZMarkdownEditorState createState() => _ZMarkdownEditorState();
}

class _ZMarkdownEditorState extends State<ZMarkdownEditor> {
  // internal parameter
  late bool _isPreview;
  late String _textPreviewResult;
  late TextEditingController _internalController;
  late FocusNode _internalFocus;

  @override
  void initState() {
    _internalController = TextEditingController();
    _internalFocus = FocusNode();
    _isPreview = false;
    _textPreviewResult = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget._enableToolbar)
          ZMarkdownToolbar(
            onToolbarChanged: (String value) {
              setState(() {
                _textPreviewResult = value;
              });
            },
            controller: (widget._controller != null)
                ? widget._controller!
                : _internalController,
            isPreview: _isPreview,
            onPreviewChanged: () {
              _isPreview = _isPreview ? false : true;
              setState(() {});
            },
            focusNode: _internalFocus,
          ),
        !_isPreview
            ? Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    maxLines: null,
                    focusNode: _internalFocus,
                    controller: (widget._controller != null)
                        ? widget._controller
                        : _internalController,
                    scrollController: widget._scrollController,
                    onChanged: (String value) {
                      widget._onChanged?.call(value);
                      setState(() {
                        _textPreviewResult = value;
                      });
                    },
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
                  data: _textPreviewResult,
                ),
              ),
      ],
    );
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
