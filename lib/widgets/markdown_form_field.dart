import 'package:flutter/material.dart';
import 'markdown_field.dart';
import 'markdown_parse.dart';
import 'markdown_toolbar.dart';

class MarkdownFormField extends StatefulWidget {
  const MarkdownFormField({
    Key? key,
    this.controller,
    this.scrollController,
    this.onChanged,
    this.style,
    this.emojiConvert = false,
    this.onTap,
    this.enableToolBar = false,
    this.autoCloseAfterSelectEmoji = true,
    this.textCapitalization = TextCapitalization.sentences,
    this.readOnly = false,
    this.cursorColor,
    this.focusNode,
    this.padding = const EdgeInsets.all(10),
  }) : super(key: key);

  /// For enable toolbar options
  ///
  /// if false, toolbar widget will not display
  final bool enableToolBar;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  final ScrollController? scrollController;

  /// Configures how the platform keyboard will select an uppercase or lowercase keyboard.
  ///
  /// Only supports text keyboards, other keyboard types will ignore this configuration. Capitalization is locale-aware.
  ///
  /// Defaults to [TextCapitalization.none]. Must not be null.
  ///
  /// See also:
  /// * [TextCapitalization], for a description of each capitalization behavior.
  final TextCapitalization textCapitalization;

  /// See also:
  ///
  /// * [inputFormatters], which are called before [onChanged] runs and can validate and change
  /// ("format") the input value.
  /// * [onEditingComplete], [onSubmitted]: which are more specialized input change notifications.
  final ValueChanged<String>? onChanged;

  /// The style to use for the text being edited.
  ///
  /// This text style is also used as the base style for the [decoration].
  ///
  /// If null, defaults to the subtitle1 text style from the current [Theme].
  final TextStyle? style;

  /// to enable auto convert emoji
  ///
  /// if true, the string will be automatically converted to emoji
  ///
  /// example: :smiley: => 😃
  final bool emojiConvert;

  /// Called for each distinct tap except for every second tap of a double tap.
  ///
  /// The text field builds a [GestureDetector] to handle input events like tap, to trigger focus
  /// requests, to move the caret, adjust the selection, etc. Handling some of those events by wrapping
  /// the text field with a competing GestureDetector is problematic.
  ///
  /// To unconditionally handle taps, without interfering with the text field's internal gesture
  /// detector, provide this callback.
  ///
  /// If the text field is created with [enabled] false, taps will not be recognized.
  /// To be notified when the text field gains or loses the focus, provide a [focusNode] and add a
  /// listener to that.
  ///
  /// To listen to arbitrary pointer events without competing with the text field's internal gesture
  /// detector, use a [Listener].
  final VoidCallback? onTap;

  /// if you set it to false,
  /// the modal will not disappear after you select the emoji
  final bool autoCloseAfterSelectEmoji;

  /// Whether the text can be changed.
  ///
  /// When this is set to true, the text cannot be modified by any shortcut or keyboard operation. The text is still selectable.
  ///
  /// Defaults to false. Must not be null.
  final bool readOnly;

  /// The color of the cursor.
  ///
  /// The cursor indicates the current location of text insertion point in the field.
  ///
  /// If this is null it will default to the ambient [TextSelectionThemeData.cursorColor]. If that is
  /// null, and the [ThemeData.platform] is [TargetPlatform.iOS] or [TargetPlatform.macOS] it will use
  /// [CupertinoThemeData.primaryColor]. Otherwise it will use the value of [ColorScheme.primary] of
  /// [ThemeData.colorScheme].
  final Color? cursorColor;

  /// Defines the keyboard focus for this widget.
  ///
  /// The [focusNode] is a long-lived object that's typically managed by a [StatefulWidget] parent. See
  /// [FocusNode] for more information.
  ///
  /// To give the keyboard focus to this widget, provide a [focusNode] and then use the current
  /// [FocusScope] to request the focus:
  ///
  /// FocusScope.of(context).requestFocus(myFocusNode);
  /// This happens automatically when the widget is tapped.
  final FocusNode? focusNode;

  /// The amount of space by which to inset the child.
  final EdgeInsetsGeometry padding;

  @override
  _MarkdownFormFieldState createState() => _MarkdownFormFieldState();
}

class _MarkdownFormFieldState extends State<MarkdownFormField> {
  // internal parameter
  late TextEditingController _internalController;
  late FocusNode _internalFocus;
  bool _focused = false;

  @override
  void initState() {
    _internalController = widget.controller != null
        ? widget.controller!
        : TextEditingController();
    _internalFocus = widget.focusNode != null ? widget.focusNode! : FocusNode();
    _internalFocus.addListener(() => _requestFocused());
    super.initState();
  }

  void _requestFocused() {
    if (_internalFocus.hasFocus) {
      _focused = true;
    } else {
      _focused = false;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _focused
        ? _editorOnFocused()
        : GestureDetector(
            onTap: () {
              _focused = true;
              _internalFocus.requestFocus();
              setState(() {});
            },
            child: MarkdownParse(
              key: const ValueKey<String>("zmarkdownparse"),
              data: _internalController.text == ""
                  ? "Type here. . ."
                  : _internalController.text,
            ),
          );
  }

  Widget _editorOnFocused() {
    return !widget.enableToolBar
        ? _editor()
        : Column(
            children: [
              _editor(),

              // show toolbar
              if (!widget.readOnly)
                MarkdownToolbar(
                  key: const ValueKey<String>("zmarkdowntoolbar"),
                  controller: _internalController,
                  autoCloseAfterSelectEmoji: widget.autoCloseAfterSelectEmoji,
                  isEditorFocused: (bool status) {
                    _focused = status;
                    setState(() {});
                  },
                  onPreviewChanged: () {
                    _focused = _focused ? false : true;
                    FocusScope.of(context).unfocus();
                    setState(() {});
                  },
                  focusNode: _internalFocus,
                  emojiConvert: widget.emojiConvert,
                ),
            ],
          );
  }

  Widget _editor() {
    return MarkdownField(
      controller: _internalController,
      focusNode: _internalFocus,
      cursorColor: widget.cursorColor,
      emojiConvert: widget.emojiConvert,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      scrollController: widget.scrollController,
      style: widget.style,
      textCapitalization: widget.textCapitalization,
      padding: widget.padding,
    );
  }
}
