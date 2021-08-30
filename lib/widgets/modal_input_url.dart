import 'package:flutter/material.dart';
import 'package:simple_markdown_editor/src/toolbar.dart';

class ModalInputUrl extends StatelessWidget {
  const ModalInputUrl({
    Key? key,
    required this.toolbar,
    required this.leftText,
    required this.selection,
  }) : super(key: key);

  final Toolbar toolbar;
  final String leftText;
  final TextSelection selection;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      padding: EdgeInsets.all(30),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Please provide a URL here.",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 15),
            padding: EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 15,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              autocorrect: false,
              autofocus: true,
              cursorRadius: Radius.circular(20),
              decoration: InputDecoration.collapsed(
                hintText: "Input your url.",
              ),
              style: TextStyle(
                fontSize: 16,
              ),
              enableInteractiveSelection: true,
              onSubmitted: (String value) {
                Navigator.pop(context);

                /// check if the user entered an empty input
                if (value.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Please input url",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.red.withOpacity(0.8),
                      duration: Duration(milliseconds: 700),
                    ),
                  );
                } else {
                  if (!value.contains(RegExp(r'https?:\/\/(www.)?([^\s]+)'))) {
                    value = "http://" + value;
                  }
                  toolbar.action(
                    "$leftText$value)",
                    "",
                    textSelection: selection,
                  );
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
  }
}
