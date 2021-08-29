import 'package:flutter/material.dart';

class ToolbarResult {
  final int offset;
  final String text;

  ToolbarResult({required this.offset, required this.text});
}

class Toolbar {
  final TextEditingController controller;
  final FocusNode focusNode;

  Toolbar({required this.controller, required this.focusNode});

  // check if have selection text
  bool checkHasSelection() {
    return (controller.selection.baseOffset -
            controller.selection.extentOffset) !=
        0;
  }

  // toolbar action
  void action(
    String left,
    String right, {
    TextSelection? textSelection,
  }) async {
    focusNode.requestFocus();
    await Future.delayed(Duration(milliseconds: 1));

    // default parameter
    final currentTextValue = controller.value.text;
    final selection =
        textSelection != null ? textSelection : controller.selection;
    final middle = selection.textInside(currentTextValue);
    var selectionText = '$left$middle$right';
    var contentOffset = left.length + middle.length;

    // check if middle text have char \n
    if (middle.split("\n").length > 1) {
      ToolbarResult result = _multiLineFormating(left, middle, right);
      selectionText = result.text;
      contentOffset = result.offset;
    }

    // check if middle not have char \n
    if (middle.contains(left) &&
        middle.contains(right) &&
        middle.split("\n").length < 2) {
      selectionText = middle.replaceFirst(left, "");
      selectionText = selectionText.replaceFirst(right, "");
      contentOffset = middle.length - (left.length + right.length);
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

  // multiline formating
  ToolbarResult _multiLineFormating(String left, String middle, String right) {
    final splitData = middle.split("\n");
    var index = 0;
    var resetLength = 0;
    var addLength = 0;

    final selectionText = splitData.map((text) {
      index++;
      addLength += left.length + right.length;

      if (text.contains(left) && text.contains(right)) {
        resetLength += left.length + right.length;

        return index == splitData.length
            ? text.replaceFirst(left, "").replaceFirst(right, "")
            : text.replaceFirst(left, "").replaceFirst(right, "") + "\n";
      }

      if (text.trim().isEmpty) {
        addLength -= left.length + right.length;
      }

      final newText = text.trim().isEmpty ? text : "$left$text$right";
      return index == splitData.length ? newText : "$newText\n";
    }).join();

    final contentOffset = addLength + (middle.length - (resetLength * 2));

    return ToolbarResult(offset: contentOffset, text: selectionText);
  }
}
