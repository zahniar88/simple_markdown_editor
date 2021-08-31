import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../src/emoji_parser.dart';

class ModalSelectEmoji extends StatefulWidget {
  ModalSelectEmoji({
    Key? key,
    this.onChanged,
    this.emojiConvert = true,
  }) : super(key: key);

  final bool emojiConvert;
  final ValueChanged<String>? onChanged;

  @override
  _ModalSelectEmojiState createState() => _ModalSelectEmojiState();
}

class _ModalSelectEmojiState extends State<ModalSelectEmoji> {
  final _parser = EmojiParser();

  String _search = "";
  final List<String> _emoticons = [
    ":blush:",
    ":smirk:",
    ":kissing_closed_eyes:",
    ":satisfied:",
    ":stuck_out_tongue_winking_eye:",
    ":kissing:",
    ":sleeping:",
    ":anguished:",
    ":confused:",
    ":unamused:",
    ":disappointed_relieved:",
    ":disappointed:",
    ":cold_sweat:",
    ":sob:",
    ":scream:",
    ":angry:",
    ":sleepy:",
    ":sunglasses:",
    ":innocent:",
    ":smiley:",
    ":heart_eyes:",
    ":flushed:",
    ":grin:",
    ":stuck_out_tongue_closed_eyes:",
    ":kissing_smiling_eyes:",
    ":worried:",
    ":open_mouth:",
    ":hushed:",
    ":sweat_smile:",
    ":weary:",
    ":confounded:",
    ":persevere:",
    ":joy:",
    ":rage:",
    ":yum:",
    ":dizzy_face:",
    ":neutral_face:",
    ":relaxed:",
    ":kissing_heart:",
    ":relieved:",
    ":wink:",
    ":grinning:",
    ":stuck_out_tongue:",
    ":frowning:",
    ":grimacing:",
    ":expressionless:",
    ":sweat:",
    ":pensive:",
    ":fearful:",
    ":cry:",
    ":astonished:",
    ":tired_face:",
    ":triumph:",
    ":mask:",
    ":no_mouth:",
    ":heart:",
    ":broken_heart:",
    ":star:",
    ":star2:",
    ":exclamation:",
    ":question:",
    ":fire:",
    ":shit:",
    ":thumbsup:",
    ":thumbsdown:",
    ":punch:",
    ":raised_hands:",
    ":clap:",
    ":pray:",
    ":ok_hand:",
    ":muscle:",
    ":dash:",
    ":zzz:",
    ":sweat_drops:",
    ":wave:",
    ":point_up:",
    ":point_down:",
    ":point_left:",
    ":point_right:",
    ":x:",
    ":white_check_mark:",
    ":negative_squared_cross_mark:",
    ":100:",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Emoticons",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.search,
                  size: 17,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration.collapsed(
                      hintText: "Find emoji",
                    ),
                    onChanged: (String value) {
                      _search = value;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom * 0.2,
            ),
            child: _listEmots(context),
          ),
        ],
      ),
    );
  }

  Widget _listEmots(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9,
        ),
        itemCount: _emoticons
            .where((element) =>
                element.toLowerCase().contains(_search.toLowerCase()))
            .length,
        itemBuilder: (context, index) {
          var emot = _emoticons
              .where((element) =>
                  element.toLowerCase().contains(_search.toLowerCase()))
              .elementAt(index);

          return TextButton(
            key: ValueKey<String>("${index}_${emot.replaceAll(":", "")}"),
            onPressed: () {
              widget.onChanged?.call(
                (widget.emojiConvert) ? _parser.emojify(emot) : emot,
              );
            },
            child: Text(
              _parser.emojify(emot),
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emoticons.clear();
    super.dispose();
  }
}
