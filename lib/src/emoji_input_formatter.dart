import 'package:flutter/services.dart';
import 'package:simple_markdown_editor/src/emoji_parser.dart';

class EmojiInputFormatter extends TextInputFormatter {
  final EmojiParser _emojiParser = EmojiParser();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var currentPosition = newValue.selection;

    final resultValue = newValue.text.replaceAllMapped(
      RegExp(r'\:[^\s]+\:'),
      (match) {
        if (_emojiParser.hasName(match[0]!)) {
          final convert = _emojiParser.emojify(match[0]!);
          final resetOffset = match[0]!.length - convert.length;
          final lastPositionOnMatch =
              newValue.text.indexOf(match[0]!) + match[0]!.length;
          var minusOffset = 0;

          if ((currentPosition.baseOffset - lastPositionOnMatch) < 0) {
            minusOffset =
                (currentPosition.baseOffset - lastPositionOnMatch).abs();
          }

          //
          currentPosition = TextSelection.collapsed(
            offset: currentPosition.baseOffset - resetOffset + minusOffset,
          );
          return convert;
        }

        return match[0]!;
      },
    );

    return TextEditingValue(
      text: resultValue,
      selection: currentPosition,
    );
  }
}
