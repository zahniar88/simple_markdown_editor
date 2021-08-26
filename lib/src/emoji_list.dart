import 'package:flutter/material.dart';
import 'emoji_parser.dart';

class EmojiList extends StatelessWidget {
  EmojiList({
    Key? key,
    ValueChanged<String>? onChanged,
    bool emojiConvert = true,
  })  : this._onChanged = onChanged,
        this._emojiConvert = emojiConvert,
        super(key: key);

  final _parser = EmojiParser();
  final bool _emojiConvert;
  final ValueChanged<String>? _onChanged;
  final List<String> _emoticons = [
    ":smiley:",
    ":blush:",
    ":heart_eyes:",
    ":angry:",
    ":sweat_smile:",
    ":grin:",
    ":kissing_heart:",
    ":stuck_out_tongue:",
    ":joy:",
    ":wink:",
    ":sleepy:",
    ":kissing_closed_eyes:",
    ":kissing:",
    ":sleeping:",
    ":disappointed:",
    ":sob:",
    ":sunglasses:",
    ":innocent:",
    ":yum:",
    ":open_mouth:",
    ":tired_face:",
    ":cry:",
    ":triumph:",
    ":expressionless:",
    ":relieved:",
    ":worried:",
    ":neutral_face:",
    ":dizzy_face:",
    ":stuck_out_tongue_winking_eye:",
    ":flushed:",
    ":grimacing:",
    ":mask:",
    ":no_mouth:",
    ":no_good:",
    ":weary:",
    ":rage:",
    ":heart:",
    ":broken_heart:",
    ":sweat_drops:",
    ":pray:",
    ":muscle:",
    ":raised_hands:",
    ":punch:",
    ":fire:",
    ":clap:",
    ":point_down:",
    ":point_left:",
    ":point_right:",
    ":point_up:",
    ":-1:",
    ":+1:",
    ":exclamation:",
    ":grey_exclamation:",
    ":grey_question:",
    ":question:",
    ":boom:",
    ":star:",
    ":shit:",
    ":zzz:",
    ":star2:",
    ":dash:",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Emoticons (${_emoticons.length})",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Wrap(
              runSpacing: 10,
              spacing: 10,
              children: _emoticons
                  .map(
                    (emot) => TextButton(
                      onPressed: () {
                        _onChanged?.call(
                          (_emojiConvert) ? _parser.emojify(emot) : emot,
                        );
                      },
                      child: Text(
                        _parser.emojify(emot),
                        style: TextStyle(
                          fontSize: 32,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
